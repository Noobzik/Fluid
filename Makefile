#
# Fluid
# Version: 1.5.4
#
# Use of this source code is governed by an MIT-style license that can be
# found in the LICENSE file at LICENSE.md
#

#
# CONFIGURATIONS
#

NAME := project_$(shell uname -m)-$(shell uname -s)

OBJDIR := Objects
OUTDIR := Outputs
SRCDIR := Sources
HDRDIR := Headers
RDSDIR := Ressources

#
# DO NOT EDIT FORWARD
#

# Compilation settings

WARNINGS := -Wall -Wextra -pedantic -Wshadow -Wpointer-arith -Wcast-align \
			-Wwrite-strings -Wmissing-prototypes -Wmissing-declarations \
			-Wredundant-decls -Wnested-externs -Winline -Wno-long-long \
			-Wuninitialized -Wconversion -Wstrict-prototypes

CFLAGS ?= -std=gnu99 -g $(WARNINGS) -fpic

# Options

ifeq ($(VERBOSE), 1)
		SILENCER :=
else
		SILENCER := @
endif

ifeq ($(DEBUG_BUILD), 1)
		CFLAGS +=-DDEBUG_BUILD
endif

# Compilation command

all: init $(NAME)

# Automated compilator

# Compilator

SRCF := $(shell find ./$(SRCDIR) -name "*.c" -type f | cut -sd / -f 3- | tr '\n' ' ')
SRCS := $(patsubst %, $(SRCDIR)/%, $(SRCF))
OBJS := $(patsubst %, $(OBJDIR)/%, $(SRCF:c=o))

# Compilation output configurations

CFLAGS += -MMD -MP
DEPS := $(patsubst %, $(OBJDIR)/%, $(SRCF:c=d))

$(NAME): $(OBJS)
	$(SILENCER)mkdir -p $(OUTDIR)
	$(SILENCER)$(CC) $(CFLAGS) -o $(OUTDIR)/$(NAME) $^

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	$(SILENCER)mkdir -p $(OBJDIR)
	$(SILENCER)$(CC) $(CFLAGS) -c -o $@ $<

# Helpers command

init:
	$(SILENCER)mkdir -p $(OBJDIR)
	$(SILENCER)mkdir -p $(SRCDIR)
	$(SILENCER)mkdir -p $(HDRDIR)
	$(SILENCER)mkdir -p $(RDSDIR)
	$(SILENCER)cd ./Sources && find . -type d -exec mkdir -p ../$(OBJDIR)/{} \;
	$(SILENCER)cd ..

clean:
	clear
	$(SILENCER)find . -name "*.o" -type f -delete
	$(SILENCER)find . -name "*.d" -type f -delete

fclean: clean
	$(SILENCER)$(RM) -rf $(OUTDIR)
	$(SILENCER)$(RM) -rf $(OBJDIR)

re: fclean all

.PHONY: re fclean clean init all

-include $(DEPS)
