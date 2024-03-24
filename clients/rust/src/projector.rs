use crate::processor::Process;

const DEFAULT_PROJECTOR_ADDR: &'static str = "127.0.0.1";
const DEFAULT_PROJECTOR_PORT: u32 = 41794;

pub struct Projector {
    addr: String,
    port: u32,
}

impl Projector {
    pub fn new() -> Projector {
        Projector {
            addr: DEFAULT_PROJECTOR_ADDR.to_string(),
            port: DEFAULT_PROJECTOR_PORT,
        }
    }
}

impl Process for Projector {
    fn process(&self) {
        println!("Running... {}:{}", self.addr, self.port);
    }
}
