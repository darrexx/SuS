# Hey Emacs, this is a -*- makefile -*-

#----------------------------------------------------------------------------
# WinAVR Makefile Template written by Eric B. Weddington, Joerg Wunsch, et al.
#
# Released to the Public Domain
#
# Additional material for this makefile was written by:
# Peter Fleury
# Tim Henigan
# Colin O'Flynn
# Reiner Patommel
# Markus Pfaff
# Sander Pool
# Frederik Rouleau
# Carlos Lamas
# Ingo Korb
# Christoph Borchert
#
# To rebuild project do "make clean" then "make all".
#----------------------------------------------------------------------------

# Path to MSP430 gcc toolchain
#PATH := /fs/proj/compiler/msp430-gcc/bin:${PATH}

# Path to WSIM
PATH := /fs/proj/sus/wsim:${PATH}
PATH := /home/sus/wsim:${PATH}

# Path to AspectC++
PATH := /home/sus/compiler/aspectc:${PATH}

# Check if compiler is new TI compiler or old GCC one
TI_COMPILER := $(shell PATH=${PATH} msp430-elf-gcc -dumpversion > /dev/null 2>&1; echo `expr $$? = 0`)
ifeq ($(TI_COMPILER),1)
 $(info "Found TI compiler msp430-elf-gcc")
else
 $(info "Did not find TI compiler, falling back to msp430-gcc")
endif

# Read configuration file
ifdef CONFIG
 CONFIGSUFFIX = $(CONFIG:config%=%)
else
 CONFIG = config
 CONFIGSUFFIX =
endif

# Enable verbose compilation with "make V=1"
ifdef V
 Q :=
 E := @:
else
 Q := @
 E := @echo
endif

# Include the configuration file
include $(CONFIG)

# Set MCU name and length of binary for bootloader
# WARNING: Fuse settings not tested!
MCU := cc430f6137
# CPU is one of 430/430x
# WSim currently needs 430
ifeq ($(TI_COMPILER),1)
	CPU := 430X
else
	CPU := 430
endif

# Directory for all generated files
OBJDIR := build

# Directory for dependency files
DEPDIR := .dep

# Output format. (can be srec, ihex, binary)
FORMAT = ihex


# Target file name (without extension).
TARGET = $(OBJDIR)/aochronos

# List C source files here. (C dependencies are automatically generated.)
#SRC = $(shell find . -name "*.c" -not -name ".*"|cut -b 3-)
SRC = $(shell find -L . \( -name "*.c" -o -name "*.cc" \) -not -name ".*"|cut -b 3-)


# List Assembler source files here.
#     Make them always end in a capital .S.  Files ending in a lowercase .s
#     will not be considered source files but generated files (assembler
#     output from the compiler), and will be deleted upon "make clean"!
#     Even though the DOS/Win* filesystem matches both .s and .S the same,
#     it will preserve the spelling of the filenames, and gcc itself does
#     care about how the name is spelled on its command-line.
ASRC = $(shell find -L . -name "*.S" -not -name ".*"|cut -b 3-)


# List Aspect source files here.
ASPECTSRC = $(shell find -L . -name "*.ah" -not -name ".*"|cut -b 3-)


# Optimization level, can be [0, 1, 2, 3, s].
#     0 = turn off optimization. s = optimize for size.
#     (Note: 3 is not always the best optimization level. See avr-libc FAQ.)
# Use s -mcall-prologues when you really need size...
#OPT = 2
OPT = s

# List any extra directories to look for include files here.
#     Each directory must be seperated by a space.
#     Use forward slashes for directory separators.
#     For a directory that has spaces, enclose it in quotes.
EXTRAINCDIRS =


# Compiler flag to set the C Standard level.
#     c89   = "ANSI" C
#     gnu89 = c89 plus GCC extensions
#     c99   = ISO C99 standard (not yet fully implemented)
#     gnu99 = c99 plus GCC extensions
CSTANDARD = -std=gnu99


# Place -D or -U options here
CDEFS =


# Place -I options here
CINCS =


