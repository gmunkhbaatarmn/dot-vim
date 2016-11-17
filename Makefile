all:
	@echo "See Makefile"

init:
	mkdir bundle --parents
	git clone git@github.com:VundleVim/Vundle.vim.git bundle/Vundle.vim
	vim +PluginInstall +qall

ci-dependency:
	pip install vim-vint --upgrade
	npm install vimlint --global

ci-test:
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
