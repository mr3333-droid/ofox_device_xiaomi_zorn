#
# Copyright (C) 2023 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/xiaomi/zorn

# Inherit from device.mk configuration
$(call inherit-product, $(DEVICE_PATH)/device.mk)

# Release name
PRODUCT_RELEASE_NAME := zorn

## Device identifier
PRODUCT_DEVICE := zorn
PRODUCT_NAME := twrp_zorn
PRODUCT_BRAND := POCO
PRODUCT_MODEL := POCO F7 Pro
PRODUCT_MANUFACTURER := Xiaomi

