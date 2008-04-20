#!/bin/sh

#Notes:
# $MODULE_DIR = the base directory where this script is found

. $BOILERPLATE_PREFIX/scripts/module_functions.sh

synopsis()
{
    echo " \"class\"|\"interface\" src_dir"
}

summary()
{
    echo "  This module generates template gobject class of interface files"
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

gen_new_class()
{
    echo "This will run your through some quick steps"
    echo "to generate an outline for your new class"
    echo

    read_var "Enter a filename stem (filename without a .c or .h extension)" CLASS_FILENAME_STEM "my-object"
    if test -f $SRC_DIR/${CLASS_FILENAME_STEM}.c -o -f $SRC_DIR/${CLASS_FILENAME_STEM}.h; then
        echo "Files already exist with that filename stem, please remove them first"
        echo "> $SRC_DIR/${CLASS_FILENAME_STEM}.c"
        echo "> $SRC_DIR/${CLASS_FILENAME_STEM}.h"
    fi

    
    read_var "Enter a project wide, lowercase symbol prefix:" CLASS_SYMBOL_PREFIX_LC "my"

    DEFAULT_SYMBOL_PREFIX_UC=`echo -n $CLASS_SYMBOL_PREFIX_LC | tr 'a-z' 'A-Z'`
    read_var "Enter a project wide, UPPERCASE symbol prefix:" CLASS_SYMBOL_PREFIX_UC "$DEFAULT_SYMBOL_PREFIX_UC"

    read_var "Enter a project wide, CamelCase symbol prefix:" CLASS_SYMBOL_PREFIX_CC "$CLASS_SYMBOL_PREFIX_UC"

    
    read_var "Enter a lowercase class name, excluding the project prefix:" CLASS_NAME_LC "object"
    
    DEFAULT_NAME_UC=`echo $CLASS_NAME_LC | tr 'a-z' 'A-Z'`
    read_var "Enter an UPPERCASE class name, excluding the project prefix:" CLASS_NAME_UC "$DEFAULT_NAME_UC"

    read_var "Enter an CamelCase class name, excluding the project prefix:" CLASS_NAME_CC "$CLASS_NAME_UC"


    echo
    echo
    echo "Summary of class config:"
    echo "Files = ${CLASS_FILENAME_STEM}.c ${CLASS_FILENAME_STEM}.h"
    echo "Project prefix = $CLASS_SYMBOL_PREFIX_LC/$CLASS_SYMBOL_PREFIX_UC/$CLASS_SYMBOL_PREFIX_CC"
    echo "Class name = $CLASS_NAME_LC/$CLASS_NAME_UC/$CLASS_NAME_CC"
    echo "Combined name = ${CLASS_SYMBOL_PREFIX_LC}_$CLASS_NAME_LC/${CLASS_SYMBOL_PREFIX_UC}_$CLASS_NAME_UC/${CLASS_SYMBOL_PREFIX_CC}$CLASS_NAME_CC"
    echo
    echo "Press Ctrl-C to cancel"
    read CTRL_C

    echo
    echo "Generating boilerplate class:"
    echo "> $SRC_DIR/${CLASS_FILENAME_STEM}.c"
    echo "> $SRC_DIR/${CLASS_FILENAME_STEM}.h"

    cp $MODULE_DIR/files/g-object-class.c $SRC_DIR/${CLASS_FILENAME_STEM}.c
    sed -i "s/my-object.h/${CLASS_FILENAME_STEM}.h/g" ${CLASS_FILENAME_STEM}.c
    sed -i "s/my_object/${CLASS_SYMBOL_PREFIX_LC}_${CLASS_NAME_LC}/g" ${CLASS_FILENAME_STEM}.c
    sed -i "s/MY_OBJECT/${CLASS_SYMBOL_PREFIX_UC}_${CLASS_NAME_UC}/g" ${CLASS_FILENAME_STEM}.c
    sed -i "s/MY_TYPE_OBJECT/${CLASS_SYMBOL_PREFIX_UC}_TYPE_${CLASS_NAME_UC}/g" ${CLASS_FILENAME_STEM}.c
    sed -i "s/MY_IS_OBJECT/${CLASS_SYMBOL_PREFIX_UC}_IS_${CLASS_NAME_UC}/g" ${CLASS_FILENAME_STEM}.c
    sed -i "s/MyObject/${CLASS_SYMBOL_PREFIX_CC}${CLASS_NAME_CC}/g" ${CLASS_FILENAME_STEM}.c

    cp $MODULE_DIR/files/g-object-class.h $SRC_DIR/${CLASS_FILENAME_STEM}.h
    sed -i "s/my_object/${CLASS_SYMBOL_PREFIX_LC}_${CLASS_NAME_LC}/g" ${CLASS_FILENAME_STEM}.h
    sed -i "s/MY_OBJECT/${CLASS_SYMBOL_PREFIX_UC}_${CLASS_NAME_UC}/g" ${CLASS_FILENAME_STEM}.h
    sed -i "s/MyObject/${CLASS_SYMBOL_PREFIX_CC}${CLASS_NAME_CC}/g" ${CLASS_FILENAME_STEM}.h
    sed -i "s/MY_TYPE_OBJECT/${CLASS_SYMBOL_PREFIX_UC}_TYPE_${CLASS_NAME_UC}/g" ${CLASS_FILENAME_STEM}.h
    sed -i "s/MY_IS_OBJECT/${CLASS_SYMBOL_PREFIX_UC}_IS_${CLASS_NAME_UC}/g" ${CLASS_FILENAME_STEM}.h

    echo "Done!"
}

gen_new_interface()
{
    echo "This will run your through some quick steps"
    echo "to generate an outline for your new interface"
    echo

    read_var "Enter a filename stem (filename without a .c or .h extension)" INTERFACE_FILENAME_STEM "my-object"
    if test -f $SRC_DIR/${INTERFACE_FILENAME_STEM}.c -o -f $SRC_DIR/${INTERFACE_FILENAME_STEM}.h; then
        echo "Files already exist with that filename stem, please remove them first"
        echo "> $SRC_DIR/${INTERFACE_FILENAME_STEM}.c"
        echo "> $SRC_DIR/${INTERFACE_FILENAME_STEM}.h"
    fi

    
    read_var "Enter a project wide, lowercase symbol prefix:" INTERFACE_SYMBOL_PREFIX_LC "my"

    DEFAULT_SYMBOL_PREFIX_UC=`echo -n $INTERFACE_SYMBOL_PREFIX_LC | tr 'a-z' 'A-Z'`
    read_var "Enter a project wide, UPPERCASE symbol prefix:" INTERFACE_SYMBOL_PREFIX_UC "$DEFAULT_SYMBOL_PREFIX_UC"

    read_var "Enter a project wide, CamelCase symbol prefix:" INTERFACE_SYMBOL_PREFIX_CC "$INTERFACE_SYMBOL_PREFIX_UC"

    
    read_var "Enter a lowercase interface name, excluding the project prefix:" INTERFACE_NAME_LC "object"
    
    DEFAULT_NAME_UC=`echo $INTERFACE_NAME_LC | tr 'a-z' 'A-Z'`
    read_var "Enter an UPPERCASE interface name, excluding the project prefix:" INTERFACE_NAME_UC "$DEFAULT_NAME_UC"

    read_var "Enter an CamelCase interface name, excluding the project prefix:" INTERFACE_NAME_CC "$INTERFACE_NAME_UC"


    echo
    echo
    echo "Summary of interface config:"
    echo "Files = ${INTERFACE_FILENAME_STEM}.c ${INTERFACE_FILENAME_STEM}.h"
    echo "Project prefix = $INTERFACE_SYMBOL_PREFIX_LC/$INTERFACE_SYMBOL_PREFIX_UC/$INTERFACE_SYMBOL_PREFIX_CC"
    echo "Interface name = $INTERFACE_NAME_LC/$INTERFACE_NAME_UC/$INTERFACE_NAME_CC"
    echo "Combined name = ${INTERFACE_SYMBOL_PREFIX_LC}_$INTERFACE_NAME_LC/${INTERFACE_SYMBOL_PREFIX_UC}_$INTERFACE_NAME_UC/${INTERFACE_SYMBOL_PREFIX_CC}$INTERFACE_NAME_CC"
    echo
    echo "Press Ctrl-C to cancel"
    read CTRL_C

    echo
    echo "Generating boilerplate interface:"
    echo "> $SRC_DIR/${INTERFACE_FILENAME_STEM}.c"
    echo "> $SRC_DIR/${INTERFACE_FILENAME_STEM}.h"

    cp $MODULE_DIR/files/g-interface.c $SRC_DIR/${INTERFACE_FILENAME_STEM}.c
    sed -i "s/my-doable.h/${INTERFACE_FILENAME_STEM}.h/g" ${INTERFACE_FILENAME_STEM}.c
    sed -i "s/my_doable/${INTERFACE_SYMBOL_PREFIX_LC}_${INTERFACE_NAME_LC}/g" ${INTERFACE_FILENAME_STEM}.c
    sed -i "s/MY_DOABLE/${INTERFACE_SYMBOL_PREFIX_UC}_${INTERFACE_NAME_UC}/g" ${INTERFACE_FILENAME_STEM}.c
    sed -i "s/MY_TYPE_DOABLE/${INTERFACE_SYMBOL_PREFIX_UC}_TYPE_${INTERFACE_NAME_UC}/g" ${INTERFACE_FILENAME_STEM}.c
    sed -i "s/MY_IS_DOABLE/${INTERFACE_SYMBOL_PREFIX_UC}_IS_${INTERFACE_NAME_UC}/g" ${INTERFACE_FILENAME_STEM}.c
    sed -i "s/MyDoable/${INTERFACE_SYMBOL_PREFIX_CC}${INTERFACE_NAME_CC}/g" ${INTERFACE_FILENAME_STEM}.c

    cp $MODULE_DIR/files/g-interface.h $SRC_DIR/${INTERFACE_FILENAME_STEM}.h
    sed -i "s/my_doable/${INTERFACE_SYMBOL_PREFIX_LC}_${INTERFACE_NAME_LC}/g" ${INTERFACE_FILENAME_STEM}.h
    sed -i "s/MY_DOABLE/${INTERFACE_SYMBOL_PREFIX_UC}_${INTERFACE_NAME_UC}/g" ${INTERFACE_FILENAME_STEM}.h
    sed -i "s/MY_TYPE_DOABLE/${INTERFACE_SYMBOL_PREFIX_UC}_TYPE_${INTERFACE_NAME_UC}/g" ${INTERFACE_FILENAME_STEM}.h
    sed -i "s/MY_IS_DOABLE/${INTERFACE_SYMBOL_PREFIX_UC}_IS_${INTERFACE_NAME_UC}/g" ${INTERFACE_FILENAME_STEM}.h
    sed -i "s/MyDoable/${INTERFACE_SYMBOL_PREFIX_CC}${INTERFACE_NAME_CC}/g" ${INTERFACE_FILENAME_STEM}.h

    echo "Done!"
}

usage()
{
    echo "You need to specify either \"class\" or \"interface\", and a src_dir"
    exit 1
}
run()
{
    if test $# -ne 2; then
        usage
    fi
    if ! test -d $2; then
        echo "Could not stat src_dir $2"
        usage
    fi
    if test $1 != "class" -a $1 != "interface"; then
        usage
    fi
    SRC_DIR=$2

    eval gen_new_$1
}


# This will handle the internal arguments: synopsis, summary, flags, run.
. $BOILERPLATE_PREFIX/scripts/module_arg_parse.sh


