-- Options
vim.g.mapleader = " "
vim.opt.autoindent = true
vim.opt.confirm = true
vim.opt.cul = true
vim.opt.complete = 'i'
vim.opt.history = 150
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.mouse = 'a'
vim.opt.mod = true
vim.opt.nu = true
vim.opt.rnu = true
vim.opt.path:append('**')
vim.opt.shiftwidth = 4
vim.opt.shortmess:append('a')
vim.opt.showcmd = true
vim.opt.smartcase = true
vim.opt.smarttab = true
vim.opt.softtabstop = 4
vim.opt.sb = true
vim.opt.spr = true
vim.opt.title = true
vim.opt.wildmenu = true
vim.opt.inccommand = 'split'
vim.opt.clipboard:append('unnamedplus')
vim.opt.expandtab = true
vim.opt.tw = 120
vim.opt.fo:append('a')

----------------------------
-- Autocmds and Functions --
----------------------------

vim.api.nvim_create_augroup("vimrc-incsearch-highlight", { clear = true })
vim.api.nvim_create_autocmd("CmdlineEnter", {
    group = "vimrc-incsearch-highlight",
    pattern = "/,?",
    command = "set hlsearch",
})
vim.api.nvim_create_autocmd("CmdlineLeave", {
    group = "vimrc-incsearch-highlight",
    pattern = "/,?",
    command = "set nohlsearch",
})
vim.api.nvim_create_augroup("vimrc-textfiles", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
    group = "vimrc-textfiles",
    pattern = "README",
    command = "set ft=markdown",
})
vim.api.nvim_create_autocmd("BufEnter", {
    group = "vimrc-textfiles",
    pattern = "*.groff",
    command = "set ft=groff",
})
vim.api.nvim_create_autocmd("BufEnter", {
    group = "vimrc-textfiles",
    pattern = "*.h",
    command = "set ft=c",
})
vim.api.nvim_create_autocmd("BufEnter", {
    group = "vimrc-textfiles",
    pattern = "*.tex",
    command = "set shiftwidth=2",
})

vim.cmd [[
    highlight highlightWhitespace ctermbg=red guibg=red ctermfg=red
]]

------------------
-- Plugin setup --
------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    'wbthomason/packer.nvim',
    'terrortylor/nvim-comment',
    'ap/vim-css-color',
    'terryma/vim-multiple-cursors',
    'neovim/nvim-lspconfig',

    'editorconfig/editorconfig-vim',
    'dubek/vim-mal',
    'APZelos/blamer.nvim',
    'nvim-treesitter/nvim-treesitter',
    'lervag/vimtex',

    {'nvim-lualine/lualine.nvim', dependencies = 'kyazdani42/nvim-web-devicons'},

    {'DanisDGK/srcery.nvim', name = 'srcery'},
})

vim.cmd [[
    syntax enable
    colorscheme srcery
    filetype plugin indent on
]]

require('lspconfig').cmake.setup{}
require('lspconfig').clangd.setup {
    settings = {
        filetypes = 'cpp'
    }
}
vim.api.nvim_create_autocmd("BufWritePre", {
    group = "vimrc-textfiles",
    pattern = "*.cxx",
    command = "lua vim.lsp.buf.format()",
})
vim.api.nvim_create_autocmd("BufWritePre", {
    group = "vimrc-textfiles",
    pattern = "*.hxx",
    command = "lua vim.lsp.buf.format()",
})

require('lualine').setup {
  options = { icons_enabled = true, theme = 'srcery',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = { statusline = {}, winbar = {}, },
    ignore_focus = {}, always_divide_middle = true, globalstatus = false,
    refresh = { statusline = 1000, tabline = 1000, winbar = 1000, }
  }, 

  sections = {
    lualine_a = {'mode'}, lualine_b = {'branch', 'diff'}, lualine_c = { 'filename', 'diagnostics' },
    lualine_x = {'encoding', 'fileformat', 'filetype'}, lualine_y = {'progress'}, lualine_z = {'location'}
  }, inactive_sections = { lualine_a = {}, lualine_b = {}, lualine_c = {'filename'},
    lualine_x = {'location'}, lualine_y = {}, lualine_z = {}
  }, tabline = {}, winbar = {}, inactive_winbar = {}, extensions = {}
}

