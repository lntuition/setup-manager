#!/bin/bash

rust_install=(
    "sudo apt-get -y install curl"
    "curl -sSf https://sh.rustup.rs | sh -s -- -y"
)

rust_test=(
    "source $HOME/.cargo/env"
    "rustc --version"
    "cargo --version"
)

execute() {
    # See below links to know about array arguments
    # https://askubuntu.com/questions/674333/
    # https://unix.stackexchange.com/questions/60584/

    ACTION=$1
    shift
    echo "[INFO] Start $ACTION"

    CMDS=("$@")
    for cmd in "${CMDS[@]}"; do
        echo "[DEBUG] Execute ${cmd}"
        eval $cmd
        if [ $? -ne 0 ]; then
            echo "[ERROR] Failed to $ACTION on : ${cmd}"
            return 1
        fi
    done

    echo "[INFO] Finish $ACTION"
    return 0
}

main() {
    # See below links to write argument parser
    # https://stackoverflow.com/questions/7529856
    # https://stackoverflow.com/questions/46351722/
    
    if [ $# -lt 1 ]; then
        echo "[ERROR] No option given, use 'install' or 'test' option"
        return 127
    elif [ $1 != "install" ] && [ $1 != "test" ]; then
        echo "[ERROR] Wrong option given, use 'install' or 'test' option"
        return 127
    fi
    OPTION=$1
    shift
    
    while getopts "k:" opt; do
        case "$opt" in
            k) KEYWORDS+=("$OPTARG")
                ;;
        esac
    done
    shift $((OPTIND -1))

    if [ ${#KEYWORDS[@]} -eq 0 ]; then
        echo "[WARNING] No keyword was given, use all keyword"
        KEYWORDS=("rust")
    fi

    for keyword in "${KEYWORDS[@]}"; do        
        CMDS="${keyword}_install[@]"
        execute "install ${keyword}" "${!CMDS}"
        if [ $? -ne 0 ]; then
            return 1
        fi
        
        if [ $OPTION == "test" ]; then
            CMDS="${keyword}_test[@]"
            execute "testing ${keyword}" "${!CMDS}"
            if [ $? -ne 0 ]; then
                return 1
            fi
        fi
    done
}

main "$@"
