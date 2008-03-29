#!/bin/sh

. $BOILERPLATE_PREFIX/scripts/module_functions.sh

synopsis()
{
    echo " <project_dir>"
}

summary()
{
    echo "  Initialises a new autotool based Gnome project"
}

help()
{
    cat <<-EOF
        Using a number of template files, this module can initialise
        a new autotool based Gnome project.
        
        Note: It won't overwite any existing files
EOF
}

flags()
{
    return 0
}

run()
{
    if test $# -ne 1; then
        echo "You need to specify a project_dir"
        exit 1
    fi
    if ! test -d $1; then
        echo "Could not stat project_dir $1"
        exit 1
    fi
    PROJECT_DIR=$1
    

    # First read in all the configuration variables we need...
    read_var "What type of project is this? (application|library)" PKG_TYPE "application"
    if test "$PKG_TYPE" != "library" -a "$PKG_TYPE" != "application"; then
        echo "The project type must be one of: \"application\" or \"library\""
        exit 1
    fi
    read_var "Choose a name for your package (lowercase)" PKG_NAME ""
    PKG_NAME_UC=$(echo $PKG_NAME|tr a-z A-Z)
    read_var "Choose an initial version number" INITIAL_VERSION "0.1.0"
    read_var "Choose the name of your program (one word)" PROGRAM_NAME $PKG_NAME
    PROGRAM_NAME_UC=$(echo $PROGRAM_NAME|tr a-z A-Z)
    read_var "Write the _full_ name of your program (e.g GSwat Debugger)" FULL_PROGRAM_NAME ""
    read_var "Write the generic name of your program (e.g. Program Debugger)" GENERIC_PROGRAM_NAME ""

    
    echo "Summary of config:"
    echo "Package type = $PKG_TYPE"
    echo "Package name = $PKG_NAME/$PKG_NAME_UC"
    echo "Initial version = $INITIAL_VERSION"
    echo "Program name = $PROGRAM_NAME/$PROGRAM_NAME_UC"
    echo "First src file = $PROJECT_DIR/src/${PROGRAM_NAME}.c"
    echo "Press Ctrl-C to cancel"
    read CTRL_C


    mkdir $PROJECT_DIR/m4 2>/dev/null
    mkdir $PROJECT_DIR/src 2>/dev/null
    mkdir $PROJECT_DIR/src/data 2>/dev/null
    mkdir $PROJECT_DIR/src/data/glade 2>/dev/null
    mkdir $PROJECT_DIR/src/data/ui 2>/dev/null

    
    touch $PROJECT_DIR/NEWS
    touch $PROJECT_DIR/README
    touch $PROJECT_DIR/AUTHORS
    touch $PROJECT_DIR/ChangeLog   

    if ! test -f $PROJECT_DIR/autogen.sh; then
        cat $MODULE_DIR/files/autogen.sh.in \
            | sed "s/@PKG_NAME@/$PKG_NAME/g" \
            | sed "s/@PROGRAM_NAME@/$PROGRAM_NAME/g" \
            >$PROJECT_DIR/autogen.sh
        chmod +x $PROJECT_DIR/autogen.sh
        echo "Wrote $PROJECT_DIR/autogen.sh"
    fi
    if ! test -f $PROJECT_DIR/configure.in; then
        cat $MODULE_DIR/files/$PKG_TYPE.configure.in.in \
            | sed "s/@PKG_NAME@/$PKG_NAME/g" \
            | sed "s/@PKG_NAME_UC@/$PKG_NAME_UC/g" \
            | sed "s/@INITIAL_VERSION@/$INITIAL_VERSION/g" \
            | sed "s/@PROGRAM_NAME@/$PROGRAM_NAME/g" \
            >$PROJECT_DIR/configure.in
        echo "Wrote $PROJECT_DIR/configure.in"
    fi
    if ! test -f $PROJECT_DIR/Makefile.am; then
        cp $MODULE_DIR/files/$PKG_TYPE.Makefile.am $PROJECT_DIR
        echo "Wrote $PROJECT_DIR/Makefile.am"
    fi
    if ! test -f $PROJECT_DIR/src/Makefile.am; then
        cat $MODULE_DIR/files/src/Makefile.am.in \
            | sed "s/@PROGRAM_NAME@/$PROGRAM_NAME/g" \
            | sed "s/@PROGRAM_NAME_UC@/$PROGRAM_NAME_UC/g" \
            >$PROJECT_DIR/src/Makefile.am
        echo "Wrote $PROJECT_DIR/src/Makefile.am"
    fi
    if ! test -f $PROJECT_DIR/src/data/${PROGRAM_NAME}.desktop.in; then
        cat $MODULE_DIR/files/src/data/program.desktop.in.in \
            | sed "s/@PROGRAM_NAME@/$PROGRAM_NAME/g" \
            | sed "s/@PROGRAM_NAME_UC@/$PROGRAM_NAME_UC/g" \
            | sed "s/@FULL_PROGRAM_NAME@/$FULL_PROGRAM_NAME/g" \
            | sed "s/@GENERIC_PROGRAM_NAME@/$GENERIC_PROGRAM_NAME/g" \
            >$PROJECT_DIR/src/data/${PROGRAM_NAME}.desktop.in
        echo "Wrote $PROJECT_DIR/src/data/${PROGRAM_NAME}.desktop.in"
    fi
    
    touch $PROJECT_DIR/src/${PROGRAM_NAME}.c
    touch $PROJECT_DIR/src/data/glade/${PROGRAM_NAME}.glade
}



. $BOILERPLATE_PREFIX/scripts/module_arg_parse.sh


