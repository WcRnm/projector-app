mod projector;
use projector::{Projector, Processor};

use std::sync::{Arc, Mutex};
use std::thread;
use std::time::Duration;

slint::include_modules!();

fn main() -> Result<(), slint::PlatformError> {
    let projector = Arc::new (Mutex::new(Projector::new()));

    let ui = AppWindow::new()?;

    ui.on_request_increase_value({
        let ui_handle = ui.as_weak();
        move || {
            let ui = ui_handle.unwrap();
            ui.set_counter(ui.get_counter() + 1);
        }
    });

    let handle;
    {
        let projector = Arc::clone(&projector);
        handle = thread::spawn(move || {
            worker(projector);
        });    
    }

    let ui_result = ui.run();

    projector.lock().unwrap().stop();

    handle.join().unwrap();

    ui_result
}


fn worker(projector: Arc<Mutex<dyn Processor>>) {
    projector.lock().unwrap().start();
    while projector.lock().unwrap().is_running() {
        thread::sleep(Duration::from_millis(250));
        projector.lock().unwrap().process()
    }
    projector.lock().unwrap().stop()
}