# Define programs and commands.
# CC must be defined here to generate the correct CFLAGS
SHELL = sh
ACXX = ag++
REMOVE = rm -f
COPY = cp
WINSHELL = cmd
AWK = awk
SRECORD = srec_cat
ifeq ($(TI_COMPILER),1)
	CC = msp430-elf-gcc
	CXX = msp430-elf-g++
	OBJCOPY = msp430-elf-objcopy
	OBJDUMP = msp430-elf-objdump
	SIZE = msp430-elf-size
	NM = msp430-elf-nm
else
	CC = msp430-gcc
	CXX = msp430-g++
	OBJCOPY = msp430-objcopy
	OBJDUMP = msp430-objdump
	SIZE = msp430-size
	NM = msp430-nm
endif

#---------------- Compiler Options ----------------
#  -g*:          generate debugging information
#  -O*:          optimization level
#  -f...:        tuning, see GCC manual and avr-libc documentation
#  -Wall...:     warning level
#  -Wa,...:      tell GCC to pass this to the assembler.
#    -adhlns...: create assembler listing
DEBUG = gdb1 #FIXME: with debug level >1, the debug symbols won't fit into 16 bit
#                    see: http://sourceforge.net/p/mspgcc/bugs/348/
CFLAGS = -g$(DEBUG)
CFLAGS += $(CDEFS) $(CINCS)
CFLAGS += -O$(OPT)
#CFLAGS += -funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums
CFLAGS += -Wall -Wextra -Werror -Wno-write-strings -Wno-unused-parameter -Wstrict-prototypes -Wno-missing-field-initializers
#CFLAGS += -Wa,-adhlns=$(OBJDIR)/$(<:.c=.lst)
CFLAGS += -I$(OBJDIR)
CFLAGS += $(patsubst %,-I%,$(EXTRAINCDIRS))
CFLAGS += $(CSTANDARD)
CFLAGS += -ffunction-sections
CFLAGS += -fdata-sections
CFLAGS += -D MAKEFILE_COMPILE
ifeq ($(TI_COMPILER),1)
	CFLAGS += -mhwmult=none
	CFLAGS += -D TI_COMPILER
else
	CFLAGS += -mmpy=none
endif
# Turn off 20Bit memory model for gcc4.7+
# http://sourceforge.net/apps/mediawiki/mspgcc/index.php?title=Gcc47:20-Bit_Design#Compiler_Target_Options
#CFLAGS += -mmemory-model=none

CXXFLAGS = -g$(DEBUG)
CXXFLAGS += $(CDEFS) $(CINCS)
CXXFLAGS += -O$(OPT)
CXXFLAGS += -Wall -Wextra -Werror -Wno-write-strings -Wno-unused-parameter -Wno-unused-variable
CXXFLAGS += -fno-rtti -fno-exceptions
CXXFLAGS += -I$(OBJDIR)
CXXFLAGS += $(patsubst %,-I%,$(EXTRAINCDIRS))
CXXFLAGS += -ffunction-sections
#CXXFLAGS += -fdata-sections
CXXFLAGS += -fmove-loop-invariants
CXXFLAGS += -fno-threadsafe-statics
CXXFLAGS += -D MAKEFILE_COMPILE
ifeq ($(TI_COMPILER),1)
	CXXFLAGS += -mhwmult=none
	CXXFLAGS += -D TI_COMPILER
else
	CXXFLAGS += -mmpy=none
endif
# Turn off 20Bit memory model for gcc4.7+
# http://sourceforge.net/apps/mediawiki/mspgcc/index.php?title=Gcc47:20-Bit_Design#Compiler_Target_Options
#CXXFLAGS += -mmemory-model=none

ACXXFLAGS := --c_compiler $(CXX) -r repo.acp

# add --target for recent aspectc++ versions
ACXXCLANG := $(shell expr `PATH=$(PATH) $(ACXX) --version | rev | cut -d' ' -f1 | rev` \>= 2016)
ifeq "$(ACXXCLANG)" "1"
    ACXXFLAGS += --target msp430-elf
endif

#---------------- Assembler Options ----------------
#  -Wa,...:   tell GCC to pass this to the assembler.
#  -ahlms:    create listing
#  -gstabs:   have the assembler create line number information
ASFLAGS = -Wa,-adhlns=$(OBJDIR)/$(<:.S=.lst),-gstabs -I$(OBJDIR)


