ZSH_COMMAND_GIT_FZF_TOOLDIR=${ZSH_COMMAND_GIT_FZF_TOOLDIR-${0:A:h}}
ZSH_COMMAND_GIT_FZF_BASE_DIR="${XDG_DATA_HOME-$HOME/.local/share}/zsh/d"
ZSH_COMMAND_GIT_FZF_FILE="${ZSH_COMMAND_GIT_FZF_BASE_DIR}/.__d"

function git-status() {
    out=$(git status -s | fzf --multi --reverse | awk '{print $2}' | tr '\n' ' ')
    if [[ -n $out ]]; then
        BUFFER="$out"
        CURSOR="${#BUFFER}"
    fi
}
zle -N git-status

function git-log() {
    out=$(git log --oneline --graph | fzf --multi --reverse | awk '{print $2}' | tr '\n' ' ')
    if [[ -n $out ]]; then
        BUFFER="$out"
        CURSOR="${#BUFFER}"
    fi
}
zle -N git-log
