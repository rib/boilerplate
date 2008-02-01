#!/bin/sh

synopsis()
{
    echo " <project_dir>"
}

summary()
{
    echo "  Initialises a new gnome autotool based project"
}

flags()
{
    return 0
}

run()
{
    echo "FOOO"
}


if test $# -lt 1; then
    echo "Dont run directly"
    exit 1
fi

. $BOILERPLATE_PREFIX/scripts/module_arg_parse.sh


