# my-vimrc-installer
Repository providing a script for automatically installing all my vimrc settings

**For Vim:**
```bash
curl https://raw.githubusercontent.com/datMaffin/my-vimrc-installer/master/vimrc >> ~/.vimrc
```
**For Neovim:**
```bash
curl https://raw.githubusercontent.com/datMaffin/my-vimrc-installer/master/vimrc >> ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/init.vim
```

*This vimrc sets the gui font to Mononoki.*

Setup after the command:
1. Make sure that a recent vim and nodejs is installed [(both needed for coc.nvim)](https://github.com/neoclide/coc.nvim/wiki/Install-coc.nvim#install-neovim-or-vim) 
2. Open `vim`
3. Execute `:PlugInstall` in vim
4. Restart vim
5. Configure coc.vim [extensions](https://github.com/neoclide/coc.nvim#extensions) and [language server](https://github.com/neoclide/coc.nvim/wiki/Language-servers)
