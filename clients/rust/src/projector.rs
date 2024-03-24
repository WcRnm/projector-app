use crate::processor::Process;
use crate::projector_info::PacketType;

use std::io::Read;
use std::net::TcpStream;

const DEFAULT_PROJECTOR_ADDR: &'static str = "127.0.0.1";
const DEFAULT_PROJECTOR_PORT: u32 = 41794;

const READ_BUFFER_SIZE: usize = 1024;

pub struct Projector {
    addr: String,
    port: u32,
    stream: Option<TcpStream>,
    read_buf: Vec<u8>,
}

impl Projector {
    pub fn new() -> Projector {
        Projector {
            addr: DEFAULT_PROJECTOR_ADDR.to_string(),
            port: DEFAULT_PROJECTOR_PORT,
            stream: None,
            read_buf: Vec::new(),
        }
    }

    fn connect(&mut self) -> bool {
        if self.stream.is_none() {
            let addr = format!("{}:{}", self.addr, self.port);

            println!("Connect to {}", addr);

            let result = TcpStream::connect(addr);
            match result {
                Ok(stream) => {
                    println!("Connected");
                    self.stream = Some(stream);
                    return true;
                }
                Err(err) => {
                    println!("Connect failed {}", err);
                }
            }
        }
        false
    }

    fn handle_data(&mut self, data: &[u8]) {
        println!("Read {} bytes", data.len());

        self.read_buf.extend_from_slice(data);
        if self.read_buf.len() < 6 {
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

    //fn handle_packet(&mut self, _packet: &[u8]) {
    fn handle_packet(&self, packet_len: usize) {
        let packet = &self.read_buf[0..packet_len];

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

    fn handle_connect_response(&self, _packet: &[u8]) {
        println!("ConnectResponse");
    }
    fn handle_disconnect(&self, _packet: &[u8]) {
        println!("Disconnect");
    }
    fn handle_data_packet(&self, _packet: &[u8]) {
        println!("Data");
    }
    fn handle_heartbeat(&self, _packet: &[u8]) {
        println!("Heartbeat");
    }
    fn handle_connect_status(&self, _packet: &[u8]) {
        println!("ConnectStatus");
    }
}

impl Process for Projector {
    fn process(&mut self) -> bool {
        if self.connect() {
            let mut rx_bytes = [0u8; READ_BUFFER_SIZE];
            let bytes_read = self.stream.as_ref().unwrap().read(&mut rx_bytes);
            match bytes_read {
                Ok(len) => {
                    self.handle_data(&rx_bytes[..len]);
                    if len == READ_BUFFER_SIZE {
                        return true;
                    }
                }
                Err(err) => {
                    println!("Read error: {err}");
                }
            }
        }
        false
    }
}
