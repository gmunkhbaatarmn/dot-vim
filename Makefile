all:
	@echo "See Makefile"
init:
	vim +PluginInstall +qall
	pip install vim-vint
	npm -g install vimlint
lint:
	@# vim-vint
	vint app.vimrc
	vint dvorak.vimrc
	vint filetype.vimrc
	vint colors/*.vim
	vint keymap/*.vim
	@# vimlint
	vimlint *.vimrc
	vimlint colors/*.vim
	vimlint keymap/*.vim
