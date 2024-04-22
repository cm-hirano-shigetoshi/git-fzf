use std::env;
use std::io::{Error, Result};
use std::process::{Command, Stdio};

pub struct Fzf {}

impl Fzf {
    pub fn new() -> Self {
        // 同期処理なので保持する変数なし
        Fzf {}
    }

    pub fn start(&mut self, toolpath: &str) -> Result<String> {
        let output = Command::new("sh")
            .arg("-c")
            .arg(
                format!("unbuffer git status -s | fzf --listen {} --multi --ansi --reverse --preview 'bash {}/bash/preview.sh {{2..}}' --preview-window 'up:70%' --bind 'enter:become:echo {{+2..}}' --bind 'alt-j:execute-silent:curl \"http://localhost:{}?bind=alt-j\"'",
                        env::var("FZF_PORT").unwrap(),
                        toolpath,
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
