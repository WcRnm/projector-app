use crate::projector::info::*;

use std::str;

pub struct Handler {
    connected: bool,
    session_id: u16,
    read_buf: Vec<u8>,
    caps: Capabilites,
}

impl Handler {
    pub fn new() -> Handler {
        Handler {
            connected: false,
            session_id: 0,
            read_buf: Vec::new(),
            caps: Capabilites::new(),
        }
    }

    fn next_packet_len(&self, data: &[u8]) -> usize {
        if self.read_buf.len() < 3 {
            return 0;
        }

        let a = data[1] as usize;
        let b = data[2] as usize;

        let payload_len = a * 256 + b + 3;

        if data.len() < payload_len {
            0
        } else {
            payload_len
        }
    }

    fn reset(&mut self) {
        self.connected = false;
        self.session_id = 0;
        self.read_buf.clear();
        self.caps = Capabilites::new();
    }

    fn on_disconnect(&self) {
        self.submit_task(Task::Reset);
    }

    fn submit_task(&self, _task: Task) {}

    fn submit_digtal(&self, _id: u16, _val: bool) {
        //self.submit_task(TASK_VALUE, data_id, DATA_BOOL, value)
    }

    fn submit_analog(&self, _id: u16, _val: u32) {
        //self.submit_task(TASK_VALUE, data_id, DATA_ANALOG, value)
    }

    fn submit_text(&self, _id: u16, _val: &str) {
        //self.submit_task(TASK_VALUE, data_id, DATA_TEXT, msg)
    }

    fn handle_task(&mut self, task: Task) {
        match task {
            Task::Connect => {}
            Task::RequestInfo => {}
            Task::Reset => self.reset(),
            Task::EndOfQuery => {}
        }
    }

    fn handle_packet(&mut self, packet_len: usize) {
        let mut packet = vec![0; packet_len]; // = [0; packet_len];
        packet.copy_from_slice(&self.read_buf[0..packet_len]);
        let packet_type = PacketType::n(packet[0]);

        match packet_type {
            Some(p) => match p as PacketType {
                PacketType::ConnectResponse => {
                    self.handle_connect_response(packet);
                }
                PacketType::Disconnect | PacketType::Disconnect2 => {
                    self.handle_disconnect(packet);
                }
                PacketType::Data => {
                    self.handle_data_packet(packet);
                }
                PacketType::Heartbeat => {
                    self.handle_heartbeat(packet);
                }
                PacketType::ConnectStatus => {
                    self.handle_connect_status(packet);
                }
            },
            None => {}
        }
    }

    fn handle_connect_response(&mut self, packet: Vec<u8>) {
        println!("ConnectResponse");

        if self.connected || packet.len() < 6 {
            return;
        }

        self.session_id = packet[3] as u16 * 256 + packet[4] as u16;

        if packet.len() >= 7 {
            let supported = (1 & packet[6]) == 1;
            self.caps.heartbeat = supported;
            self.caps.repeat_digitals = supported;
        }

        self.connected = true;

        println!("Connected: caps:{:?}", self.caps);
        self.submit_task(Task::RequestInfo)
    }

    fn handle_disconnect(&self, _packet: Vec<u8>) {
        println!("Disconnect");
    }

    fn handle_data_packet(&self, data: Vec<u8>) {
        println!("Data");

        if data[5] > 0 {
            let offset = if data[6] == 32 { 3 } else { 0 };
            let data_type = data[6 + offset];
            match data_type {
                0 => self.handle_digital(data, offset),
                1 | 20 => self.handle_analog(data, offset),
                21 => self.handle_serial1(data, offset),
                18 => self.handle_serial2(data, offset),
                2 => self.handle_serial3(data, offset),
                3 => self.handle_end_of_query(data, offset),
                _ => {}
            }
        }
    }

    fn handle_digital(&self, data: Vec<u8>, offset: usize) {
        if data[5 + offset] != 3 {
            return;
        }

        let mut data_id = (data[8 + offset] as u16 * 256) + data[7 + offset] as u16;
        data_id = (data_id & 32767) + 1; // (data_id & 0x7FFF) + 1
        let value = (data[8 + offset] & 128) != 128; // 0x80

        self.submit_digtal(data_id, value);
    }

