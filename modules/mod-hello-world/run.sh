#!/bin/sh

. $BOILERPLATE_PREFIX/scripts/module_functions.sh

synopsis()
{
    echo " [--list] type"
}

summary()
{
    echo "  Creates simple starting point source files"
}

help()
{
    cat <<-EOF
        Use the --list option to view the possible types of
        hello world programs that can be dumped.
        
        Note: It won't overwite any existing files
EOF
}

flags()
{
    return 0
}


list_types()
{
    echo "Available hello world types:"
    for i in `find $MODULE_DIR/types -type d`
    do
        if ! test -f $i/hello.sh; then
            continue
        fi
        echo "> `basename $i`"
    done
}

run()
{
    while test $# -gt 0
    do
        case $1 in
            --list)
                list_types
                return
                ;;
            *)
            TYPE=$1
            break
        esac
        shift
    done
    
    if test -z "$TYPE"; then
        echo "You need to specify a type"
        return
    fi

    HELLO_WORLD_DIR=$MODULE_DIR/types/$TYPE
    . $MODULE_DIR/types/$TYPE/hello.sh
    eval ${TYPE}_hello_world
}


. $BOILERPLATE_PREFIX/scripts/module_arg_parse.sh


