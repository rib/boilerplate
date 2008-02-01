#!/bin/sh

# This file should be sourced into your shell e.g. within
# your ~/.bashrc

export BOILERPLATE_PREFIX=/home/rob/src/boilerplate

boilerplate()
{
    $BOILERPLATE_PREFIX/boilerplate.sh "$@"
    . $BOILERPLATE_PREFIX/profile
}

