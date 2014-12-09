#!/bin/bash - 
#===============================================================================
#
#          FILE: make.sh
# 
#         USAGE: ./make.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Tony lEE <lüftreich@gmail.com>
#  ORGANIZATION: 
#       CREATED: 10/22/2014 10:38
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
set -o nounset                              # Treat unset variables as an error

cur_cmd=`readlink -f $0`
cur_dir=${cur_cmd%/*}

cd $cur_dir || exit

echo "$*" | grep 'sync' && {
    ##
    cd ./res || exit
    
    touch TIME_TAG.zip
    touch -t 198302231200.00 *.zip
    # rsync -rlpgoDPc -e ssh server:/work/temp/imaxpo_xbmc_addons/*.zip . | grep '\.zip' || {
    rsync -rlpgoDPc                 /work/temp/imaxpo_xbmc_addons/*.zip . | grep '\.zip' || {
        echo "no zip sync ?? now exit !"
        exit 7
    }
    
    echo -n 'any key continue ...'; read LUFT
    for _zip in `find . -maxdepth 1 -name "*.zip" -newer TIME_TAG.zip`; do
        7z x $_zip -o"../src"
    done

    sync
    cd ..
}

ls src/repository.imaxpo/addon.xml || exit
cat src/repository.imaxpo/addon.xml | head -n5
echo '....'
echo -n '<!> 确认repo已经更新 ?? [Y/n] '
read LUFT
[ "$LUFT" = "Y" -o "$LUFT" = "y" ] && {
    python addons_xml_and_zipfile_generator.py 
    git status -u
    echo -n 'Push to Github, any key continue ...'; read LUFT
    git add .
    git commit -a -m 'update'
    git push
}

