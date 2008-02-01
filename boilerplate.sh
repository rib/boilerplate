#!/bin/sh

PREFIX=/home/rob/src/boilerplate

usage()
{
    echo "boilerplate <command>"
    echo ""
    echo "Where command is one of:"
    for i in `find $PREFIX/modules -iname 'mod-*' -type d`
    do
        if test -f $i/run.sh; then
            setterm -bold
            echo -n $(basename $i)
            setterm -default
            pushd $i &>/dev/null
            ./run.sh synopsis
            ./run.sh summary
            popd &>/dev/null
        fi
    done
}

run_mod()
{
    if test -f $PREFIX/modules/$1/run.sh; then
        MODULE=$1
        shift
        pushd $PREFIX/modules/$MODULE &>/dev/null
        $PREFIX/modules/$MODULE/run.sh run "$@"
        popd &>/dev/null
    else
        echo "No such module $1 found"
        exit 1
    fi
}

if test $# -eq 0; then
    usage
    exit 0
fi

while test $# -gt 0
do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        *)
            run_mod "$@"
            exit 0
            ;;
    esac
    shift;
done

