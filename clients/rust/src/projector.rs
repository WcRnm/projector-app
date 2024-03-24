const DEFAULT_PROJECTOR_ADDR: &'static str = "127.0.0.1";
const DEFAULT_PROJECTOR_PORT: u32          = 41794;

pub trait Processor {
    fn start(&mut self);
    fn stop(&mut self);
    fn is_running(&self) -> bool;

    fn process(&mut self);
}

pub struct Projector {
    running: bool,
    addr: String,
     port: u32,
}

impl Projector {
    pub fn new() -> Projector {
        Projector {
            running: false,
            addr: DEFAULT_PROJECTOR_ADDR.to_string(),
            port: DEFAULT_PROJECTOR_PORT
        } 
    }
}

impl Processor for Projector {
    fn start(&mut self) {
        self.running = true;
    }

    fn stop(&mut self) {
        self.running = false;
    }

    fn is_running(&self) -> bool {
        self.running
    }

    fn process(&mut self) {
        println!("Running...");
    }
}