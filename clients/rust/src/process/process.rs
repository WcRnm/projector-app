pub trait Process {
    fn process(&mut self) -> bool;
}
