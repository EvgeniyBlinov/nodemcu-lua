######################################################################
# Makefile user configuration
######################################################################

-include .env
export

# Path to nodemcu-uploader (https://github.com/kmpm/nodemcu-uploader)
NODEMCU-UPLOADER?=python ../nodemcu-uploader/nodemcu-uploader.py

# Path to LUA cross compiler (part of the nodemcu firmware; only needed to compile the LFS image yourself)
LUACC?=../nodemcu-firmware/luac.cross

# Serial port
PORT?=$(shell ls /dev/cu.SLAB_USBtoUART /dev/ttyUSB* 2>/dev/null|head -n1)
SPEED?=115200


define _upload
@$(NODEMCU-UPLOADER) -b $(SPEED) --start_baud $(SPEED) -p $(PORT) upload --compile $^
endef

######################################################################

LFS_IMAGE ?= lfs.img
CONFIG := config.lua
TESTS_FILE := tests.lua
CONFIG_TPL := config.lua.tpl
LUA_FILES := $(filter-out $(CONFIG), $(wildcard *.lua) $(wildcard src/*.lua))
ALL_LUA_FILES := $(filter-out $(TESTS_FILE), $(wildcard *.lua) $(wildcard src/*.lua))
LFS_FILES := $(LFS_IMAGE) $(filter-out $(CONFIG), $(wildcard *.lua) $(wildcard src/*.lua))
FILE ?=

# Print usage
usage:
	@echo "make upload FILE:=<file>  to upload a specific file (i.e make upload FILE:=init.lua)"
	@echo "make upload_all           to upload all"
	@echo "make upload_lfs           to upload lfs based server code"
	@echo "make upload_all_lfs       to upload all (LFS based)"
	@echo "make lint                 run linters"

$(CONFIG):
	envsubst < $(CONFIG_TPL) > $(CONFIG)

config:
	@rm $(CONFIG) 2> /dev/null || true
	@$(MAKE) $(CONFIG)

# Upload one file only
upload: $(FILE)
	$(_upload)

# Upload wifi configuration
upload_wifi_config: config
	$(_upload)

# Upload lfs image
upload_lfs: $(LFS_FILES)
	$(_upload)

$(LFS_IMAGE):
	$(LUACC) -f -o $(LFS_IMAGE) srv/*.lua

# Upload all non-lfs files
upload_all: $(ALL_LUA_FILES)
	$(_upload)

# Upload all lfs files
upload_all_lfs: $(LFS_FILES) $(CONFIG)
	$(_upload)

lint:
	luacheck --config ./.luacheckrc .

tests:
	lua tests.lua

.ENTRY: usage
.PHONY: usage config upload_wifi_config \
upload_lfs upload_all upload_all_lfs lint tests
# luarocks install luacheck
