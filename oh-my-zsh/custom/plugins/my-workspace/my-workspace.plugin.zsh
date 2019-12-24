function echoerr() {
    echo "$@" 1>&2
}

function _configure_workspace_dir() {
    # Default workspace path
    if [[ -z "$MY_WORKSPACE_PATH" ]]; then
        export MY_WORKSPACE_PATH="$HOME/workspace"
        echo "Setting default workspace path: $MY_WORKSPACE_PATH"
    fi

    # Create workspace if it does not exist
    if ! [[ -e "$MY_WORKSPACE_PATH" ]]; then
        mkdir -p "$MY_WORKSPACE_PATH"
        chmod 750 "$MY_WORKSPACE_PATH"
        echo "Workspace created!"
    else
        if ! [[ -d "$MY_WORKSPACE_PATH" ]]; then
            echoerr "File named \"$MY_WORKSPACE_PATH\" already exists! Workspace creation failed."
            return 1
        else
            echo "Directory named \"$MY_WORKSPACE_PATH\" already exists! Skipping workspace creation."
        fi
    fi
    
    return 0
}

function _check_workspace_dir_exists() {
    [[ -n "$MY_WORKSPACE_PATH" ]] && [[ -d "$MY_WORKSPACE_PATH" ]]
}

function _check_temporary_dir_exists() {
    # Check if temporary workspace exists
    [[ -n "$MY_WORKSPACE_TMP" ]] && [[ -d "$MY_WORKSPACE_TMP" ]]
}

function _check_temporary_dir_open() {
    # Check if temporary workspace is open
    _check_temporary_dir_exists && [[ -n "$MY_WORKSPACE_TMP_LAST_PATH" ]] && [[ $(readlink -f $(pwd)) = *$(readlink -f "$MY_WORKSPACE_TMP")* ]]
}

function _create_temporary_dir() {
    # Default temporary directory
    if [[ -z "$MY_WORKSPACE_TMP" ]]; then
        if ! _check_workspace_dir_exists; then
            if ! _configure_workspace_dir; then
                return 1
            fi
        fi

        export MY_WORKSPACE_TMP="$MY_WORKSPACE_PATH/tmp"
        echo "Temporary path set: $MY_WORKSPACE_TMP"
    fi

    # Configure temporary directory
    echo "Checking previous temporary directory."
    _delete_temporary_dir 2> /dev/null || true

    mkdir -p "$MY_WORKSPACE_TMP"
    chmod 750 "$MY_WORKSPACE_TMP"
    echo "Temporary workspace created!"

    _open_temporary_dir

    return 0
}

function _delete_temporary_dir() {
    if _check_temporary_dir_exists; then
        if _check_temporary_dir_open; then
            _close_temporary_dir 2> /dev/null
        fi

        rm -rf "$MY_WORKSPACE_TMP"
        echo "Temporary directory removed!"
        return 0
    else
        echoerr "Temporary directory does not exist!"
        return 1
    fi
}

function _open_temporary_dir() {
    # Check temporary directory existence
    if [[ -z "$MY_WORKSPACE_TMP" ]] || ! [[ -d "$MY_WORKSPACE_TMP" ]]; then
        echoerr "Temporary directory does not exist!"
        return 1
    fi

    # Save last path before entering tmp dir
    export MY_WORKSPACE_TMP_LAST_PATH="$PWD"
    echo "Saving last path: $MY_WORKSPACE_TMP_LAST_PATH"

    echo "Entering temporary directory!"
    cd "$MY_WORKSPACE_TMP"

    return 0
}

function _close_temporary_dir() {
    if _check_temporary_dir_open; then
        echo "Going back to $MY_WORKSPACE_TMP_LAST_PATH"
        cd "$MY_WORKSPACE_TMP_LAST_PATH"
        export MY_WORKSPACE_TMP_LAST_PATH=""
    else
        echoerr "Temporary directory not open!"
        return 1
    fi
}

function tmp() {
    if [[ "$#" == 0 ]]; then
        if _check_temporary_dir_open; then
            OPTION="close"
        elif ! _check_temporary_dir_exists; then
            OPTION="new"
        else
            OPTION="open"
        fi

        echo "Setting option: $OPTION"
    else
        OPTION="$1"
    fi


    case "$OPTION" in
        n|new)
            _create_temporary_dir
            ;;
        d|delete)
            _delete_temporary_dir
            ;;
        o|open)
            _open_temporary_dir
            ;; 
        c|close)
            _close_temporary_dir
            ;;
        *)
            echo "Options: {new|delete|open|close}"
            ;;
    esac
}

function main() {
    if [[ "$1" == "-v" ]]; then
        _configure_workspace_dir
    else
        _configure_workspace_dir &> /dev/null
    fi
}

main

# Setting aliases
alias wsp="cd $MY_WORKSPACE_PATH"

alias tmpn="tmp new"
alias tmpd="tmp delete"

