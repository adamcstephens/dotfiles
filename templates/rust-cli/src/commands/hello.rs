use anyhow::Result;

use crate::ui;

pub fn cmd_hello(name: &str) -> Result<()> {
    ui::info(&format!("hello, {name}!"));
    Ok(())
}