#---------------- Linker Options ----------------
#  -Wl,...:     tell GCC to pass this to linker.
#    -Map:      create map file
#    --cref:    add cross reference to  map file
LDFLAGS = -Wl,-Map=$(TARGET).map,--cref
LDFLAGS += -Wl,--gc-sections
# Turn off 20Bit memory model for gcc4.7+
#LDFLAGS += -mmemory-model=none


#============================================================================


# De-dupe the list of C source files
CSRC := $(sort $(filter %.c,$(SRC)))
CXXSRC := $(sort $(filter %.cc,$(SRC)))

# Define all object files.
OBJ := $(patsubst %,$(OBJDIR)/%,$(CXXSRC:.cc=.o) $(ASRC:.S=.o) $(CSRC:.c=.o) )

# Define all listing files.
LST := $(patsubst %,$(OBJDIR)/%,$(CSRC:.c=.lst) $(ASRC:.S=.lst))

# Define C++ dependency files
CXXDEP := $(patsubst %,$(DEPDIR)/%,$(CXXSRC:.cc=.d))

# Define the object directories
OBJDIRS := $(sort $(dir $(OBJ)))

# Compiler flags to generate dependency files.
GENDEPFLAGS = -MMD -MP -MF $(DEPDIR)/$(@F).d


# Combine all necessary flags and optional flags.
# Add target processor to flags.
ALL_CFLAGS   = -mcpu=$(CPU) -mmcu=$(MCU) -I. $(CFLAGS)   $(GENDEPFLAGS)
ALL_CXXFLAGS = -mcpu=$(CPU) -mmcu=$(MCU) -I. $(CXXFLAGS)
ALL_ASFLAGS  = -mcpu=$(CPU) -mmcu=$(MCU) -I. -x assembler-with-cpp $(ASFLAGS) $(CDEFS)

# Change compiler and messages for C++ files
ifeq ($(CONFIG_ASPECTS),y)
  CPPCOMP := $(ACXX) $(ACXXFLAGS) --Xcompiler
  CPPMSG  := "  ACXX  "
else
  CPPCOMP := $(CXX)
  CPPMSG  := "  CPP   "
endif


# Default target.
all: buildit

buildit: elf txt #bin hex
	$(E) "  SIZE   $(TARGET).elf"
	$(Q)$(ELFSIZE)|egrep -v "(debug|rodata)"

elf: $(TARGET).elf
bin: $(TARGET).bin
hex: $(TARGET).hex
lss: $(TARGET).lss
sym: $(TARGET).sym
txt: $(TARGET).txt

# Display size of file.
HEXSIZE = $(SIZE) --target=$(FORMAT) $(TARGET).hex
ELFSIZE = $(SIZE) -A $(TARGET).elf


# Generate config.h from config
.PRECIOUS : $(OBJDIR)/config.h
$(OBJDIR)/config.h: $(CONFIG) | $(OBJDIRS)
	$(E) "  CONF2H $(CONFIG)"
	$(Q)$(AWK) -f scripts/conf2h.awk $(CONFIG) > $(OBJDIR)/config.h

# Create final output files (.hex, .eep) from ELF output file.
$(OBJDIR)/%.bin: $(OBJDIR)/%.elf
	$(E) "  BIN    $@"
	$(Q)$(OBJCOPY) -O binary $< $@

$(OBJDIR)/%.hex: $(OBJDIR)/%.elf
	$(E) "  HEX    $@"
	$(Q)$(OBJCOPY) -O $(FORMAT) $< $@

# Create Texas Instruments .txt file.
# Expand to 12KiB, because rfbsl (bootloader) doesn't like too small files :-(
# Fill with 1's, since this is flash's default state after erasing.
$(OBJDIR)/%.txt: $(OBJDIR)/%.hex
	$(E) "  TXT    $@"
	$(Q)$(SRECORD) $< -Intel -fill 0xFF 0x8000 0xB000 -Output $@ -Texas_Instrument_TeXT

# Create extended listing file from ELF output file.
$(OBJDIR)/%.lss: $(OBJDIR)/%.elf
	$(E) "  LSS    $<"
	$(Q)$(OBJDUMP) -h -S $< > $@

# Create a symbol table from ELF output file.
$(OBJDIR)/%.sym: $(OBJDIR)/%.elf
	$(E) "  SYM    $<"
	$(E)$(NM) -n $< > $@

