use anyhow::Result;
use clap::{CommandFactory, Parser, Subcommand};
use clap_complete::Shell;
use clap_complete::engine::{ArgValueCompleter, CompletionCandidate};

mod commands;
mod ui;

/// Replace with runtime-computed candidates (read state from disk, query an
/// API, list files, etc.). Returning a static list here for illustration.
fn complete_name(current: &std::ffi::OsStr) -> Vec<CompletionCandidate> {
    let current = current.to_string_lossy();
    ["alice", "bob", "charlie"]
        .into_iter()
        .filter(|n| n.starts_with(current.as_ref()))
        .map(CompletionCandidate::new)
        .collect()
}

/// A Rust CLI starter.
#[derive(Parser)]
#[command(name = "myapp", version)]
struct Cli {
    #[command(subcommand)]
    command: Command,
}

#[derive(Subcommand)]
enum Command {
    /// Say hello to someone.
    Hello {
        /// Person to greet
        #[arg(add = ArgValueCompleter::new(complete_name))]
        name: String,
    },

    /// Generate shell completion scripts.
    Completions {
        /// Shell to generate completions for
        shell: Shell,
    },
}

fn main() {
    clap_complete::CompleteEnv::with_factory(Cli::command).complete();

    let cli = Cli::parse();

    if let Err(e) = run(cli.command) {
        ui::error(&e);
        std::process::exit(1);
    }
}

fn run(command: Command) -> Result<()> {
    match command {
        Command::Hello { name } => commands::cmd_hello(&name),
        Command::Completions { shell } => {
            let mut cmd = Cli::command();
            clap_complete::generate(shell, &mut cmd, "myapp", &mut std::io::stdout());
            Ok(())
        }
    }
}
