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
            cmd = format!("unbuffer git status -s | fzf --listen {} --multi --ansi --reverse --preview '{}/shell/preview_status.sh {{}}' --preview-window 'up:70%' --bind 'enter:become:echo {{+2..}}' --bind 'alt-j:execute-silent:curl \"http://localhost:{}?bind=alt-j\"'",
                        env::var("FZF_PORT").unwrap(),
                        toolpath,
                        env::var("SERVER_PORT").unwrap());
        } else if func == "log" {
            cmd = format!("git log --color=always --oneline --graph | fzf --listen {} --multi --ansi --reverse --preview '{}/shell/preview_log.sh {{+}}' --preview-window 'up:70%' --bind 'alt-j:execute-silent:curl \"http://localhost:{}?bind=alt-j\"' | {}/shell/get_hash.sh | tr '\n' ' '",
                        env::var("FZF_PORT").unwrap(),
                        toolpath,
                        env::var("SERVER_PORT").unwrap(),
                        toolpath);
        } else if func == "branch" {
            cmd = format!("git branch -av --color=always | sed 's/^*\\? \\+//' | fzf --listen {} --multi --ansi --reverse --bind 'enter:become:echo {{+1}}'",
                        env::var("FZF_PORT").unwrap())
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
