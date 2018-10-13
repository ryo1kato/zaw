# zaw source for processes

function zaw-src-process () {
    local ps_list title ps pid_list
    ps_list="$(ps -eo 'user,pid,%cpu,%mem,time,command' | awk '$6 !~ /^\[/ {print $0}')"  # filter out kernel processes
    title="${${(f)ps_list}[1]}"
    ps="$(echo $ps_list | sed '1d')"
    pid_list="$(echo $ps | awk '{print $2}')"
    : ${(A)candidates::=${(f)pid_list}}
    : ${(A)cand_descriptions::=${(f)ps}}
    actions=(zaw-callback-append-to-buffer zaw-src-process-kill)
    act_descriptions=("insert" "kill")
    src_opts=(-t "$title")
}

function zaw-src-process-kill () {
    local user="$(ps -ho user $1)"
    if [[ -z $user ]]; then
        echo "process with PID=$1 is not found"
        return 1
    fi
    if [[ $user = $USER ]]; then
        BUFFER="kill $1"
    else
        BUFFER=": sudo kill $1"
    fi
}

zaw-register-src -n process zaw-src-process
