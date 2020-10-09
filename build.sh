#!/bin/bash
#################################################
#### Stock Build Script v1.0 for Exynos7580 ####
################### Dev name ####################
S_DEV=Samsung
#################### Main Dir ###################
S_DIR=$(pwd)
############## Define toolchan path #############
S_TC=~/aarch64/bin/aarch64-linux-android-
### Define proper arch and dir for dts files ###
S_DTS=arch/arm64/boot/dts
########### Compiled image location #############
S_KERNEL=$S_DIR/arch/arm64/boot/Image
################## Thread count #################
S_JOBS=$((`nproc`-1))
########### Target Android version ##############
S_PLATFORM=7
################## Target ARCH ##################
S_ARCH=arm64
################# Current Date ##################
S_DATE=$(date +%Y%m%d)
############## Build Requirements ###############
export ARCH=$S_ARCH
export CROSS_COMPILE=$S_TC
export PLATFORM_VERSION=$S_PLATFORM
############### Naming the kernel ###############
export KBUILD_BUILD_HOST=SWF
export KBUILD_BUILD_USER=$S_DEV
##### Device specific Variables [SM-J710FN] ######
S_CONFG_J710FN=j7xelteswa_00_defconfig
S_VARIANT_J710FN=J710FN
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
	echo "Building zImage for $S_VARIANT"
	export LOCALVERSION=-$S_VARIANT
	make  $S_CONFG
	make -j$S_JOBS
	if [ ! -e ./arch/arm64/boot/Image ]; then
	exit 0;
	echo "Image Failed to Compile"
	echo " Abort "
	fi
	du -k "$S_KERNEL" | cut -f1 >sizT
	sizT=$(head -n 1 sizT)
	rm -rf sizT
	echo " "
	echo "----------------------------------------------"
}
################## Main Menu ####################
clear
echo "----------------------------------------------"
echo "Stock Kernel Script"
echo "----------------------------------------------"
PS3='Please select your option (1-2): '
menuvar=("SM-J710FN" "Exit")
select menuvar in "${menuvar[@]}"
do
    case $menuvar in
        "SM-J710FN")
            clear
            echo "Starting $S_VARIANT_J710FN kernel build..."
            S_VARIANT=$S_VARIANT_J710FN
            S_CONFG=$S_CONFG_J710FN
            BUILD_ZIMAGE
            echo " "
            echo "----------------------------------------------"
            echo "$S_VARIANT kernel build finished."
            echo "Kernel Image Size = $sizT Kb"
            echo "Press Any key to end the script"
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
