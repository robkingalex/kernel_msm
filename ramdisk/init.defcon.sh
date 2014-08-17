#!/system/bin/sh
bb=busybox
echo "[defcon] Welcome to Ultimate Kernel Series" | tee /dev/kmsg

# Disable mpdecision & thermald
	stop thermald
	stop mpdecision
	echo 1 > /sys/module/msm_thermal/parameters/enabled
	echo "[defcon] thermald & mpdecision disabled" | tee /dev/kmsg
	echo "[defcon] Intelli-Thermal Enabled!" | tee /dev/kmsg

# Neobuddy Intelliplug options
# profile selections for full_mode_profile
# 0 balanced 4 cores (default)
# 1 performance 4 cores
# 2 conservative 4 cores saves battery
# 3 disable
# 4 Tri
# 5 Eco
# 6 Strict
# runthreshold default is 722
# hystersis choice 0 thru 16 default is 8
# max_cpus_online <---
# cpus_boosted = max cpus boosted
# max_cpus_online_susp = max cpu's while suspended
	echo "1" > /sys/kernel/intelli_plug/intelli_plug_active
	echo "0" > /sys/kernel/intelli_plug/parameters/full_mode_profile
	echo "4" > /sys/kernel/intelli_plug/max_cpus_online
	echo "1" > /sys/kernel/intelli_plug/min_cpus_online
	echo "3" > /sys/kernel/intelli_plug/cpus_boosted
	echo "1" > /sys/kernel/intelli_plug/max_cpus_online_susp
	echo "722" > /sys/kernel/intelli_plug/parameters/cpu_nr_run_threshold
	echo "8" > /sys/kernel/intelli_plug/parameters/nr_run_hysteresis
	echo "[defcon] Intelliplug fully optimized!" | tee /dev/kmsg

# Set TCP westwood
	echo "westwood" > /proc/sys/net/ipv4/tcp_congestion_control
	echo "[defcon] TCP set: westwood" | tee /dev/kmsg

# Set IntelliActive as default:	
	echo "HYPER" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
	echo "HYPER" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
	echo "HYPER" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
	echo "HYPER" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
	echo "384000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	echo "384000" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
	echo "384000" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
	echo "384000" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
	echo "[defcon] HYPER CPU Governor activated" | tee /dev/kmsg

# Set Power Save Settings
	echo 1 > /sys/module/pm_8x60/modes/cpu0/wfi/suspend_enabled
	echo 1 > /sys/module/pm_8x60/modes/cpu0/power_collapse/suspend_enabled
	echo 1 > /sys/module/pm_8x60/modes/cpu1/power_collapse/suspend_enabled
	echo 1 > /sys/module/pm_8x60/modes/cpu2/power_collapse/suspend_enabled
	echo 1 > /sys/module/pm_8x60/modes/cpu3/power_collapse/suspend_enabled
	echo 1 > /sys/module/pm_8x60/modes/cpu0/standalone_power_collapse/suspend_enabled
	echo 1 > /sys/module/pm_8x60/modes/cpu1/standalone_power_collapse/suspend_enabled
	echo 1 > /sys/module/pm_8x60/modes/cpu2/standalone_power_collapse/suspend_enabled
	echo 1 > /sys/module/pm_8x60/modes/cpu3/standalone_power_collapse/suspend_enabled
	echo "[defcon] Power saving modes Enabled" | tee /dev/kmsg

# Set IOSched
	echo "fiops" > /sys/block/mmcblk0/queue/scheduler
	echo "[defcon] IOSched set: fiops" | tee /dev/kmsg

# Sweep2Dim default
	echo "0" > /sys/android_touch/sweep2wake
	echo "1" > /sys/android_touch/sweep2dim
	echo "73" > /sys/module/sweep2wake/parameters/down_kcal
	echo "73" > /sys/module/sweep2wake/parameters/up_kcal
	echo "[defcon] sweep2dim enabled!" | tee /dev/kmsg

# Set RGB KCAL
if [ -e /sys/devices/platform/kcal_ctrl.0/kcal ]; then
	sd_r=255
	sd_g=255
	sd_b=255
	kcal="$sd_r $sd_g $sd_b"
	echo "$kcal" > /sys/devices/platform/kcal_ctrl.0/kcal
	echo "1" > /sys/devices/platform/kcal_ctrl.0/kcal_ctrl
	echo "[defcon] LCD_KCAL: red=[$sd_r], green=[$sd_g], blue=[$sd_b]" | tee /dev/kmsg
fi

# disable sysctl.conf to prevent ROM interference with tunables
	$bb mount -o rw,remount /system;
	$bb [ -e /system/etc/sysctl.conf ] && $bb mv -f /system/etc/sysctl.conf /system/etc/sysctl.conf.fkbak;

# disable the PowerHAL since there is a kernel-side touch boost implemented
	$bb [ -e /system/lib/hw/power.msm8960.so.fkbak ] || $bb cp /system/lib/hw/power.msm8960.so /system/lib/hw/power.msm8960.so.fkbak;
	$bb [ -e /system/lib/hw/power.msm8960.so ] && $bb rm -f /system/lib/hw/power.msm8960.so;

# create and set permissions for /system/etc/init.d if it doesn't already exist
	$bb mkdir /system/etc/init.d;
	$bb chown -R root.root /system/etc/init.d;
	$bb chmod -R 775 /system/etc/init.d;
	$bb mount -o ro,remount /system;
	echo "[defcon] init.d permissions set" | tee /dev/kmsg

# Interactive Options
	echo 20000 1300000:40000 1400000:20000 > /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay
	echo 85 1300000:90 1400000:70 > /sys/devices/system/cpu/cpufreq/interactive/target_loads

# GPU Max Clock
	echo "400000000" > /sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0/max_gpuclk
	echo "[defcon] GPU Max Clock Set" | tee /dev/kmsg
