#
# Fluid
# Version: 1.5.7
#
# Use of this source code is governed by an MIT-style license that can be
# found in the LICENSE file at LICENSE.md
#

#
# CONFIGURATIONS
#

OUTNAME := a.output

ROTDIR := ./
DEPDIR := .cache
OBJDIR := .cache
OUTDIR := .
SRCDIR := .
HDRDIR := .

#
# DO NOT EDIT FORWARD
#

# Compilation settings

CC := g++

WARNINGS := -Wall -Wextra -pedantic -Wshadow -Wpointer-arith -Wcast-align \
			-Wwrite-strings -Wmissing-declarations -Wredundant-decls \
			-Winline -Wno-long-long -Wuninitialized -Wconversion -Wfatal-errors

CFLAGS ?= -std=c++14 $(WARNINGS)

# Options

ifeq ($(VERBOSE), 1)
    SILENCER :=
else
    SILENCER := @
endif

ifeq ($(DEBUG_BUILD), 1)
    CFLAGS +=-DDEBUG_BUILD -fsanitize=address -g
endif

# Compilation command

all: init $(OUTNAME)

# Automated compilator

# Compilator files

ifeq ($(TEST_BUILD), 1)
    SRCS := $(shell find $(ROTDIR)$(SRCDIR) -name "*.cpp" -type f | cut -sd / -f 3- | tr '\n' ' ')
else
    SRCS := $(shell find $(ROTDIR)$(SRCDIR) ! -name '*.test.cpp' -name "*.cpp" -type f | cut -sd / -f 3- | tr '\n' ' ')
endif
OBJS := $(patsubst %, $(OBJDIR)/%, $(SRCS:cpp=o))
DEPS :=$(patsubst %.cpp, %.d, $(SRCS))

# Compilation output configurations

CFLAGS += -MT $@ -MMD -MP -MF $(DEPDIR)/$*.Td
POSTCOMPILE = @mv -f $(DEPDIR)/$*.Td $(DEPDIR)/$*.d && touch $@

$(OUTNAME): $(OBJS)
	$(SILENCER)mkdir -p $(OUTDIR)
	$(SILENCER)$(CC) $(CFLAGS) -o $(OUTDIR)/$(OUTNAME) $^

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp $(DEPDIR)/%.d
	$(SILENCER)mkdir -p $(OBJDIR)
	$(SILENCER)$(CC) $(CFLAGS) -c -o $@ $<
	$(POSTCOMPILE)

# Helpers command

init:
	$(SILENCER)mkdir -p $(SRCDIR)
	$(SILENCER)mkdir -p $(OBJDIR)
	$(SILENCER)mkdir -p $(HDRDIR)

clean:
	$(SILENCER)find . -name "*.o" -type f -delete

fclean: clean
	$(SILENCER)$(RM) -r $(ROTDIR)$(OBJDIR)
	$(SILENCER)$(RM) -r $(ROTDIR)$(OUTDIR)/$(OUTNAME)

re: fclean all

.PHONY: re fclean clean init all

$(DEPDIR)/%.d: ;
.PRECIOUS: $(DEPDIR)/%.d

include $(wildcard $(patsubst %,$(DEPDIR)/%.d,$(basename $(SRCS))))
