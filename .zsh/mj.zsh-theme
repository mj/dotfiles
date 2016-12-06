#
# Based on the awesome agnoster theme - https://gist.github.com/3712874
#

CURRENT_BG='NONE'
PRIMARY_FG=black

# Characters
SEGMENT_SEPARATOR="\ue0b0"
PLUSMINUS="\u00b1"
BRANCH="\ue0a0"
DETACHED="\u27a6"
LIGHTNING="\u26a1"

# Begin a segment
# Takes two arguments, background and foreground.
prompt_segment() {
    local bg="%K{$1}"
    local fg="%F{$2}"

    if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]
    then
        print -n "%{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%}"
    else
        print -n "%{$bg%}%{$fg%}"
    fi

    CURRENT_BG=$1
    [[ -n $3 ]] && print -n $3
}

# End the prompt, closing any open segments
prompt_end() {
    if [[ -n $CURRENT_BG ]]
    then
        print -n "%{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
    else
        print -n "%{%k%}"
    fi

    print -n "%{%f%}"
    CURRENT_BG=''
}

# Git: branch/detached head, dirty status
prompt_git() {
    local color ref

    is_dirty() {
        test -n "$(git status --porcelain --ignore-submodules)"
    }

    ref="$vcs_info_msg_0_"

    test -z "$ref" && return

    if is_dirty
    then
        color=yellow
        ref="${ref} $PLUSMINUS"
    else
        color=green
        ref="${ref} "
    fi

    if [[ "${ref/.../}" == "$ref" ]]
    then
        ref="$BRANCH $ref"
    else
        ref="$DETACHED ${ref/.../}"
    fi

    prompt_segment $color $PRIMARY_FG
    print -Pn " $ref"
}

## Main prompt
prompt_mj_main() {
    RETVAL=$?
    CURRENT_BG='NONE'

    # am I root?
    [[ $UID -eq 0 ]] && prompt_segment $PRIMARY_FG default "%{%F{red}%}$LIGHTNING "

    # user@host
    prompt_segment NONE default "%(!.%{%F{yellow}%}.)%n@%m "

    # CWD
    prompt_segment cyan $PRIMARY_FG ' %~ '

    prompt_git
    prompt_end
}

prompt_mj_precmd() {
    vcs_info
    PROMPT='%{%f%b%k%}$(prompt_mj_main) '
}

prompt_mj_setup() {
    autoload -Uz add-zsh-hook
    autoload -Uz vcs_info

    prompt_opts=(cr subst percent)

    add-zsh-hook precmd prompt_mj_precmd

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' check-for-changes false
    zstyle ':vcs_info:git*' formats '%b'
    zstyle ':vcs_info:git*' actionformats '%b (%a)'
}

prompt_mj_setup "$@"
