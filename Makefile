all:
	@echo "See Makefile"

init:
	vim +PluginInstall +qall
	pip install vim-vint --upgrade
	npm -g install vimlint

lint:
	@# vim-vint
	vint init.vim
	vint dvorak.vim
	vint filetypes.vim
	vint colors/*.vim
	vint keymap/*.vim
	@# vimlint
	vimlint *.vim
	vimlint colors/*.vim
	vimlint keymap/*.vim
