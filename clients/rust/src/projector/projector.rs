use crate::process::process::Process;
use crate::projector::info::*;
use crate::projector::infocus_in2128hdx;

use std::io::Read;
use std::net::TcpStream;

const READ_BUFFER_SIZE: usize = 1024;

pub enum ProjectorType {
    InfocusIN2128HDx,
}

pub struct Projector {
    addr: String,
    port: u32,
    stream: Option<TcpStream>,
    handler: Box<dyn ProjectorHandler + Send>,
}

impl Projector {
    pub fn new(_projector_type: ProjectorType) -> Projector {
        Projector {
            addr: DEFAULT_ADDR.to_string(),
            port: DEFAULT_PORT,
            stream: None,
            handler: Box::new(infocus_in2128hdx::Handler::new()),
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
}

impl Process for Projector {
    fn process(&mut self) -> bool {
        if self.connect() {
            let mut rx_bytes = [0u8; READ_BUFFER_SIZE];
            let bytes_read = self.stream.as_ref().unwrap().read(&mut rx_bytes);
            match bytes_read {
                Ok(len) => {
                    self.handler.on_rx(&rx_bytes[..len]);
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
