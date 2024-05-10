ZSH_COMMAND_GIT_FZF_TOOLDIR=${ZSH_COMMAND_GIT_FZF_TOOLDIR-${0:A:h}}
ZSH_COMMAND_GIT_FZF_BASE_DIR="${XDG_DATA_HOME-$HOME/.local/share}/zsh/d"
ZSH_COMMAND_GIT_FZF_FILE="${ZSH_COMMAND_GIT_FZF_BASE_DIR}/.__d"

function git-status() {
    out=$(${ZSH_COMMAND_GIT_FZF_TOOLDIR}/rust/git-fzf/target/release/git-fzf status ${ZSH_COMMAND_GIT_FZF_TOOLDIR})
    if [[ -n $out ]]; then
        BUFFER="$LBUFFER $out$RBUFFER"
        CURSOR="${#BUFFER}"
    fi
}
zle -N git-status

function git-log() {
    out=$(${ZSH_COMMAND_GIT_FZF_TOOLDIR}/rust/git-fzf/target/release/git-fzf log ${ZSH_COMMAND_GIT_FZF_TOOLDIR})
    if [[ -n $out ]]; then
        BUFFER="$out"
        CURSOR="${#BUFFER}"
    fi
}
zle -N git-log

function git-branch() {
    out=$(${ZSH_COMMAND_GIT_FZF_TOOLDIR}/rust/git-fzf/target/release/git-fzf branch ${ZSH_COMMAND_GIT_FZF_TOOLDIR})
    if [[ -n $out ]]; then
        if [[ -n "$WIDGET" ]]; then
            BUFFER="$LBUFFER $out $RBUFFER"
            CURSOR="${#BUFFER}"
        else
            git switch "$out"
        fi
    fi
}
zle -N git-branch

function gb() {
    git-branch
}

