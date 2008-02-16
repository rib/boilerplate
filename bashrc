#!/bin/sh

# This file should be sourced into your shell e.g. within
# your ~/.bashrc

export BOILERPLATE_PREFIX=/home/rob/src/boilerplate


boilerplate()
{
    $BOILERPLATE_PREFIX/boilerplate.sh "$@"
    find $BOILERPLATE_PREFIX/ -iname 'bp.profile' \
        -exec echo "echo \"sourcing: {}\"" \; \
        -exec cat {} \; > $BOILERPLATE_PREFIX/profile
    . $BOILERPLATE_PREFIX/profile
}

bp()
{
    boilerplate "$@"
}
