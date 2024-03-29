# Make file that organizes my dotfiles
# Inspired by <https://www.matheusmoreira.com/articles/managing-dotfiles-with-make>
# See his repository also: <https://github.com/matheusmoreira/.files>

makefile := $(abspath $(lastword $(MAKEFILE_LIST)))
dotfiles := $(abspath $(dir $(makefile)))
~ := $(abspath $(dotfiles)/~)

define rule.template
$(1)/% : $(2)/% force
	mkdir -p $$(@D)
	ln -snf $$< $$@
endef

rule.define = $(eval $(call rule.template,$(1),$(2)))
$(call rule.define,$(HOME),$(~))

all += nvim
nvim: ~/.config/nvim/init.lua

all += zsh
zsh: ~/.config/zsh/.zshrc ~/.zprofile

all += kitty
kitty: ~/.config/kitty/kitty.conf

all += dunst
dunst: ~/.config/dunst/dunstrc

all += wallpaper
wallpaper: ~/.local/share/wallpaper.png

all += doasedit
doasedit: ~/.local/bin/doasedit

all += menu
menu: ~/.local/bin/menu

all += zathura
zathura: ~/.config/zathura/zathurarc

all += gdb
gdb: ~/.gdbinit

## WAYLAND ##

wayland += sway
sway: ~/.config/sway/config

wayland += waybar
waybar: ~/.config/waybar/config ~/.config/waybar/style.css

## XORG	##

xorg += xscreenshot
xscreenshot: ~/.local/bin/screenshot

all: $(all)
xorg: $(xorg)
wayland: $(wayland)

force:
.PHONY: all $(all)
.DEFAULT_GOAL := all
