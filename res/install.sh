#!/bin/sh
#===============================================================================
#
#          FILE: install.sh
# 
#         USAGE: ./install.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Tony lEE <lüftreich@gmail.com>
#  ORGANIZATION: 
#       CREATED: 09/22/2014 16:25
#      REVISION:  ---
#===============================================================================
#
#                     (c) Copyright LUFT.Ltd 2014 - 2144, All Rights Reserved
#
# Revision History:
#                       Modification     Tracking
# Author (core ID)          Date          Number     Description of Changes
# -------------------   ------------    ----------   ----------------------
#
# Lüftreich             **/**/2014        2.0        ****
# Lüftreich             **/**/2014        1.0        ****
#===============================================================================

# set -x              # Print commands and their arguments as they are executed
# set -o nounset                              # Treat unset variables as an error

cur_cmd=`busybox readlink -f $0`
cur_dir=${cur_cmd%/*}
cd $cur_dir || err_msg "DIR"
zip_dir=mxb01

err_msg()
{
    echo "$*"
    exit 7
}

usage()
{
    echo "USAGE: `basename $0` < zip | ins >"
}

pack_zip()
{
    [ $# -eq 2 ] && zip_dir="${zip_dir}_$2"
    cd $cur_dir || err_msg "DIR"
    rm -rf ${zip_dir}*; sync
    mkdir -p $zip_dir

    for _zip in *.zip; do
        echo $_zip | grep -q 'mxb[0-9][0-9]' && continue
        cd $zip_dir
        unzip ../$_zip
        cd -
    done
    \cp -af $cur_cmd $zip_dir/
    sed -i 's/\/bin\/sh/\/system\/bin\/sh/g' $zip_dir/`basename $0`
    sync; sync
    7z a ${zip_dir}.zip $zip_dir

    mkdir -p /tmp/.samba
    \cp -avf ${zip_dir}.zip /tmp/.samba
    sync
}

push_zip()
{
    busybox uname -m | busybox grep armv7l || err_msg 'ERR: MUST BE ARM'
    addons_dir='/mnt/sdcard/Android/data/org.xbmc.xbmc/files/.xbmc/addons'
    cd $cur_dir || exit

    busybox mkdir -p $addons_dir
    busybox cp -af * $addons_dir/
    busybox rm -f  $addons_dir/`busybox basename $0`

    busybox sync
    busybox sync
    busybox sync
}

case $1 in
    zip)
        pack_zip $*
        exit
        ;;
    help)
        usage
        ;;
    *)
        push_zip
        ;;
esac


exit $?


