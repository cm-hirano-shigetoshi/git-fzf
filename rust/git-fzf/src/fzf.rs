use std::env;
use std::io::{Error, Result};
use std::process::{Command, Stdio};

pub struct Fzf {}

impl Fzf {
    pub fn new() -> Self {
        // 同期処理なので保持する変数なし
        Fzf {}
    }

    pub fn start(&mut self, path: &str, tooldir: &str) -> Result<String> {
        let output = Command::new("sh")
            .arg("-c")
            .arg(
                format!("tac {} | bash {}/bash/global.sh | fzf --listen {} --ansi --bind 'alt-j:execute-silent:curl \"http://localhost:{}?bind=alt-j\"'",
                        path,
                        tooldir,
                        env::var("FZF_PORT").unwrap(),
                        env::var("SERVER_PORT").unwrap())
            )
            .stderr(Stdio::inherit())
            .output()?;

        if output.status.success() {
            return Ok(String::from_utf8(output.stdout).unwrap());
        } else {
            Err(Error::new(
                std::io::ErrorKind::Other,
                "Command execution failed",
            ))
        }
    }
}
