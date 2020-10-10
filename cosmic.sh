#!/bin/bash
#################################################
#### Cosmic Build Script v1.0 for Exynos7580 ####
################### Dev name ####################
COSMIC_DEV=themagicalmammal
#################### Main Dir ###################
COSMIC_DIR=$(pwd)
############## Define toolchan path #############
COSMIC_TOOl=linaro
COSMIC_COMPILE_TYPE=elf-
COSMIC_TC=~/$COSMIC_TOOl/bin/aarch64-$COSMIC_COMPILE_TYPE
COSMIC_DATE=$(date +'%a %b %d %R:%S UTC %Y')
### Define proper arch and dir for dts files ###
COSMIC_DTS=arch/arm64/boot/dts
########### Compiled image location #############
COSMIC_KERNEL=$COSMIC_DIR/arch/arm64/boot/Image
############# Kernel Name & Version #############
COSMIC_VERSION=1.2
COSMIC_NAME=Cosmic
################## Thread count #################
COSMIC_JOBS=$((`nproc`-1))
########### Target Android version ##############
COSMIC_PLATFORM=7
################## Target ARCH ##################
COSMIC_ARCH=arm64
################## Last Commit ##################
COSMIC_LAST_COMMIT=$(git rev-parse --short HEAD)
############## Build Requirements ###############
export ARCH=$COSMIC_ARCH
export CROSS_COMPILE=$COSMIC_TC
export PLATFORM_VERSION=$COSMIC_PLATFORM
############### Naming the kernel ###############
export KBUILD_BUILD_HOST=$COSMIC_NAME
export KBUILD_BUILD_USER=$COSMIC_DEV
export KBUILD_BUILD_TIMESTAMP=$COSMIC_DATE
##### Device specific Variables [SM-J710F] ######
COSMIC_CONFG_J710F=cosmic_defconfig
COSMIC_VARIANT_J710F=J710X
############### Script functions ################
read -p "Clean or Dirty ? (c/d) > " yn
if [ "$yn" = "C" -o "$yn" = "c" ]; then
     echo "Clean Build"
     make clean && make mrproper
else
     echo "Dirty Build"
fi
################### Kernel ######################
BUILD_ZIMAGE()
{
	echo "----------------------------------------------"
	echo " "
	echo "Building zImage for $COSMIC_VARIANT"
	export LOCALVERSION=-$COSMIC_LAST_COMMIT-$COSMIC_VARIANT
	make  $COSMIC_CONFG
	make -j$COSMIC_JOBS
	if [ ! -e ./arch/arm64/boot/Image ]; then
	exit 0;
	echo "Image Failed to Compile"
	echo " Abort "
	fi
	du -k "$COSMIC_KERNEL" | cut -f1 >sizT
	sizT=$(head -n 1 sizT)
	rm -rf sizT
	echo " "
	echo "----------------------------------------------"
}
################## Main Menu ####################
clear
echo "----------------------------------------------"
echo "$COSMIC_NAME $COSMIC_VERSION Kernel Script"
echo "Build Date: $COSMIC_DATE"
echo "----------------------------------------------"
PS3='Please select your option (1-2): '
menuvar=("SM-J710X" "Exit")
select menuvar in "${menuvar[@]}"
do
    case $menuvar in
        "SM-J710X")
            clear
            echo "Starting $COSMIC_VARIANT_J710F kernel build..."
            COSMIC_VARIANT=$COSMIC_VARIANT_J710F
            COSMIC_CONFG=$COSMIC_CONFG_J710F
            BUILD_ZIMAGE
            echo " "
            echo "----------------------------------------------"
            echo "$COSMIC_VARIANT Build Complete."
            echo "Kernel Image Size = $sizT Kb"
            echo "Press any key to end the script"
            echo "----------------------------------------------"
            read -n1 -r key
            break
            ;;
            "Exit")
            break
            ;;
        *) echo Invalid option.;;
    esac
done
#################################################
########## coded by themagicalmammal ############
#################################################
