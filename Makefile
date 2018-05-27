
ifeq ($(which emacs), 0)
install: mtc-mode.el
	ln -s mtc-mode.el ~/.emacs.d/
else
install:
	@echo "Emacs is not installed !"
endif
