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
1. Open `vim` and/or `nvim` (shell needs to be posix)
