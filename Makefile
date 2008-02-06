#
# iDJ Makefile
#
# Usage: make (build project, results end up in build/Release/iDJ.app)
#        make transfer (build and copy entire .app to iPhone via scp)
#        make transferq (build and copy the iDJ application only iPhone via scp - quicker)
#        make test (log on to your iPhone for testing)
#        make clean (remove build files)
#

#---------- Project Settings ----------

# Project Settings
PROJECT_NAME=iDJ
SOURCE_ROOT=.
SOURCE_LIST=main.m \
		MasterAudioController.m \
		PartyApplication.m \
		CompleteView.m \
		TurntableGLView.m \
		TurntableAudio.m \
		TurntableController.m \
		Stopwatch.m \
		Renderer.m \
		CrossFaderView.m \
		MultiTouchUIImageView.m \
		UIGLView.m \
		GLDrawer.m
FRAMEWORKS_LIST=-framework AppSupport \
				-framework AudioToolbox \
				-framework Celestial \
				-framework CoreAudio \
				-framework CoreFoundation \
				-framework CoreGraphics \
				-framework CoreSurface \
				-framework Foundation \
				-framework GraphicsServices \
				-framework LayerKit \
				-framework MultitouchSupport \
				-framework OpenGLES \
				-framework UIKit

# iPhone Device Settings
IPHONE_ADDRESS=hacked
IPHONE_APPS_PATH=/Applications/

# iPhone SDK Settings
IPHONE_SDK=/usr/local/arm-apple-darwin
IPHONE_ROOT_COPY=/usr/local/share/iphone-filesystem

# MadPlay Settings
MADPLAY=madplay/madplay-0.15.2b
LIBMADFLAGS = -L$(MADPLAY) -L$(MADPLAY)/.libs/libmad.a $(MADPLAY)/.libs/libid3tag.a

# Compiler Settings
CC=/usr/local/bin/arm-apple-darwin-gcc
CPPFLAGS = -I$(MADPLAY) -DAARON_TOOLCHAIN -std=c99
LD=$(CC)
LDFLAGS=-mmacosx-version-min=10.1 $(LIBMADFLAGS) -lobjc $(FRAMEWORKS_LIST)

# Variables normally supplied by Xcode
CONFIGURATION_TEMP_DIR=./build/$(PROJECT_NAME).build/Release
BUILT_PRODUCTS_DIR=./build/Release

#---------- Internal Variables ----------

RESOURCE_PATH=resources
SOURCE_PATH=$(addprefix $(SOURCE_ROOT)/,$(SOURCE_LIST))
INFOPLIST_FILE=$(RESOURCE_PATH)/Info.plist
INFOPLIST_PATH=$(addprefix $(SOURCE_ROOT)/,$(INFOPLIST_FILE))
EXECUTABLE_NAME=$(PROJECT_NAME)
BUNDLE_NAME=$(PROJECT_NAME).app
MODULES_LIST=\
	$(patsubst %.c,%.o,$(filter %.c,$(SOURCE_LIST))) \
	$(patsubst %.cc,%.o,$(filter %.cc,$(SOURCE_LIST))) \
	$(patsubst %.cpp,%.o,$(filter %.cpp,$(SOURCE_LIST))) \
	$(patsubst %.m,%.o,$(filter %.m,$(SOURCE_LIST))) \
	$(patsubst %.mm,%.o,$(filter %.mm,$(SOURCE_LIST)))
MODULES_PATH=$(addprefix $(CONFIGURATION_TEMP_DIR)/,$(MODULES_LIST))
BUNDLE_PATH=$(BUILT_PRODUCTS_DIR)/$(BUNDLE_NAME)
EXECUTABLE_PATH=$(BUNDLE_PATH)/$(EXECUTABLE_NAME)

#---------- Build Steps ----------

all: $(EXECUTABLE_PATH)

$(EXECUTABLE_PATH): $(BUNDLE_PATH) $(MODULES_PATH)
	$(LD) $(LDFLAGS) -o $(EXECUTABLE_PATH) $(MODULES_PATH)

$(BUNDLE_PATH): $(INFOPLIST_PATH)
	mkdir -p $(BUNDLE_PATH)
	cp $(INFOPLIST_PATH) $(BUNDLE_PATH)/
	cp $(SOURCE_ROOT)/$(RESOURCE_PATH)/*.png $(BUNDLE_PATH)/

$(CONFIGURATION_TEMP_DIR)/%.o: $(SOURCE_ROOT)/%.m
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

transfer: all
	scp -r $(BUNDLE_PATH) root@$(IPHONE_ADDRESS):$(IPHONE_APPS_PATH)

transferq: all
	scp -r $(BUNDLE_PATH)/$(EXECUTABLE_NAME) root@$(IPHONE_ADDRESS):$(IPHONE_APPS_PATH)$(BUNDLE_NAME)/

test: transferq
	ssh -t root@$(IPHONE_ADDRESS) $(IPHONE_APPS_PATH)$(BUNDLE_NAME)/$(EXECUTABLE_NAME)

testnow:
	ssh -t root@$(IPHONE_ADDRESS) $(IPHONE_APPS_PATH)$(BUNDLE_NAME)/$(EXECUTABLE_NAME)

clean:
	rm -r ./build
