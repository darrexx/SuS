# Hey Emacs, this is a -*- makefile -*-

APP := aostubs
CONFIGDIR = config
ARCH = _msp430

KCONFDIR := kconf
QCONFFRONTEND ?= $(KCONFDIR)/kconfig/qconf
MCONFFRONTEND ?= $(KCONFDIR)/kconfig/mconf
TRANSFORM=$(KCONFDIR)/common/scripts/transform.pl

# Advice user to change its working directory to compile aostubs without kconfig
all:
	@echo "Error: You cannot compile in this directory."
	@echo "       Please change your working directory to ./src/"

wsim: all
wsim-net: all
flash: all
clean: all

.PHONY: xconfig menuconfig transform

# This phony target allows the user to change the configuration without
# the need for any of the dependencies to have changed

xconfig: $(APP).temp.fm
#	@if ! test -e $(QCONFFRONTEND); then make -C kconf/kconfig xconfig; fi
	$(QCONFFRONTEND) $(APP).temp.fm $(APP).config
	
#gconfig: $(APP).temp.fm
#	@if ! test -e $(GCONFFRONTEND); then make -C kconf/kconfig gconfig; fi
#	$(GCONFFRONTEND) $(APP).temp.fm $(APP).config
	
menuconfig: $(APP).temp.fm
#	@if ! test -e $(MCONFFRONTEND); then make -C kconf/kconfig menuconfig; fi
	$(MCONFFRONTEND) $(APP).temp.fm $(APP).config

#config: $(APP).temp.fm
#	@if ! test -e $(ICONFFRONTEND); then make -C kconf/kconfig config; fi
#	@if test -e $(APP).config; then mv $(APP).config .config; fi
#	$(ICONFFRONTEND) $(APP).temp.fm
#	@if test -e .config; then mv .config $(APP).config; fi
	
# generates a variant of OS and application from the configuration
FMDIR := $(KCONFDIR)/common/family/
FAMILYMODELS ?= $(FMDIR)aostubs.cmp.pl:$(FMDIR)user.cmp.pl

transform: $(APP).config
	$(TRANSFORM) -f $(APP).config -i src/ -o $(CONFIGDIR) -a $(ARCH) -m "$(FAMILYMODELS)" $(TRANSFORMFLAGS)
	@awk -f $(KCONFDIR)/common/scripts/conf2h.awk $(APP).config > $(CONFIGDIR)/kconfig.h
	@chmod +x config/scripts/rfuploader/uploader.sh config/scripts/rfuploader/rfuploader.tcl

$(APP).temp.fm:
	@echo source $(KCONFDIR)/common/features/aostubs.fm         >$@
	@echo source $(KCONFDIR)/common/features/user.fm           >>$@


.PHONY: $(APP).temp.fm

.INTERMEDIATE: $(APP).temp.fm
