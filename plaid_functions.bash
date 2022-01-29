
function plaidcd() {
    # usage: plaidcd PKG [SPACE]
    #   PKG: package name
    #   SPACE: top-level directory of the workspace to search (default: src)

    PKG=$1
    SPACE=${2:-src}

    # iterate over all package.xml files in the given space
    while IFS= read -r package_file ; do
        # get the package name
        package_name=$(xmllint --xpath "string(//package/name)" $package_file)

        # check if the package is the one saught
        if [ "$package_name" == "$PKG" ] ; then
            # change to the directory and stop iterating
            cd $(dirname $package_file)
            return
        fi
    done <<< $(find "${PLAID_WS_PATH}/${SPACE}" -name package.xml)
}
