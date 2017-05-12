WARNINGS := -Wall -Wextra -pedantic -Wshadow -Wpointer-arith -Wcast-align	\
			-Wwrite-strings -Wmissing-prototypes -Wmissing-declarations		\
			-Wredundant-decls -Wnested-externs -Winline -Wno-long-long		\
			-Wuninitialized -Wconversion -Wstrict-prototypes

CFLAGS ?= -std=gnu99 -g $(WARNINGS) -fpic

OBJDIR := Objects
OUTDIR := Outputs
SRCDIR := Sources
HDRDIR := Headers
RDSDIR := Ressources

NAME := snake_$(shell uname -m)-$(shell uname -s)

ifeq ($(VERBOSE), 1)
    SILENCER := 
else
    SILENCER := @
endif

ifeq ($(DEBUG_BUILD), 1)
    CFLAGS +=-DDEBUG_BUILD
endif

SRCF := main.c

SRCS := $(patsubst %, $(SRCDIR)/%, $(SRCF))
OBJS := $(patsubst %, $(OBJDIR)/%, $(SRCF:c=o))

CFLAGS += -MMD -MP
DEPS := $(patsubst %, $(OBJDIR)/%, $(SRCF:c=d))

all: clearprompt $(NAME)

clearprompt:
	clear

objectdir:
	$(SILENCER)mkdir -p $(OBJDIR)

outputdir:
	$(SILENCER)mkdir -p $(OUTDIR)

$(NAME): $(OBJS) | outputdir
	$(SILENCER)$(CC) $(CFLAGS) -o $(OUTDIR)/$(NAME) $^ -lSDL2_image `sdl2-config --cflags --libs`

$(OBJDIR)/%.o: $(SRCDIR)/%.c | objectdir
	$(SILENCER)$(CC) $(CFLAGS) -c -o $@ $<

clean: clearprompt
	$(SILENCER)find . -name "*.o" -type f -delete
	$(SILENCER)find . -name "*.d" -type f -delete

fclean: clean
	$(SILENCER)$(RM) -rf $(OUTDIR)

re: fclean all

.PHONY: re fclean clean all

-include $(DEPS)
