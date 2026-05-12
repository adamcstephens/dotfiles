use console::Style;

pub fn info(msg: &str) {
    eprintln!("{msg}");
}

pub fn error(err: &anyhow::Error) {
    let style = Style::new().for_stderr().red().bold();
    let dim = Style::new().for_stderr().dim();
    eprintln!("{} {}", style.apply_to("✗ error:"), err);
    for cause in err.chain().skip(1) {
        eprintln!("  {}", dim.apply_to(cause));
    }
}
