#!/bin/bash

shopt -s extglob
SHELL_FOLDER=$(dirname $(readlink -f "$0"))

rm -rf package/boot package/feeds/kiddin9/accel-ppp package/devel/kselftests-bpf package/network/utils/uqmi package/feeds/routing/batman-adv

rm -rf target/linux/generic/!(*-5.15) target/linux/rockchip package/kernel

git_clone_path istoreos-22.03 https://github.com/istoreos/istoreos package/boot target/linux/rockchip package/kernel

git_clone_path istoreos-22.03 https://github.com/istoreos/istoreos mv target/linux/generic

wget -N https://github.com/istoreos/istoreos/raw/istoreos-22.03/include/kernel-5.10 -P include/

sed -i "/KernelPackage,ptp/d" package/kernel/linux/modules/other.mk

mv -f tmp/r8125 feeds/kiddin9/

sed -i -e 's,kmod-r8168,kmod-r8169,g' target/linux/rockchip/image/rk35xx.mk
sed -i -e 's,wpad-openssl,wpad-basic-mbedtls,g' target/linux/rockchip/image/rk35xx.mk

wget -N https://github.com/istoreos/istoreos/raw/istoreos-22.03/include/netfilter.mk -P include/

wget -N https://raw.githubusercontent.com/coolsnowwolf/lede/master/package/kernel/linux/modules/video.mk -P package/kernel/linux/modules/

wget -N https://github.com/coolsnowwolf/lede/raw/master/target/linux/generic/hack-5.10/953-net-patch-linux-kernel-to-support-shortcut-fe.patch -P target/linux/generic/hack-5.10/
wget -N https://raw.githubusercontent.com/coolsnowwolf/lede/master/target/linux/generic/pending-5.10/613-netfilter_optional_tcp_window_check.patch -P target/linux/generic/pending-5.10/

sed -i 's/DEFAULT_PACKAGES +=/DEFAULT_PACKAGES += fdisk lsblk kmod-drm-rockchip/' target/linux/rockchip/Makefile

cp -Rf $SHELL_FOLDER/diy/* ./

echo '
CONFIG_SENSORS_PWM_FAN=y
' >> ./target/linux/rockchip/rk35xx/config-5.10
