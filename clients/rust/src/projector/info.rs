pub const DEFAULT_ADDR: &'static str = "127.0.0.1";
pub const DEFAULT_PORT: u32 = 41794;

pub trait ProjectorHandler {
    fn handle_data(&mut self, data: &[u8]);
}

#[derive(Debug, enumn::N)]
#[repr(u8)]
pub enum PacketType {
    ConnectResponse = 2,
    Disconnect = 3,
    Disconnect2 = 4,
    Data = 5,
    Heartbeat = 14,
    ConnectStatus = 15,
}
