
if test $# -lt 1; then
    echo "Dont run directly"
    exit 1
fi


case $1 in
    synopsis)
        synopsis
        exit 0
    ;;
    summary)
        summary
        exit 0
    ;;
    flags)
        flags
        exit 0
    ;;
    run)
        shift
        run "$@"
    ;;
    *)
        echo "Dont run directly"
        exit 0
    ;;
esac

