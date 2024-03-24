use crate::projector::info::*;

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

    fn handle_task(&mut self, task: Task) {
        match task {
            Task::Connect => {}
            Task::RequestInfo => {}
            Task::Reset => self.reset(),
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
                4_u8..=17_u8 | 19_u8 | 22_u8..=u8::MAX => {}
            }
        }
    }

    fn handle_digital(&self, _data: Vec<u8>, _offset: usize) {}
    fn handle_analog(&self, _data: Vec<u8>, _offset: usize) {}
    fn handle_serial1(&self, _data: Vec<u8>, _offset: usize) {}
    fn handle_serial2(&self, _data: Vec<u8>, _offset: usize) {}
    fn handle_serial3(&self, _data: Vec<u8>, _offset: usize) {}
    fn handle_end_of_query(&self, _data: Vec<u8>, _offset: usize) {}

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
            1_u8 | 3_u8..=u8::MAX => {}
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
