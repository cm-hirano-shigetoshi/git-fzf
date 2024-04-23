use std::env;
use std::io::{Error, Result};
use std::process::{Command, Stdio};

pub struct Fzf {}

impl Fzf {
    pub fn new() -> Self {
        // 同期処理なので保持する変数なし
        Fzf {}
    }

    pub fn start(&mut self, func: &str, toolpath: &str) -> Result<String> {
        let mut cmd = ":".to_string();
        if func == "status" {
            cmd = format!("unbuffer git status -s | fzf --listen {} --multi --ansi --reverse --preview 'bash {}/bash/preview.sh status {{2..}}' --preview-window 'up:70%' --bind 'enter:become:echo {{+2..}}' --bind 'alt-j:execute-silent:curl \"http://localhost:{}?bind=alt-j\"'",
                        env::var("FZF_PORT").unwrap(),
                        toolpath,
                        env::var("SERVER_PORT").unwrap());
        } else if func == "log" {
            //out=$(git log --oneline --graph | fzf --multi --reverse | awk '{print $2}' | tr '\n' ' ')
            cmd = format!("unbuffer git log --oneline --graph | tr -d '\r' | fzf --listen {} --multi --ansi --reverse --preview 'bash {}/bash/preview.sh log {{+2}}' --preview-window 'up:70%' --bind 'enter:become:echo {{+2}}' --bind 'alt-j:execute-silent:curl \"http://localhost:{}?bind=alt-j\"'",
                        env::var("FZF_PORT").unwrap(),
                        toolpath,
                        env::var("SERVER_PORT").unwrap());
        }
        let output = Command::new("sh")
            .arg("-c")
            .arg(cmd)
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
