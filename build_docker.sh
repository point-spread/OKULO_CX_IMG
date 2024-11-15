#!/bin/bash
PRE_DIR=`pwd`
SCRIPTS_DIR=$(readlink -f "$(dirname "$0")")
cd "$SCRIPTS_DIR" || exit

version=v1.0.0

function c_echo() 
{
    local color=$1
    local text=$2
    case $color in
        "r") tput setaf 1;;
        "g") tput setaf 2;;
        "y") tput setaf 3;;
        "b") tput setaf 4;;
        *) tput setaf 7;;
    esac
    echo $text
    tput sgr0
}

while getopts ":v:" opt; do
    case $opt in
    v)
        version=$OPTARG
        ;;
    \?)
        c_echo r "wrong parameter!"
        ;;
    esac
done

[ ! -d opt ] && mkdir opt
[ ! -f opt/gcc-ubuntu-9.3.0-2020.03-x86_64-aarch64-linux-gnu.tar.gz ] && cp $UBUNTU_GCC_CROSS_TARGZ opt/

if [[ "$version" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    c_echo g "start build okulo_cx_img.$version.tar.gz!"
    docker build -t okulo_cx_img:$version --squash=true . 2>&1 | tee $PRE_DIR\build_output.log
    # docker build -t okulo_cx_img:$version . 2>&1 | tee $PRE_DIR\build_output.log
    [ ! -d build ] && mkdir build
    docker save -o build/okulo_cx_img.$version.tar.gz okulo_cx_img:$version
    if [ -f build/okulo_cx_img.$version.tar.gz ];then
        c_echo g "Build successfully okulo_cx_img.$version.tar.gz!"
    else
        c_echo r "Build failed"
    fi
else
    c_echo r "Wrong Version format!"
fi