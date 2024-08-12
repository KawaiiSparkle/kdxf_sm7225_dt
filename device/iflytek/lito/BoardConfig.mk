DEVICE_PATH := device/vendor/codename

# Architecture
TARGET_ARCH := arm64 # ro.bionic.arch
TARGET_ARCH_VARIANT := armv8-a # 64位默认变体
TARGET_CPU_ABI := arm64-v8a # ro.vendor.product.cpu.abilist64 (至少在小米设备上没有找到ro.product.cpu.abilist)
TARGET_CPU_ABI2 := # 64位留空
TARGET_CPU_VARIANT := generic # 默认一般都是通用
TARGET_CPU_VARIANT_RUNTIME := generic # ro.bionic.cpu_variant

TARGET_2ND_ARCH := arm # ro.bionic.2nd_arch
TARGET_2ND_ARCH_VARIANT := $(TARGET_ARCH_VARIANT)
TARGET_2ND_CPU_ABI := armeabi-v7a # ro.vendor.product.cpu.abilist32第一个
TARGET_2ND_CPU_ABI2 := armeabi # ro.vendor.product.cpu.abilist32第二个
TARGET_2ND_CPU_VARIANT := $(TARGET_CPU_VARIANT)
TARGET_2ND_CPU_VARIANT_RUNTIME := $(TARGET_CPU_VARIANT)

# Assertation
TARGET_OTA_ASSERT_DEVICE := lito # codename

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := lito # ro.product.board
TARGET_NO_BOOTLOADER := true
TARGET_USES_UEFI := true

# Build Rule
ALLOW_MISSING_DEPENDENCIES := true # 为了recovery不健全的依赖

# Kernel - 注释会说明在boot/recovery/vendor_boot.json中对应的变量
BOARD_BOOT_HEADER_VERSION := 3 # headerVersion
BOARD_KERNEL_BASE := 0x00008000 # (kernelLoadAddr - 32KB) qcom设备base为0，且没有偏移(offset)
BOARD_KERNEL_CMDLINE := console=ttyMSM0,115200,n8 earlycon=msm_geni_serial,0x888000 androidboot.hardware=qcom androidboot.console=ttyMSM0 androidboot.memcg=1 lpm_levels.sleep_disabled=1 video=vfb:640x400,bpp=32,memsize=3072000 msm_rtb.filter=0x237 service_locator.enable=1 androidboot.usbcontroller=a600000.dwc3 swiotlb=2048 cgroup.memory=nokmem,nosocket loop.max_part=7 buildvariant=eng # cmdline
BOARD_KERNEL_PAGESIZE := 4096 # pageSize
BOARD_RAMDISK_OFFSET := 0x01000000 # (ramdisk,loadAddr - BOARD_KERNEL_BASE)
BOARD_KERNEL_TAGS_OFFSET := 0x07c88000 # (tagsLoadAddr - BOARD_KERNEL_BASE)
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)

# Kernel - prebuilt
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel # 预编译内核相对于android源码根目录的相对路径，vendor_boot机型不需要
TARGET_PREBUILT_DTB := $(DEVICE_PATH)/prebuilt/dtb.img # 同上
BOARD_MKBOOTIMG_ARGS += --dtb $(TARGET_PREBUILT_DTB)

# Partitions
BOARD_FLASH_BLOCK_SIZE := 262144 # (BOARD_KERNEL_PAGESIZE * 64)
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864 # boot/recovery/vendor_boot镜像的字节大小需原厂或手机完整提取出来的，不定义会报错
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864 # 同上
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 67108864 # 同上
BOARD_SYSTEMIMAGE_PARTITION_TYPE := ext4 # 分区类型，查看ramdisk中fstab定义的类型
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor # 定义vendor目录，例如copy专有blobs要用
BOARD_SUPER_PARTITION_SIZE := 9126805504 # 可以通过blockdev --getsize64 /dev/block/bootdevice/by-name/super获取，需root，如果无法root可以直接使用这个值，不影响twrp启动，可以后续修正
BOARD_SUPER_PARTITION_GROUPS := xiaomi_dynamic_partitions # xiaomi根据你获取资料的vendor替换，是一个动态分区组
BOARD_XIAOMI_DYNAMIC_PARTITIONS_PARTITION_LIST := system vendor product system_ext odm vendor_dlkm odm_dlkm # 根据fstab内的定义，一般flag包含logical都属于动态分区组的一部分
BOARD_XIAOMI_DYNAMIC_PARTITIONS_SIZE := 9122611200 # (BOARD_SUPER_PARTITION_SIZE - 4MB)

# Platform
TARGET_BOARD_PLATFORM := mt6895 # ro.board.platform

# Recovery - 基本通用的不影响启动
BOARD_HAS_LARGE_FILESYSTEM := true
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

# Treble
BOARD_VNDK_VERSION := current # 声明VNDK版本

# Vendor_boot recovery ramdisk
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true # 将recovery文件复制到vendor_boot

# Boot recovery ramdisk
#BOARD_USES_RECOVERY_AS_BOOT := true recovery ramdisk合并在boot中启用

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3

# TWRP Configurations
TW_DEFAULT_LANGUAGE := zh_CN # 默认为中文
TW_EXTRA_LANGUAGES := true # 额外的语言
TW_THEME := portrait_hdpi # 主题
TW_INCLUDE_FASTBOOTD := true # 包括fastbootd，为动态分区

# 其它flag还有很多，可以在https://xdaforums.com/t/twrp-flags-for-boardconfig-mk.3333970 查找，
# 这篇文章也很老了，但我并不推荐twrp，所以flag我也不是很了解，多翻翻github:)

# Debug
TARGET_USES_LOGD := true # 调试flag
TWRP_INCLUDE_LOGCAT := true