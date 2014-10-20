#!/sbin/sh
mkdir /tmp/out
if [ -e /tmp/boot.img ]; then
	/tmp/unpackbootimg -i /tmp/boot.img -o /tmp/out
else
	echo "boot.img dump failed!" | tee /dev/kmsg
	exit 1
fi
rm -rf /tmp/boot.img
if [ -e /tmp/out/boot.img-ramdisk.gz ]; then
	rdcomp=/tmp/out/boot.img-ramdisk.gz
	echo "[AnyKernel] New ramdisk uses GZ compression." | tee /dev/kmsg
elif [ -e /tmp/out/boot.img-ramdisk.lz4 ]; then
	rdcomp=/tmp/out/boot.img-ramdisk.lz4
	echo "[AnyKernel] New ramdisk uses LZ4 compression." | tee /dev/kmsg
else
	echo "[AnyKernel] Unknown ramdisk format!" | tee /dev/kmsg
	exit 1
fi
/tmp/mkbootimg --kernel /tmp/kernel/zImage --ramdisk $rdcomp --cmdline "$(cat /tmp/out/boot.img-cmdline)" --base 0x$(cat /tmp/out/boot.img-base) --pagesize 2048 --ramdiskaddr 0x81800000 --output /tmp/boot.img
if [ -e /tmp/boot.img ]; then
	echo "[AnyKernel] Boot.img created successfully!" | tee /dev/kmsg
else
	echo "[AnyKernel] Boot.img failed to create!" | tee /dev/kmsg
	exit 1
fi
