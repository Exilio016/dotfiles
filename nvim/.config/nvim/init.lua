local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "

local opts = {}
local plugins = {
    require('plugins/yazi'),
    { 'neovim/nvim-lspconfig' },
    {
        "mason-org/mason-lspconfig.nvim", opts = {},
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    },
    {
        'saghen/blink.cmp', branch = 'v1',
        opts = {
            keymap = { preset = 'super-tab' },
            sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
            signature = { enabled = true },

        },
    },
    {
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
            "TmuxNavigatorProcessList",
        },
        keys = {
          { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
          { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
          { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
          { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
        },
    },
    {
      'uZer/pywal16.nvim',
      -- for local dev replace with:
      -- dir = '~/your/path/pywal16.nvim',
      config = function()
        vim.cmd.colorscheme("pywal16")
      end,
    },
    {
        'nvim-telescope/telescope.nvim', version = '*',
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- optional but recommended
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        }
    },
    {
      'nvim-treesitter/nvim-treesitter',
      lazy = false,
      build = ':TSUpdate',
    },
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
      keys = {
        {
          "<leader>?",
          function()
            require("which-key").show({ global = false })
          end,
          desc = "Buffer Local Keymaps (which-key)",
        },
      },
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    {
      "idelice/nvim-jls",
      opts = {},
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "theHamsta/nvim-dap-virtual-text",
        },
    },
}
require("lazy").setup(plugins, opts)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local bufnr = args.buf
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end
    map('gd', vim.lsp.buf.definition, 'Goto Definition')
    map('K', vim.lsp.buf.hover, 'Hover Documentation')
    map('<leader>cf', vim.lsp.buf.format, 'Code Format')
    map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
    map('<leader>cd', vim.diagnostic.open_float, 'Code Diagnostic')
    map('<leader>rn', vim.lsp.buf.rename, 'Rename')
  end,
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

require('nvim-treesitter').install { 'all' }
vim.api.nvim_create_autocmd('FileType', {
    pattern = { '*' },
    callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if lang and vim.treesitter.language.add(lang) then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	        vim.treesitter.start()
        end
    end,
})

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.g.have_nerd_font = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.opt.cursorline = true
vim.opt.inccommand = "split"
vim.opt.winborder = "rounded"
vim.opt.cmdheight = 0

local wal_cache = os.getenv("HOME") .. "/.cache/wal/colors-wal.vim"
local handle = vim.loop.new_fs_event()
handle:start(wal_cache, {}, vim.schedule_wrap(function(err, filename, events)
    if err then return end
    vim.cmd('source ' .. wal_cache)
    vim.cmd.colorscheme("pywal16")
end))


local function macro_recording()
  local reg = vim.fn.reg_recording()
  if reg == "" then
    return ""
  end
  return "⏺ Recording @" .. reg
end

require('lualine').setup {
  options = {
    theme = 'pywal',
    component_separators = '',
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
    lualine_b = { 'filename', 'branch', 'searchcount', 'selectioncount' },
    lualine_c = {
      '%=', --[[ add your center components here in place of this comment ]]
    },
    lualine_x = { { macro_recording, color = {fg = "#ff9e64", gui = "bold"}} },
    lualine_y = { 'filetype', 'lsp_status', 'progress' },
    lualine_z = {
      { 'location', separator = { right = '' }, left_padding = 2 },
    },
  },
  inactive_sections = {
    lualine_a = { 'filename' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'location' },
  },
  tabline = {},
  extensions = {'mason'},
}

vim.lsp.config['ledger-lsp'] = {
    cmd = { 'ledger-lsp' },
    filetypes = { 'ledger', 'hledger', 'journal' },
}
vim.lsp.enable('ledger-lsp')

local dap = require('dap')
local ui = require('dapui')
ui.setup()
require('nvim-dap-virtual-text').setup()

dap.adapters.gdb = {
  type = "executable",
  command = "rust-gdb",
  args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
}
dap.configurations.c = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    args = function ()
        return vim.fn.input('Arguments: ')
    end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
  {
    name = "Select and attach to process",
    type = "gdb",
    request = "attach",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    pid = function()
      local name = vim.fn.input('Executable name (filter): ')
      return require("dap.utils").pick_process({ filter = name })
    end,
    cwd = '${workspaceFolder}'
  },
  {
    name = 'Attach to gdbserver :1234',
    type = 'gdb',
    request = 'attach',
    target = 'localhost:1234',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}'
  }
}
dap.configurations.cpp = dap.configurations.c
dap.configurations.rust = {
  {
    name = "Launch (Rust)",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
    end,
    args = function ()
        return vim.fn.input('Arguments: ')
    end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
    customInitCommands = function()
      -- Dynamically find your active rustup toolchain's python script folder
      -- This works on Linux/macOS paths automatically
      local toolchain_lib = vim.fn.expand('~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/etc')
      
      return {
        'python import sys',
        'python sys.path.insert(0, "' .. toolchain_lib .. '")',
        'python import gdb_providers',
      }
    end,
  }
}

vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Toggle Breakpoint' })
vim.keymap.set('n', '<leader>gb', dap.run_to_cursor, { desc = '[Debug] Run to cursor' })
vim.keymap.set('n', '<leader>?', function ()
    ui.eval(nil, {enter = true})
end, { desc = '[Debug] Eval line' })
vim.keymap.set('n', '<F1>', dap.continue, { desc = '[Debug] Continue' })
vim.keymap.set('n', '<F2>', dap.step_into, { desc = '[Debug] Step into' })
vim.keymap.set('n', '<F3>', dap.step_over, { desc = '[Debug] Step over' })
vim.keymap.set('n', '<F4>', dap.step_out, { desc = '[Debug] Step out' })
vim.keymap.set('n', '<F5>', dap.step_back, { desc = '[Debug] Step back' })
vim.keymap.set('n', '<F13>', dap.restart, { desc = '[Debug] Restart' })

dap.listeners.before.attach.dapui_config = function ()
    ui.open()
end

dap.listeners.before.launch.dapui_config = function ()
    ui.open()
end

dap.listeners.before.event_terminated.dapui_config = function ()
    ui.close()
end

dap.listeners.before.event_exited.dapui_config = function ()
    ui.close()
end
