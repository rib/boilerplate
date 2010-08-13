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
    PKG_NAME_LC_NORMALIZED=$(echo $PKG_NAME|tr '-' '_')
    PKG_NAME_UC_NORMALIZED=$(echo $PKG_NAME_UC|tr '-' '_')

    read_var "Choose an initial version number" INITIAL_VERSION "0.1.0"
    MAJOR_VERSION=$(echo $INITIAL_VERSION|cut -d'.' -f1)
    MINOR_VERSION=$(echo $INITIAL_VERSION|cut -d'.' -f2)
    MICRO_VERSION=$(echo $INITIAL_VERSION|cut -d'.' -f3)

    read_var "Choose the name of your application/library (one word CamelCase)" PROGRAM_NAME $PKG_NAME
    PROGRAM_NAME_UC=$(echo $PROGRAM_NAME|tr a-z A-Z)
    PROGRAM_NAME_LC=$(echo $PROGRAM_NAME|tr A-Z a-z)
    read_var "Write the _full_ name of your application/library (e.g GSwat Debugger)" FULL_PROGRAM_NAME ""
    read_var "Write the generic name of your application/library (e.g. Program Debugger)" GENERIC_PROGRAM_NAME ""

    
    echo "Summary of config:"
    echo "Package type = $PKG_TYPE"
    echo "Package name = $PKG_NAME/$PKG_NAME_UC"
    echo "Initial version = $INITIAL_VERSION"
    echo "Application/Library name = $PROGRAM_NAME/$PROGRAM_NAME_UC/$PROGRAM_NAME_LC"
    echo "First src file = $PROJECT_DIR/src/${PROGRAM_NAME_LC}.c"
    echo "Press Ctrl-C to cancel"
    read CTRL_C


    mkdir $PROJECT_DIR/m4 2>/dev/null
    mkdir $PROJECT_DIR/src 2>/dev/null
    if test "$PKG_TYPE" = "application"; then
        mkdir $PROJECT_DIR/src/data 2>/dev/null
        mkdir $PROJECT_DIR/src/data/glade 2>/dev/null
        mkdir $PROJECT_DIR/src/data/ui 2>/dev/null
    fi

    
    touch $PROJECT_DIR/NEWS
    touch $PROJECT_DIR/README
    touch $PROJECT_DIR/AUTHORS
    touch $PROJECT_DIR/ChangeLog   

    if ! test -f $PROJECT_DIR/autogen.sh; then
        cat $MODULE_DIR/files/autogen.sh.in \
            | sed "s/%PKG_NAME%/$PKG_NAME/g" \
            | sed "s/%PKG_NAME_UC%/$PKG_NAME_UC/g" \
            | sed "s/%PKG_NAME_LC_NORMALIZED%/$PKG_NAME_LC_NORMALIZED/g" \
            | sed "s/%PKG_NAME_UC_NORMALIZED%/$PKG_NAME_UC_NORMALIZED/g" \
            | sed "s/%PROGRAM_NAME_LC%/$PROGRAM_NAME_LC/g" \
            | sed "s/%PROGRAM_NAME_UC%/$PROGRAM_NAME_UC/g" \
            | sed "s/%INITIAL_VERSION%/$INITIAL_VERSION/g" \
            | sed "s/%MAJOR_VERSION%/$MAJOR_VERSION/g" \
            | sed "s/%MINOR_VERSION%/$MINOR_VERSION/g" \
            | sed "s/%MICRO_VERSION%/$MICRO_VERSION/g" \
            | sed "s/%PROGRAM_NAME%/$PROGRAM_NAME/g" \
            | sed "s/%FULL_PROGRAM_NAME%/$FULL_PROGRAM_NAME/g" \
            >$PROJECT_DIR/autogen.sh
        chmod +x $PROJECT_DIR/autogen.sh
        echo "Wrote $PROJECT_DIR/autogen.sh"
    fi
    if ! test -f $PROJECT_DIR/configure.in; then
        cat $MODULE_DIR/files/$PKG_TYPE.configure.in.in \
            | sed "s/%PKG_NAME%/$PKG_NAME/g" \
            | sed "s/%PKG_NAME_UC%/$PKG_NAME_UC/g" \
            | sed "s/%PKG_NAME_LC_NORMALIZED%/$PKG_NAME_LC_NORMALIZED/g" \
            | sed "s/%PKG_NAME_UC_NORMALIZED%/$PKG_NAME_UC_NORMALIZED/g" \
            | sed "s/%PROGRAM_NAME_LC%/$PROGRAM_NAME_LC/g" \
            | sed "s/%PROGRAM_NAME_UC%/$PROGRAM_NAME_UC/g" \
            | sed "s/%INITIAL_VERSION%/$INITIAL_VERSION/g" \
            | sed "s/%MAJOR_VERSION%/$MAJOR_VERSION/g" \
            | sed "s/%MINOR_VERSION%/$MINOR_VERSION/g" \
            | sed "s/%MICRO_VERSION%/$MICRO_VERSION/g" \
            | sed "s/%PROGRAM_NAME%/$PROGRAM_NAME/g" \
            | sed "s/%FULL_PROGRAM_NAME%/$FULL_PROGRAM_NAME/g" \
            >$PROJECT_DIR/configure.in
        echo "Wrote $PROJECT_DIR/configure.in"
    fi
    if ! test -f $PROJECT_DIR/Makefile.am; then
        cp $MODULE_DIR/files/$PKG_TYPE.Makefile.am $PROJECT_DIR/Makefile.am
        echo "Wrote $PROJECT_DIR/Makefile.am"
    fi
    if ! test -f $PROJECT_DIR/src/Makefile.am; then
        cat $MODULE_DIR/files/src/$PKG_TYPE.Makefile.am.in \
            | sed "s/%PKG_NAME%/$PKG_NAME/g" \
            | sed "s/%PKG_NAME_UC%/$PKG_NAME_UC/g" \
            | sed "s/%PKG_NAME_LC_NORMALIZED%/$PKG_NAME_LC_NORMALIZED/g" \
            | sed "s/%PKG_NAME_UC_NORMALIZED%/$PKG_NAME_UC_NORMALIZED/g" \
            | sed "s/%PROGRAM_NAME_LC%/$PROGRAM_NAME_LC/g" \
            | sed "s/%PROGRAM_NAME_UC%/$PROGRAM_NAME_UC/g" \
            | sed "s/%INITIAL_VERSION%/$INITIAL_VERSION/g" \
            | sed "s/%MAJOR_VERSION%/$MAJOR_VERSION/g" \
            | sed "s/%MINOR_VERSION%/$MINOR_VERSION/g" \
            | sed "s/%MICRO_VERSION%/$MICRO_VERSION/g" \
            | sed "s/%PROGRAM_NAME%/$PROGRAM_NAME/g" \
            | sed "s/%FULL_PROGRAM_NAME%/$FULL_PROGRAM_NAME/g" \
            >$PROJECT_DIR/src/Makefile.am
        echo "Wrote $PROJECT_DIR/src/Makefile.am"
    fi
    if test "$PKG_TYPE" = "application"; then
        if ! test -f $PROJECT_DIR/src/data/${PROGRAM_NAME}.desktop.in; then
            cat $MODULE_DIR/files/src/data/program.desktop.in.in \
		| sed "s/%PKG_NAME%/$PKG_NAME/g" \
		| sed "s/%PKG_NAME_UC%/$PKG_NAME_UC/g" \
		| sed "s/%PKG_NAME_LC_NORMALIZED%/$PKG_NAME_LC_NORMALIZED/g" \
		| sed "s/%PKG_NAME_UC_NORMALIZED%/$PKG_NAME_UC_NORMALIZED/g" \
		| sed "s/%PROGRAM_NAME_LC%/$PROGRAM_NAME_LC/g" \
		| sed "s/%PROGRAM_NAME_UC%/$PROGRAM_NAME_UC/g" \
		| sed "s/%INITIAL_VERSION%/$INITIAL_VERSION/g" \
		| sed "s/%MAJOR_VERSION%/$MAJOR_VERSION/g" \
		| sed "s/%MINOR_VERSION%/$MINOR_VERSION/g" \
		| sed "s/%MICRO_VERSION%/$MICRO_VERSION/g" \
		| sed "s/%PROGRAM_NAME%/$PROGRAM_NAME/g" \
                | sed "s/%FULL_PROGRAM_NAME%/$FULL_PROGRAM_NAME/g" \
                | sed "s/%GENERIC_PROGRAM_NAME%/$GENERIC_PROGRAM_NAME/g" \
                >$PROJECT_DIR/src/data/${PROGRAM_NAME}.desktop.in
            echo "Wrote $PROJECT_DIR/src/data/${PROGRAM_NAME}.desktop.in"
        fi
    else
        if ! test -f $PROJECT_DIR/${PROGRAM_NAME_LC}-${MAJOR_VERSION}.${MINOR_VERSION}.pc.in; then
            cat $MODULE_DIR/files/library.pc.in.in \
		| sed "s/%PKG_NAME%/$PKG_NAME/g" \
		| sed "s/%PKG_NAME_UC%/$PKG_NAME_UC/g" \
		| sed "s/%PKG_NAME_LC_NORMALIZED%/$PKG_NAME_LC_NORMALIZED/g" \
		| sed "s/%PKG_NAME_UC_NORMALIZED%/$PKG_NAME_UC_NORMALIZED/g" \
		| sed "s/%PROGRAM_NAME_LC%/$PROGRAM_NAME_LC/g" \
		| sed "s/%PROGRAM_NAME_UC%/$PROGRAM_NAME_UC/g" \
		| sed "s/%INITIAL_VERSION%/$INITIAL_VERSION/g" \
		| sed "s/%MAJOR_VERSION%/$MAJOR_VERSION/g" \
		| sed "s/%MINOR_VERSION%/$MINOR_VERSION/g" \
		| sed "s/%MICRO_VERSION%/$MICRO_VERSION/g" \
		| sed "s/%PROGRAM_NAME%/$PROGRAM_NAME/g" \
                | sed "s/%FULL_PROGRAM_NAME%/$FULL_PROGRAM_NAME/g" \
                | sed "s/%GENERIC_PROGRAM_NAME%/$GENERIC_PROGRAM_NAME/g" \
                >$PROJECT_DIR/${PROGRAM_NAME_LC}-${MAJOR_VERSION}.${MINOR_VERSION}.pc.in
            echo "Wrote $PROJECT_DIR/${PROGRAM_NAME_LC}-${MAJOR_VERSION}.${MINOR_VERSION}.pc.in"
        fi
    fi
    
    touch $PROJECT_DIR/src/${PROGRAM_NAME_LC}.c
    if test "$PKG_TYPE" = "application"; then
        touch $PROJECT_DIR/src/data/glade/${PROGRAM_NAME}.glade
    fi
}



. $BOILERPLATE_PREFIX/scripts/module_arg_parse.sh


