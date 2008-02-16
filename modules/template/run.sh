#!/bin/sh

#Notes:
# $MODULE_DIR = the base directory where this script is found

. $BOILERPLATE_PREFIX/scripts/module_functions.sh

synopsis()
{
    #FIXME
    echo " [--option] remainder"
}

summary()
{
    #FIXME
    echo "  This module does stuff"
}

help()
{
    #FIXME
    cat <<-EOF
        Do this to make me do stuff.

        Note: It won't overwite any existing files
EOF
}

flags()
{
    return 0
}

run()
{
    while test $# -gt 0
    do
        case $1 in
#            --option)
#                handle_option
#                ;;
            *)

            # Validate remaining arguments
            REMAINDER0=$1
            break
        esac
        shift
    done

    if test -z "$REMAINDER"; then
        return
    fi
}


# This will handle the internal arguments: synopsis, summary, flags, run.
. $BOILERPLATE_PREFIX/scripts/module_arg_parse.sh


