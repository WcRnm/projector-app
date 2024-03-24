mod processor;
mod projector;

use processor::{Process, Processor};
use projector::Projector;

slint::include_modules!();

fn main() -> Result<(), slint::PlatformError> {
    let projector = Projector::new();
    let mut processor = Processor::new(Box::new(projector) as Box<dyn Process + Send>);

    let ui = AppWindow::new()?;

    ui.on_request_increase_value({
        let ui_handle = ui.as_weak();
        move || {
            let ui = ui_handle.unwrap();
            ui.set_counter(ui.get_counter() + 1);
        }
    });

    processor.start();

    let ui_result = ui.run();

    processor.stop();

    ui_result
}