    fn handle_analog(&self, data: Vec<u8>, offset: usize) {
        let mut data_id: u16 = data[7 + offset] as u16 + 1;
        let t = data[5 + offset];
        let value: u32;
        match t {
            3 => value = data[8 + offset] as u32,
            4 => value = data[8 + offset] as u32 * 256 + data[9 + offset] as u32,
            5 => {
                data_id = data_id as u16 * 256 + data[8 + offset] as u16;
                value = data[9 + offset] as u32 * 256 + data[10 + offset] as u32;
            }
            _ => {
                return;
            }
        }
        self.submit_analog(data_id, value);
    }

    fn handle_text_msg(&self, data_id: u16, msg: &[u8]) {
        match str::from_utf8(msg) {
            Ok(s) => self.submit_text(data_id, &s),
            Err(e) => {
                println!("Invalid UTF-8 sequence: {}", e);
                return;
            }
        };
    }

    fn handle_serial1(&self, data: Vec<u8>, offset: usize) {
        let data_id = (data[7 + offset] as u16 * 256) + data[8 + offset] as u16 + 1;
        let n = data[5 + offset] as usize - 4;
        let start = 10 + offset;
        let end = start + n;

        let msg = &data[start..end];
        self.handle_text_msg(data_id, msg);
    }

    fn handle_serial2(&self, data: Vec<u8>, offset: usize) {
        let data_id = data[7 + offset] as u16 + 1;
        let n = data[5 + offset] as usize - 2;
        let start = 8 + offset;
        let end = start + n;

        let msg = &data[start..end];
        self.handle_text_msg(data_id, msg);
    }

    fn handle_serial3(&self, data: Vec<u8>, offset: usize) {
        if data[7 + offset] != 35 {
            return;
        }

        let mut msg = Vec::new();
        let mut i = 8 + offset;
        let j = i + (data[5 + offset] as usize - 2);
        while j > i {
            let mut data_id: u16 = 0;
            while 48 <= data[i] && data[i] <= 57 {
                i += 1;
                data_id = data_id * 10 + (data[i] as u16 - 48);
            }

            msg.clear();
            i += 1;
            while i < j && data[i] != 13 {
                i += 1;
                msg.push(data[i]);
            }

            self.handle_text_msg(data_id, &msg[..]);

            i += 2;
        }
    }

    fn handle_end_of_query(&self, _data: Vec<u8>, _offset: usize) {
        self.submit_task(Task::EndOfQuery);
    }

    fn handle_heartbeat(&self, _packet: Vec<u8>) {
        println!("Heartbeat");
    }
    fn handle_connect_status(&self, packet: Vec<u8>) {
        println!("ConnectStatus");

        if packet.len() < 4 {
            return;
        }

        let action = packet[3];
        match action {
            0 => self.on_disconnect(),
            2 => {
                if !self.connected {
                    self.submit_task(Task::Connect)
                }
            }
            _ => {}
        }
    }
}

impl ProjectorHandler for Handler {
    fn on_rx(&mut self, data: &[u8]) {
        println!("on_rx: {} bytes", data.len());

        self.read_buf.extend_from_slice(data);
        if self.read_buf.len() < 4 {
            return;
        }

        let packet_len = self.next_packet_len(data);
        if packet_len == 0 {
            return;
        }
        if self.read_buf.len() < packet_len {
            return;
        }

        self.handle_packet(packet_len);

        self.read_buf.drain(0..packet_len);
    }
}

struct MsgGenerator {
    id: u16
}

impl MsgGenerator {
    pub fn connect(&self) -> [u8; 10] {
        return [
            1,
            0,
            7,
            0,
            0,
            0,
            0,
            (self.id / 256) as u8,
            (self.id % 256) as u8,
            64
        ];
    }

    pub fn end_of_query_response(&self) -> [u8; 8] {
        return [
            5,
            0,
            5,
            (self.id / 256) as u8,
            (self.id % 256) as u8,
            2,
            3,
            29
        ];
    }

    fn msg_update_request(&self) -> [u8; 8] {
        return [
            5,
            0,
            5,
            (self.id / 256) as u8,
            (self.id % 256) as u8,
            2,
            3,
            30
        ];
    }
}