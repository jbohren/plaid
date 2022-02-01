
function plaid() {

    ####################################################################
    # Helper functions #################################################
    ####################################################################

    INSTALL_SETUP_FILE="install/setup.bash"

    function _is_ws_active() {
        # Check if a workspace is active
        if [[ -z ${PLAID_WS_PATH+x} ]] ; then
            return 1 # false
        else
            return 0 # true
        fi
    }

    function _list_pkgs() {
        # list all packages in workspace

        SPACE=src

        while IFS= read -r package_file ; do
            # get the package name
            printf "$(xmllint --xpath 'string(//package/name)' $package_file) "
        done <<< $(find "${PLAID_WS_PATH}/${SPACE}" -name package.xml)
    }

    function _find_package() {
        local search_path=${PWD%/}

        while [[ -n $search_path ]] ; do

            [[ -e "$search_path/package.xml" ]] && {

                echo $(xmllint --xpath "string(//package/name)" "$search_path/package.xml")
                return 0
            }

            search_path=${search_path%/*}
        done

        return 1
    }

    function _get_ws_root() {

        # Use the environment variable if it exists
        if [[ ! -z ${PLAID_WS_PATH+x} ]] ; then
            printf "$PLAID_WS_PATH"
            return 0
        fi

        # Search upward for the install space setup file
        local search_path=${PWD%/}

        while [[ -n $search_path ]] ; do
            [[ -e $search_path/$INSTALL_SETUP_FILE ]] && {
                printf "$search_path"
                return 0
            }
            search_path=${search_path%/*}
        done

        return 1
    }

    ####################################################################
    # Subcommand definitions ###########################################
    ####################################################################

    function sub_help() {
        echo "plaid: accelerate ros2 development"
        echo ""
        echo "subcommands:"
        echo "  build    Build packages with colcon."
        echo "  cd       Change to a package directory."
        echo "  source   Source a workspace."
        echo "  ws       Run a command from the workspace root."
        return 0
    }

    function sub_ws() {
        if [ $1 = "-h" ] || [ $1 = "--help" ] ; then
            echo "usage: plaid ws CMD [ARG [ARG..]]"
            echo "  Run a command from the workspace root."
            echo ""
            echo "positional arguments:"
            echo "  CMD          The command."
            echo "  ARG [ARG..]  Arguments for the command."
            return 0
        fi

        if ! $(_is_ws_active) ; then
            echo "Error: no active workspace. Please run 'plaid source'." >&2
            return 1
        fi

        (cd $PLAID_WS_PATH && $@)
    }

    function sub_build() {
        POSITIONAL_ARGS=()

        OPT_THIS=0

        while [[ $# -gt 0 ]]; do
            case $1 in
                -h|--help)
                    echo "usage: plaid build [-t|--this] [PKG [PKG..]]"
                    echo "  Build packages in a colcon workspace."
                    echo ""
                    echo "  Flags in COLCON_BUILD_FLAGS variable in plaid.conf will be used."
                    echo ""
                    echo "postional:"
                    echo "  PKG [PKG..]  Name of packages to build."
                    echo "options:"
                    echo "  -t, --this  Build the package enclosing the current working directory."
                    return 0
                    ;;
                -t|--this)
                    OPT_THIS=1
                    shift
                    ;;
                -*|--*)
                    echo "Unknown option $1"
                    return 1
                    ;;
                *)
                    POSITIONAL_ARGS+=("$1") # save positional arg
                    shift # past argument
                    ;;
            esac
        done

        if ! $(_is_ws_active) ; then
            echo "Error: no active workspace. Please run 'plaid source'." >&2
            return 1
        fi

        if [[ $OPT_THIS == 1 ]] ; then
            package_name=$(_find_package)
            POSITIONAL_ARGS+=("$package_name")
        fi

        if [[ -e ${ws_root}/plaid.conf ]] ; then
            . ${ws_root}/plaid.conf
        else
            COLCON_BUILD_FLAGS=''
        fi

        if [[ ${#POSITIONAL_ARGS[@]} -eq 0 ]] ; then
            (cd $PLAID_WS_PATH && colcon build $COLCON_BUILD_FLAGS)
        else
            (cd $PLAID_WS_PATH && colcon build $COLCON_BUILD_FLAGS --packages-select ${POSITIONAL_ARGS[@]})
        fi
    }

    function sub_source() {

        POSITIONAL_ARGS=()

        while [[ $# -gt 0 ]]; do
            case $1 in
                -h|--help)
                    echo "usage: plaid source [-s|--subshell] [-f|--force] [PATH]"
                    echo "  Source a colcon workspace."
                    echo ""
                    echo "positional arguments:"
                    echo "  PATH  The path to a workspace. By default sources the enclosing workspace."
                    echo ""
                    echo "options:"
                    echo "  -s, --subshell Open a subshell for the new environment."
                    echo "  -f, --force    Don't fail if a workspace is already sourced."
                    return 0
                    ;;
                -s|--subshell)
                    OPT_SUBSHELL=1
                    shift
                    ;;
                -f|--force)
                    OPT_FORCE=1
                    shift
                    ;;
                -*|--*)
                    echo "Unknown option $1"
                    return 1
                    ;;
                *)
                    POSITIONAL_ARGS+=("$1") # save positional arg
                    shift # past argument
                    ;;
            esac
        done

        # Produce warning or error if the workspace is already active
        if $(_is_ws_active) ; then
            if [[ $OPT_FORCE == 1 ]] ; then
                echo "Warning: Workspace is already active: $PLAID_WS_PATH" >&2
            else
                echo "Error: Workspace is already active: $PLAID_WS_PATH" >&2
                echo "Please exit or create a new shell." >&2
                return 1
            fi
        fi

        # Get the workspace root
        if [[ ${#POSITIONAL_ARGS[@]} -eq 0 ]] ; then
            ws_root=$(_get_ws_root)
        else
            ws_root=$(realpath ${POSITIONAL_ARGS[0]})
        fi

        setup_file="${ws_root}/${INSTALL_SETUP_FILE}"

        if [[ ! -e $setup_file ]] ; then
            echo "Error: No setup file found at: $setup_file" >&2
            return 1
        fi

        if [[ -e ${ws_root}/plaid.conf ]] ; then
            . ${ws_root}/plaid.conf
        else
            PROMPT_PREFIX='[#] '
        fi

        if [[ $OPT_SUBSHELL == 1 ]] ; then
            echo "Sourcing workspace in subshell: $ws_root"
            echo "To exit: Ctrl-D"
            export PLAID_PROMPT_PREFIX="$PROMPT_PREFIX"
            PLAID_WS_PATH="${ws_root}" bash -c "source $setup_file && /bin/bash -l"
        else
            echo "Sourcing workspace: $ws_root"

            # Load the workspace setup file from the install path
            source $setup_file

            # Set the workspace root so that it's stable regardless of working dir
            export PLAID_WS_PATH="${ws_root}"

            # Prefix PS1 to designate that the workspace has been sourced
            if [[ $PS1 != "$PROMPT_PREFIX"* ]] ; then
                export PS1="$PROMPT_PREFIX$PS1"
            fi
        fi
    }

    function sub_cd() {

        POSITIONAL_ARGS=()

        SPACE=src

        while [[ $# -gt 0 ]]; do
            case $1 in
                -h|--help)
                    echo "usage: plaid cd [-s|--src|-i|--install] [PKG]"
                    echo "  Change to a workspace directory."
                    echo ""
                    echo "options:"
                    echo "  -s, --src      Search in source space (default)."
                    echo "  -i, --install  Search in install space."
                    echo ""
                    echo "positional arguments:"
                    echo "  PKG    The name of the package, or blank to change to the workspace root."
                    return 0
                    ;;
                -s|--src)
                    SPACE=src
                    shift
                    ;;
                -i|--install)
                    SPACE=install
                    shift
                    ;;
                -*|--*)
                    echo "Unknown option $1"
                    return 1
                    ;;
                *)
                    POSITIONAL_ARGS+=("$1") # save positional arg
                    shift # past argument
                    ;;
            esac
        done

        # If no package specified, navigate to the workspace root
        if [[ ${#POSITIONAL_ARGS[@]} -eq 0 ]] ; then
            cd $PLAID_WS_PATH
            return 0
        fi

        PKG=${POSITIONAL_ARGS[0]}

        # Iterate over all package.xml files in the given space
        while IFS= read -r package_file ; do
            # get the package name
            package_name=$(xmllint --xpath "string(//package/name)" $package_file)

            # check if the package is the one saught
            if [ "$package_name" == "$PKG" ] ; then
                # change to the directory and stop iterating
                cd $(dirname $package_file)
                return
            fi
        done <<< $(find "${PLAID_WS_PATH}/${SPACE}" -name package.xml)
    }

    ####################################################################
    # Subcommand router ################################################
    ####################################################################

    subcommand=$1

    case $subcommand in
        "" | "-h" | "--help")
            sub_help
            ;;
        build|cd|source|ws)
            shift
            sub_${subcommand} $@
            ;;
        *)
            echo "error: '$subcommand' is not a valid command." >&2
            echo "Run '$0 --help' for a list of valid commands." >&2
            return 1
            ;;
    esac

    return $?
}

_plaid ()
{
    local i=1 cmd

    while [[ "$i" -lt "$COMP_CWORD" ]] ; do
        local s="${COMP_WORDS[i]}"
        case "$s" in
            -*) ;;
            *)
                cmd="$s"
                break
                ;;
        esac
        (( i++ ))
    done

    if [[ "$i" -eq "$COMP_CWORD" ]] ; then
        local cur="${COMP_WORDS[COMP_CWORD]}"
        COMPREPLY=($(compgen -W "build cd source ws" -- "$cur"))
        return
    fi

    case "$cmd" in
        cd|build)
            local cur="${COMP_WORDS[COMP_CWORD]}"
            COMPREPLY=($(compgen -W "$(_list_pkgs)" -- "$cur"))
            return
            ;;
        *)
            ;;
    esac
}

# bash argument tab completion
complete -F _plaid plaid

