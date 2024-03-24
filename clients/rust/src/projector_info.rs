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
