
read_var()
{
    if test $# -ne 3; then
        echo "read_var prompt var_name fallback_default_val"
        return 0
    fi

    PROMPT=$1
    VAR_NAME=$2
    FALLBACK_DEFAULT_VAL=$3

    touch $MODULE_DIR/read_var_defaults
    
    LINE=$(cat $MODULE_DIR/read_var_defaults|grep "^${VAR_NAME}=")
    if test -n "$LINE"; then
        eval $LINE
        eval DEFAULT=\${$VAR_NAME}
    else
        DEFAULT=$FALLBACK_DEFAULT_VAL
    fi

    echo -n "$PROMPT [$DEFAULT]:"
    read $VAR_NAME
    
    eval VAL=\${$VAR_NAME}
    if test -z "${VAL}"; then
        eval $VAR_NAME=\${DEFAULT}
    fi

    # Save the value as the next default value
    cat $MODULE_DIR/read_var_defaults|grep -v "^${VAR_NAME}=">$MODULE_DIR/read_var_defaults.tmp
    echo "${VAR_NAME}='$(eval echo \${$VAR_NAME})'">>$MODULE_DIR/read_var_defaults.tmp
    mv $MODULE_DIR/read_var_defaults.tmp $MODULE_DIR/read_var_defaults
}

