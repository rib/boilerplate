#!/bin/sh

devenv_setup_env()
{
    src_dir=$(
	DEVENV_IGNORE_DEPS=1
	setup_env > /dev/null
	echo $DEVENV_DEV_SRC
    )
    dev_dir=$(
	DEVENV_IGNORE_DEPS=1
	setup_env > /dev/null
	echo $DEVENV_DEV_DIR
    )

    if test -z "$DEVENV_SOURCED_AS_DEPENDENCY"; then
        DEVENV_TOP_SRC_DIR=$src_dir
        export LD_LIBRARY_PATH=""
        export PKG_CONFIG_PATH=""
	export GI_TYPELIB_PATH=""
	export XDG_DATA_DIRS="/usr/local/share:/usr/share:/home/$USER/local/clutter-git-doc/share"
	export ACLOCAL_LOCALDIR=""

	echo "">.devenv.tmp
    fi

    # Don't re-setup the same project multiple times
    dir=`dirname $src_dir`
    package=`basename $dir`
    version=`basename $src_dir|sed "s/^$package-//"`
    if grep -q "@$package@" .devenv.tmp; then
	if ! grep -q "@$package@@$version@" .devenv.tmp; then
	    echo -n "[warning] package version conflict for $package "
	    echo "when adding $package [$version]"
	    prev_version=`cat .devenv.tmp|grep "@$package@"|cut -d'@' -f4`
	    echo    "          previous version added was [$prev_version]"
	fi
	return
    fi
    echo "@$package@@$version@" >> .devenv.tmp

    if test -z "$DEVENV_UPDATE_TAGS"; then
	echo "Adding project $package [$version]"
    fi

    _devenv_tag_update_hook $src_dir

    setup_env

    # NB: After this point the project functions (setup_env, and
    #     list_files_to_tag) and variables (DEVENV_DEV_DIR and
    #     (DEVENV_DEV_SRC) now correspond to those belonging to
    # 	  the last processed dependency project!

    # Clean up
    if test -z "$DEVENV_SOURCED_AS_DEPENDENCY"; then
	if test -f $DEVENV_TOP_SRC_DIR/tag_files/tags-list -a \
		-n "$DEVENV_UPDATE_TAGS"; then
	    echo "Generating vimrc-tags"
	    cat $DEVENV_TOP_SRC_DIR/tag_files/tags-list > \
		$DEVENV_TOP_SRC_DIR/vimrc-tags
	    echo "" >> $DEVENV_TOP_SRC_DIR/vimrc-tags
	    echo "cscope kill -1" >> $DEVENV_TOP_SRC_DIR/vimrc-tags
	    cat $DEVENV_TOP_SRC_DIR/tag_files/cscope-list >> \
		$DEVENV_TOP_SRC_DIR/vimrc-tags
	fi

	if test -z "$DEVENV_UPDATE_TAGS"; then
	    export ACLOCAL="aclocal ${ACLOCAL_INCLUDES}"
	    export ACLOCAL_FLAGS="${ACLOCAL_INCLUDES}"

	    echo "Other misc environment variables:"
	    echo "> LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
	    echo "> PKG_CONFIG_PATH=$PKG_CONFIG_PATH"
	    echo "> ACLOCAL=$ACLOCAL"
	    echo "> XDG_DATA_DIRS=$XDG_DATA_DIRS"
	    echo "> GI_TYPELIB_PATH=$GI_TYPELIB_PATH"
	fi

	rm -f .devenv.tmp

	# To avoid polluting tab completion...
        unset devenv_setup_env
        unset devenv_add_dependency
        unset devenv_set_screen_title
        unset _devenv_tag_update_hook
	unset _devenv_update_tags
	unset devenv_add_project_src
        unset devenv_finish
    fi
}

devenv_add_dependency()
{
    if test -n "$DEVENV_IGNORE_DEPS"; then
	return
    fi

    #dir=`dirname $1`
    #version=`basename $1|cut -d'-' -f 2-`

    dir=`dirname $1`
    package=`basename $dir`
    version=`basename $1|sed "s/^$package-//"`

    DEVENV_SOURCED_AS_DEPENDENCY=$((DEVENV_SOURCED_AS_DEPENDENCY + 1))
    if test -f $dir/bashrc-$version; then
        source $dir/bashrc-$version
    elif test -f $dir/bashrc; then
        source $dir/bashrc
    else
	echo "Failed to find dependency: $package [$version]"
    fi
    DEVENV_SOURCED_AS_DEPENDENCY=$((DEVENV_SOURCED_AS_DEPENDENCY - 1))
    if test $DEVENV_SOURCED_AS_DEPENDENCY -eq 0; then
	unset DEVENV_SOURCED_AS_DEPENDENCY
    fi
}

devenv_set_screen_title()
{
    if test -z "$DEVENV_SOURCED_AS_DEPENDENCY"; then
        screen -X title $1
    fi
}

_devenv_update_tags()
{
    echo "Generating `basename $1` source file list..."
    # list_files_to_tag is defined for each project
    list_files_to_tag $1> tag_files/files
    if test "`wc -l tag_files/files|cut -d' ' -f1`" != "0"; then
	echo "Running Cscope..."
	cscope -buq -itag_files/files
	echo "Running Exuberant Ctags..."
	exuberant-ctags -Ltag_files/files
    else
	echo "No files to index"
    fi
}

# If $DEVENV_UPDATE_TAGS is unset, this function does nothing.
# If $DEVENV_UPDATE_TAGS is set, then at least the tags for the top level
# source will be updated
# If $DEVENV_UPDATE_ALL_TAGS is set, then the tags of all dependencies are
# also updated
_devenv_tag_update_hook()
{
    if test -z "$DEVENV_UPDATE_TAGS"; then
        return
    fi

    # The top source directory is where we want to create our vimrc-tags file
    # which lists all of the tag files
    if test -z "$DEVENV_SOURCED_AS_DEPENDENCY"; then
	mkdir -p tag_files
        echo -n "set tags=" > $DEVENV_TOP_SRC_DIR/tag_files/tags-list
        rm -f $DEVENV_TOP_SRC_DIR/tag_files/cscope-list
	echo "">$DEVENV_TOP_SRC_DIR/tag_files/updated-projects
    fi

    # For projects that are dependencies of multiple other dependencies
    # we don't want to repeatedly update their tags
    if grep -q "@$1@" $DEVENV_TOP_SRC_DIR/tag_files/updated-projects; then
	return
    else
	echo "@$1@" > $DEVENV_TOP_SRC_DIR/tag_files/updated-projects
    fi

    if test -d $1; then
	pushd $1 >/dev/null
	mkdir -p tag_files
	if test -z "$DEVENV_SOURCED_AS_DEPENDENCY"; then
	    _devenv_update_tags $1
	elif test -n "$DEVENV_SOURCED_AS_DEPENDENCY" \
		-a -n "$DEVENV_UPDATE_ALL_TAGS"; then
	    _devenv_update_tags $1
	fi
	popd >/dev/null
    
	echo -n "$1/tags," >> \
	    $DEVENV_TOP_SRC_DIR/tag_files/tags-list
	echo "cscope add $1/cscope.out" >> \
	    $DEVENV_TOP_SRC_DIR/tag_files/cscope-list
    fi
}

devenv_finish()
{
    echo "deprecated devenv_finish"
}


