#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2025 The OrangeFox Recovery Project
#
#	OrangeFox is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	any later version.
#
#	OrangeFox is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
# 	This software is released under GPL version 3 or any later version.
#	See <http://www.gnu.org/licenses/>.
#
# 	Please maintain this if you use this script or any part of it
#

#set -o xtrace
FDEVICE="zorn"

fox_get_target_device() {
	export script_path="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
	if echo "$script_path" | grep -q "$FDEVICE"; then
		FOX_BUILD_DEVICE="$FDEVICE"
	elif echo "$0" | grep -q "$FDEVICE"; then
		FOX_BUILD_DEVICE="$FDEVICE"
	fi
}

if [ -z "$FOX_BUILD_DEVICE" ]; then
	fox_get_target_device
fi

if [ "$FOX_BUILD_DEVICE" = "$FDEVICE" ]; then
	echo "Detected build device: $FOX_BUILD_DEVICE"

# Review build flags with below links:
# https://gitlab.com/OrangeFox/vendor/recovery/-/raw/fox_14.1/orangefox_build_vars.txt
# https://gitlab.com/OrangeFox/bootable/Recovery/-/raw/fox_14.1/orangefox.mk

    # Build
	export LC_ALL="C"
	export FOX_VANILLA_BUILD=1
	export ALLOW_MISSING_DEPENDENCIES=true

	# A/B Partition
	export FOX_AB_DEVICE=1
	export FOX_VIRTUAL_AB_DEVICE=1
	export FOX_RECOVERY_SYSTEM_PARTITION="/dev/block/mapper/system"
	export FOX_RECOVERY_VENDOR_PARTITION="/dev/block/mapper/vendor"

	# Compression Binaries & Tools
	export FOX_USE_BASH_SHELL=1
	export FOX_USE_TAR_BINARY=1
	export FOX_USE_LZ4_BINARY=1
	export FOX_USE_SED_BINARY=1
	export FOX_USE_XZ_UTILS=1
	export FOX_USE_DATE_BINARY=1
	export FOX_USE_ZSTD_BINARY=1
	export FOX_USE_FSCK_EROFS_BINARY=1
	export FOX_DELETE_AROMAFM=1
	export FOX_REMOVE_AAPT=1
	export FOX_USE_BUSYBOX_BINARY=1
	export FOX_USE_GREP_BINARY=1

  # KernelSU / Magisk Support
  	export FOX_USE_SPECIFIC_MAGISK_ZIP="$(echo "$script_path"/prebuilt/Magisk*.zip)"
	export FOX_MOVE_MAGISK_INSTALLER_TO_RAMDISK=1
	export FOX_ENABLE_KERNELSU_SUPPORT=1
	export FOX_ENABLE_KERNELSU_NEXT_SUPPORT=1
	export FOX_ENABLE_SUKISU_SUPPORT=1
	export FOX_USE_UPDATED_MAGISKBOOT=1

	# Fox Settings
	export FOX_SETTINGS_ROOT_DIRECTORY="/persist"
	export FOX_MISCELLANEOUS_ROOT_DIRECTORY="/sdcard"

else
	echo "I: vendorsetup.sh skipped; device mismatch or environment issue."
fi
