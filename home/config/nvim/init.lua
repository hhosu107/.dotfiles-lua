o = vim.opt
fn = vim.fn

--
-- General Configs
--

vim.g.mapleader = ","

vim.cmd([[
    filetype plugin on
    syntax on


    " Mistypings
    command Q :q
    command Qa :qa
]])
o.encoding = 'utf-8'
o.fileencoding = 'utf-8'
o.shell = '/bin/bash'
o.scrolloff = 3
o.startofline = true
o.splitbelow = true
o.splitright = true
o.backup = false
o.swapfile = false

if not vim.fn.has('nvim') then
    o.compatible = false
end

o.showmode = true
o.foldenable = true
o.wrap = true
o.showcmd = true
o.signcolumn = 'yes'
o.colorcolumn = {'79', '99', '119'}

-- History
if vim.fn.has('persistent_undo') then
    o.undodir = vim.fn.stdpath('data') .. '/undodir'
    o.undofile = true
    vim.fn.mkdir(vim.fn.stdpath('data') .. '/undodir', 'p')
end

-- mouse
o.mouse = 'a'

-- Indentation
o.cindent = true
o.autoindent = true
o.smartindent = true

-- Tab
o.softtabstop = 2
o.shiftwidth = 2
o.expandtab = true

-- for files whose filetype is one of make and textproto, do not expand tab.
vim.cmd([[
    autocmd FileType make,textproto setlocal noexpandtab
]])

-- Searching
o.ignorecase = true
o.smartcase = true
o.hlsearch = true
o.wrapscan = false
o.incsearch = true

-- Line Number Column
o.number = true
o.cursorline = true
-- Pair Matching
o.showmatch = true

-- Completion
o.hidden = true
o.completeopt = {'preview', 'menuone', 'noinsert', 'noselect'}
o.shortmess = o.shortmess + 'c'
o.signcolumn = 'yes'

--
-- diagnostic
--

vim.diagnostic.config({
    virtual_text = {
        severity = { min = vim.diagnostic.severity.ERROR },
    },
    underline = {
        severity = { min = vim.diagnostic.severity.ERROR },
    },
    signs = {
        severity = { min = vim.diagnostic.severity.ERROR },
    },
})

-- Configure neovim python host.
-- This can be executed lazily after entering vim, to save startup time.
require('utils.pynvim')
require('utils.fixfnkeys')
require('utils.compat')
-- require('utils.augroup').setup()

require("config.lazy")
-- require("lazy").setup("configs")
--
-- configs
require ('config/plugins')
require ('config/treesitter')
require ('config/ufo')
require ('config/lsp')
require ('config/keymaps').setup()
-- require ('config/avante')