# Link: create ELF output file from object files.
.SECONDARY : $(TARGET).elf
.PRECIOUS : $(OBJ)
$(OBJDIR)/%.elf: $(OBJ)
	$(E) "  LINK   $@"
	$(Q)$(CC) $(ALL_CFLAGS) $^ --output $@ $(LDFLAGS)

# Compile: create object files from C source files.
$(OBJDIR)/%.o : %.c | $(OBJDIR) $(OBJDIR)/config.h
	$(E) "  CC     $<"
	$(Q)$(CC) -c $(ALL_CFLAGS) $< -o $@

# Compile: create object files from C++ source files
$(OBJDIR)/%.o : %.cc | $(OBJDIR) $(OBJDIR)/config.h
	$(E) $(CPPMSG) "$<"
	$(Q)$(CPPCOMP) -c $(ALL_CXXFLAGS) $< -o $@

# Compile: create assembler files from C source files.
$(OBJDIR)/%.s : %.c | $(OBJDIR) $(OBJDIR)/config.h
	$(CC) -S $(ALL_CFLAGS) $< -o $@

# Create dependencies (and add all aspects as dependencies)
# The use of CPPCOMP instead of CXX below is affected by AspectC++ Bug #409
$(DEPDIR)/%.d: %.cc $(OBJDIR)/config.h
	$(E) "  DEP    $<"
	@if test \( ! \( -d $(@D) \) \) ;then mkdir -p $(@D);fi
	$(Q)$(CXX) $(ALL_CXXFLAGS) -MM $(patsubst %.ah,-include %.ah,$(ASPECTSRC)) -MT $(OBJDIR)/$*.o -MF $@ $<

# Assemble: create object files from assembler source files.
$(OBJDIR)/%.o : %.S | $(OBJDIR) $(OBJDIR)/config.h
	$(E) "  AS     $<"
	$(Q)$(CC) -c $(ALL_ASFLAGS) $< -o $@

# Create preprocessed source for use in sending a bug report.
$(OBJDIR)/%.i : %.c | $(OBJDIR) $(OBJDIR)/config.h
	$(CC) -E -mmcu=$(MCU) -I. $(CFLAGS) $< -o $@

# Create the output directory
$(OBJDIRS):
	$(E) "  MKDIR  $(OBJDIR)"
	-$(Q)mkdir -p $(OBJDIRS)

# Target: clean project.
clean: begin clean_list end

clean_list :
	$(E) "  CLEAN"
	$(Q)$(REMOVE) $(TARGET).txt
	$(Q)$(REMOVE) $(TARGET).hex
	$(Q)$(REMOVE) $(TARGET).bin
	$(Q)$(REMOVE) $(TARGET).elf
	$(Q)$(REMOVE) $(TARGET).map
	$(Q)$(REMOVE) $(TARGET).sym
	$(Q)$(REMOVE) $(TARGET).lss
	$(Q)$(REMOVE) $(OBJ)
	$(Q)$(REMOVE) $(OBJDIR)/config.h
	$(Q)$(REMOVE) $(OBJDIR)/*.bin
	$(Q)$(REMOVE) $(LST)
	$(Q)$(REMOVE) $(CSRC:.c=.s)
	$(Q)$(REMOVE) $(CSRC:.c=.d)
	$(Q)$(REMOVE) -rf $(DEPDIR)
	$(Q)$(REMOVE) -rf codedoc
	$(Q)$(REMOVE) repo.acp
	-$(Q)rmdir --ignore-fail-on-non-empty -p $(OBJDIRS)

# Target to invoke the RF-based flash tool
flash: buildit
	./scripts/rfuploader/uploader.sh $(realpath $(TARGET).txt)

# Targets for the WSIM simulator
wsim: buildit
	wsim $(TARGET).elf

wsim-debug: buildit
	wsim --mode=gdb $(TARGET).elf

wsim-net: buildit
	wsim --wsnet1 $(TARGET).elf

# Include the dependency files.
-include $(shell mkdir $(DEPDIR) 2>/dev/null) $(wildcard $(DEPDIR)/*.d)

ifneq ($(MAKECMDGOALS),clean)
-include $(CXXDEP)
endif

# Listing of phony targets.
.PHONY : all begin finish end sizebefore sizeafter \
buildit elf hex eep lss sym \
clean clean_list doxygen
