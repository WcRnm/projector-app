use crate::process::process::Process;
use crate::projector::info::*;
use crate::projector::infocus_in2128hdx;

use std::io::Read;
use std::io::Write;
use std::net::TcpStream;
use std::sync::mpsc;
use std::sync::mpsc::{Receiver, Sender};

const READ_BUFFER_SIZE: usize = 1024;
//const DEFAULT_LOCATION: &'static str = "Sanctuary";

pub enum ProjectorType {
    InfocusIN2128HDx,
}

pub struct Projector {
    addr: String,
    port: u32,
    stream: Option<TcpStream>,
    handler: Box<dyn ProjectorHandler + Send>,
    send_rx: Receiver<Vec<u8>>,
}

impl Projector {
    pub fn new(_projector_type: ProjectorType) -> Projector {
        let (send_tx, send_rx): (Sender<Vec<u8>>, Receiver<Vec<u8>>) = mpsc::channel();

        let handler = Box::new(infocus_in2128hdx::Handler::new(send_tx));

        Projector {
            addr: DEFAULT_ADDR.to_string(),
            port: DEFAULT_PORT,
            stream: None,
            handler: handler,
            send_rx: send_rx,
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
        //println!("++process");
        let mut more_data = false;
        if self.connect() {
            let mut rx_bytes = [0u8; READ_BUFFER_SIZE];
            let bytes_read = self.stream.as_ref().unwrap().read(&mut rx_bytes);
            match bytes_read {
                Ok(len) => {
                    self.handler.on_rx(&rx_bytes[..len]);
                    more_data = len == READ_BUFFER_SIZE;
                }
                Err(err) => {
                    println!("Read error: {err}");
                    return false;
                }
            }

            loop {
                let rcvd = self.send_rx.try_recv();
                match rcvd {
                    Ok(msg) => {
                        let _bytes_sent = self.stream.as_ref().unwrap().write_all(&msg);
                    }
                    Err(_) => {
                        break;
                    }
                }
            }
        }
        self.handler.on_idle();
        //println!("--process {}", more_data);
        more_data
    }
}

impl ProjectorSender for Projector {
    fn send(&mut self, data: &[u8]) {
        match self.stream {
            Some(ref mut s) => {
                let _bytes_written = s.write(data);
                let _ = s.flush();
            }
            None => {}
        }
    }
}
