all:
	@echo "See Makefile"

init:
	mkdir bundle --parents
	git clone git@github.com:VundleVim/Vundle.vim.git bundle/Vundle.vim
	vim +PluginInstall +qall

ci-init:
	pip install pathlib typing enum34  # fix for https://travis-ci.org/gmunkhbaatarmn/dot-vim/builds/413444720
	pip install vim-vint

ci-test:
	@# vim-vint
	vint --style-problem init.vim
	vint --style-problem dvorak.vim
	vint --style-problem filetypes.vim
	vint --style-problem colors/*.vim
	vint --style-problem keymap/*.vim