require('nvim_comment').setup({ comment_empty = false, })

require('nvim-treesitter.configs').setup({
    highlight = { enable = true, additional_vim_regex_highlighting = false, },
})

vim.g.srcery_italic = 1
vim.g.blamer_show_in_insert_mods = 0
vim.g.blamer_delay = 0
vim.g.blamer_prefix = ' > '
vim.g.vimtex_view_method = 'zathura'

-----------------------------------
-- Keybinds and keybind function --
-----------------------------------

local function noremap(mode, original_key, command)
    local option = { noremap = true }
    vim.keymap.set(mode, original_key, command, option)
end

-- Tab keybinds
noremap('n', "<Leader>e", ":tabnew ")
noremap('n', "<Leader>v", ":vertical :new ")
noremap('n', "<Leader>.", ":tabnext<CR>")
noremap('n', "<Leader>,", ":tabprevious<CR>")

-- Terminal keybinds
noremap('n', "<Leader>tw", ":split term://make -k<CR>")
noremap('n', "<Leader>tt", ":split term://zsh<CR>i")
noremap('n', "<Leader>m", ":vertical :Man ")

-- Plugin keybinds
noremap('n', "<Leader>fb", ":BlamerToggle<CR>")
noremap('n', "<Leader>ws", [[
    :match highlightWhitespace /\s\+$/<CR>]])
noremap('n', "<Leader>wt", [[
    :%s/\s\+$//g<CR>]])
noremap('n', "<Leader>ll", [[
    :VimtexCompile<CR>]])
noremap('n', "<Leader>lt", [[
    :VimtexTocOpen<CR>]])

-- Faster command forking
noremap('n', "!", ":!")

-- Exit mode with EOF
noremap({'n', 'v', 'i'}, "<C-d>", "<Esc>")

-- Emacs/shell keybinds
noremap({'n', 'i'}, "<C-e>", "$")
noremap({'n', 'i'}, "<C-a>", "0")

-- Better scrolling through large texts
noremap('n', "j", "gj")
noremap('n', "k", "gk")

-- Swap ; with :
noremap({'n', 'v'}, ";", ":")
noremap({'n', 'v'}, ":", ";")

-- Disable history lookup
noremap('n', "q:", "<nop>")
noremap('c', "<c-f>", "<nop>")

-- Jump paragraphs with J and K
noremap({'n', 'v'}, "<S-k>", "{")
noremap({'n', 'v'}, "<S-j>", "}")

-- Convenient insert mode maps
noremap('i', "<C-o>", "<Esc>o")
noremap('i', "<C-y>", "<Esc>yyp")

-- Navigate windows with Alt
noremap({'t', 'i'}, "<A-h>", "<C-\\><C-N><C-w>h")
noremap({'t', 'i'}, "<A-j>", "<C-\\><C-N><C-w>j")
noremap({'t', 'i'}, "<A-k>", "<C-\\><C-N><C-w>k")
noremap({'t', 'i'}, "<A-l>", "<C-\\><C-N><C-w>l")
noremap('n', "<A-h>", "<C-w>h")
noremap('n', "<A-j>", "<C-w>j")
noremap('n', "<A-k>", "<C-w>k")
noremap('n', "<A-l>", "<C-w>l")

noremap('n', "<A-1>", "gt1<CR>")
noremap('n', "<A-2>", "gt2<CR>")
noremap('n', "<A-3>", "gt3<CR>")
noremap('n', "<A-4>", "gt4<CR>")
noremap('n', "<A-5>", "gt5<CR>")

-- Fix Ctrl-H backspace thing
noremap({'x', 't', 'i', 'n', 'v'} , "", "<BS>")
