# ---- project ----
TARGET_NAME := program
SRCDIR      := src
INCDIR      := include
BUILDDIR    := build
BINDIR      := $(BUILDDIR)/bin
OBJDIR      := $(BUILDDIR)/obj
TARGET      := $(BINDIR)/$(TARGET_NAME)

# ---- toolchain ----
AS          := nasm
ASFLAGS     := -f elf64 -I$(INCDIR)/
LD          := clang
LDFLAGS     := -nostdlib
LDLIBS      :=

# ---- sources & objects ----
SRCS        := $(wildcard $(SRCDIR)/*.asm)
OBJS        := $(SRCS:$(SRCDIR)/%.asm=$(OBJDIR)/%.o)
DEPS        := $(OBJS:.o=.d)

.PHONY: all debug run clean print-target

all: $(TARGET)

debug: ASFLAGS += -g -F dwarf
debug: clean $(TARGET)

$(TARGET): $(OBJS)
	@mkdir -p $(BINDIR)
	$(LD) $(LDFLAGS) $^ $(LDLIBS) -o $@

$(OBJDIR)/%.o: $(SRCDIR)/%.asm
	@mkdir -p $(dir $@)
	$(AS) $(ASFLAGS) -MD $(OBJDIR)/$*.d $< -o $@

-include $(DEPS)

run: $(TARGET)
	./$(TARGET)

print-target:
	@echo $(TARGET)

clean:
	$(RM) -r $(BUILDDIR)
