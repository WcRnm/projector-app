use std::sync::{Arc, Mutex};
use std::thread;
use std::time::Duration;

use crate::Process;

struct ProcessorInner {
    running: bool,
    process: Box<dyn Process + Send>,
}

pub struct Processor {
    handle: Option<thread::JoinHandle<()>>,
    inner: Arc<Mutex<ProcessorInner>>,
}

impl Processor {
    pub fn new(process: Box<dyn Process + Send>) -> Processor {
        Processor {
            handle: None,
            inner: Arc::new(Mutex::new(ProcessorInner {
                running: false,
                process: process,
            })),
        }
    }

    pub fn start(&mut self) {
        if !self.inner.lock().unwrap().running {
            let inner = self.inner.clone();
            let handle = thread::spawn(move || {
                while inner.lock().unwrap().running {
                    let busy = inner.lock().unwrap().process.process();
                    if !busy {
                        thread::sleep(Duration::from_millis(250));
                    }
                }
            });

            self.handle = Some(handle);
            self.inner.lock().unwrap().running = true;
        }
    }

    pub fn stop(&mut self) {
        if self.inner.lock().unwrap().running {
            self.inner.lock().unwrap().running = false;
            self.handle
                .take()
                .expect("Called stop on non-running thread")
                .join()
                .expect("Could not join thread");
            self.handle = None
        }
    }
}
