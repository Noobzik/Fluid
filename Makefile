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

OUTNAME := project_$(shell uname -m)-$(shell uname -s)

OBJDIR := Objects
OUTDIR := Outputs
SRCDIR := Sources
HDRDIR := Headers

#
# DO NOT EDIT FORWARD
#

# Compilation settings

CC := g++

WARNINGS := -Wall -Wextra -pedantic -Wshadow -Wpointer-arith -Wcast-align \
			-Wwrite-strings -Wmissing-declarations -Wredundant-decls \
			-Winline -Wno-long-long -Wuninitialized -Wconversion

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
    SRCS := $(shell find ./$(SRCDIR) -name "*.cpp" -type f | cut -sd / -f 3- | tr '\n' ' ')
else
    SRCS := $(shell find ./$(SRCDIR) ! -name '*.test.cpp' -name "*.cpp" -type f | cut -sd / -f 3- | tr '\n' ' ')
endif
OBJS := $(patsubst %, $(OBJDIR)/%, $(SRCS:cpp=o))

# Compilation output configurations

CFLAGS += -MMD -MP

$(OUTNAME): $(OBJS)
	$(SILENCER)mkdir -p $(OUTDIR)
	$(SILENCER)$(CC) $(CFLAGS) -o $(OUTDIR)/$(OUTNAME) $^

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp
	$(SILENCER)mkdir -p $(OBJDIR)
	$(SILENCER)$(CC) $(CFLAGS) -c -o $@ $<

# Helpers command

init:
	$(SILENCER)mkdir -p $(SRCDIR)
	$(SILENCER)mkdir -p $(OBJDIR)
	$(SILENCER)mkdir -p $(HDRDIR)

clean:
	$(SILENCER)find . -name "*.o" -type f -delete

fclean: clean
	$(SILENCER)$(RM) -r ./$(OBJDIR)
	$(SILENCER)$(RM) -r ./$(OUTDIR)/$(OUTNAME)

eject: fclean
	$(SILENCER)$(RM) ./Makefile

re: fclean all

.PHONY: re fclean clean init all
