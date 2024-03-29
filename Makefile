all:
	@echo "See Makefile"

status:
	@./.scripts/check_status.sh

ci-init:
	pip install vim-vint

ci-test:
	@# vim-vint
	vint --style-problem filetypes.vim
	vint --style-problem init.vim
	vint --style-problem mappings.vim
	vint --style-problem plugins.vim
	vint --style-problem keymap/*.vim
	vint --style-problem nerdtree_plugin/*.vim
	vint --style-problem shame.vim
