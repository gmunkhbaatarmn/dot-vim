all:
	@echo "See Makefile"

init:
	mkdir bundle --parents
	git clone git@github.com:VundleVim/Vundle.vim.git bundle/Vundle.vim
	vim +PluginInstall +qall

ci-dependency:
	pip install vim-vint --upgrade

ci-test:
	@# vim-vint
	vint init.vim
	vint dvorak.vim
	vint filetypes.vim
	vint colors/*.vim
	vint keymap/*.vim
