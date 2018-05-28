path_to_emacs := $(shell which emacs)

ifeq (${.SHELLSTATUS} , 0)
install: mtc-mode.el
	cd ~/.emacs.d && ln -s $(realpath $<) .
else
install:
	@echo "Emacs is not installed !"
endif
