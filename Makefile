all:
	@echo "See Makefile"
init:
	vim +PluginInstall +qall
	pip install vim-vint
lint:
	@# pip install vim-vint
	vint app.vimrc
	vint dvorak.vimrc
	vint filetype.vimrc
	vint colors/*.vim
	vint keymap/*.vim
