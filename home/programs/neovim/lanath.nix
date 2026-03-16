{ config, pkgs, pkgs-unstable, ... }:
{
  programs.neovim = {
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      # LSP servers
      gopls
      typescript-language-server
      pyright
      nil
      terraform-ls
      nodePackages.bash-language-server
      # Formatters / linters
      nodePackages.prettier
      black
      nixpkgs-fmt
      shfmt
      shellcheck
      # Go tools (used by gopls / conform)
      go
    ];

    plugins = with pkgs.vimPlugins; [
      # UI
      nvim-web-devicons
      lualine-nvim
      bufferline-nvim
      nvim-tree-lua
      which-key-nvim
      indent-blankline-nvim

      # LSP
      nvim-lspconfig

      # Completion
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp_luasnip
      luasnip
      friendly-snippets

      # Treesitter (all grammars managed by nix)
      nvim-treesitter.withAllGrammars

      # Fuzzy finder (Ctrl+P like)
      telescope-nvim
      plenary-nvim

      # Git (GitLens-like)
      gitsigns-nvim

      # Format on save
      conform-nvim

      # Copilot
      copilot-lua
      copilot-cmp

      # Quality of life
      nvim-autopairs
      comment-nvim
    ];

    extraLuaConfig = /* lua */ ''
      -- ============================================================
      -- General settings
      -- ============================================================
      vim.opt.number         = true
      vim.opt.relativenumber = true
      vim.opt.tabstop        = 4
      vim.opt.shiftwidth     = 4
      vim.opt.expandtab      = false   -- use real tabs (matches VSCode useTabs=true)
      vim.opt.smartindent    = true
      vim.opt.wrap           = false
      vim.opt.swapfile       = false
      vim.opt.undofile       = true
      vim.opt.hlsearch       = false
      vim.opt.incsearch      = true
      vim.opt.termguicolors  = true
      vim.opt.scrolloff      = 8
      vim.opt.signcolumn     = "yes"
      vim.opt.updatetime     = 50
      vim.opt.colorcolumn    = "100"   -- matches prettier printWidth=100
      vim.opt.mouse          = "a"
      vim.opt.clipboard      = "unnamedplus"
      vim.opt.cursorline     = true
      vim.opt.splitbelow     = true
      vim.opt.splitright     = true
      vim.opt.pumheight      = 10
      vim.opt.completeopt    = { "menuone", "noselect" }

      vim.g.mapleader      = " "
      vim.g.maplocalleader = " "

      -- ============================================================
      -- Theme: read from ~/.cache/nvim-colorscheme (written by theme-switch)
      -- Falls back to the build-time default if the file doesn't exist.
      -- ============================================================
      local _cs_file = vim.fn.expand("~/.cache/nvim-colorscheme")
      local _cs_f    = io.open(_cs_file, "r")
      local _cs      = _cs_f and vim.trim(_cs_f:read("*l") or "") or ""
      if _cs_f then _cs_f:close() end
      if _cs == "" then _cs = "${config.theme.neovim.colorscheme}" end
      if _cs == "everforest" then
        vim.g.everforest_background = "hard"
        vim.g.everforest_better_performance = 1
      end
      vim.cmd.colorscheme(_cs)

      local _lualine_map = {
        nord                = "nord",
        ["catppuccin-mocha"]= "catppuccin",
        dracula             = "dracula",
        gruvbox             = "gruvbox",
        ["tokyonight-night"]= "tokyonight",
        everforest          = "everforest",
        ["rose-pine"]       = "rose-pine",
        onedark             = "onedark",
        ["kanagawa-wave"]   = "kanagawa",
      }
      local _lualine_theme = _lualine_map[_cs] or "${config.theme.neovim.lualineTheme}"

      -- ============================================================
      -- Status line
      -- ============================================================
      require("lualine").setup({
        options = {
          theme = _lualine_theme,
          globalstatus = true,
        },
        sections = {
          lualine_c = { { "filename", path = 1 } },
        },
      })

      -- ============================================================
      -- Buffer tabs
      -- ============================================================
      require("bufferline").setup({
        options = {
          mode             = "buffers",
          separator_style  = "slant",
          diagnostics      = "nvim_lsp",
          show_buffer_close_icons = true,
          show_close_icon  = false,
          offsets = {
            {
              filetype   = "NvimTree",
              text       = "Explorer",
              highlight  = "Directory",
              separator  = true,
            },
          },
        },
      })

      -- ============================================================
      -- File explorer (VSCode sidebar)
      -- ============================================================
      require("nvim-tree").setup({
        view = { width = 35 },
        renderer = {
          group_empty = true,
          icons = {
            show = { file = true, folder = true, folder_arrow = true, git = true },
          },
        },
        filters = { dotfiles = false },
        git = { enable = true },
      })

      -- ============================================================
      -- Treesitter
      -- ============================================================
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true, additional_vim_regex_highlighting = false },
        indent    = { enable = true },
      })

      -- ============================================================
      -- LSP (nvim 0.11+ native API)
      -- ============================================================
      local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = ok_cmp and cmp_nvim_lsp.default_capabilities() or vim.lsp.protocol.make_client_capabilities()

      vim.lsp.config("*", { capabilities = capabilities })

      vim.lsp.config("nil_ls", {
        settings = {
          ["nil"] = {
            formatting = { command = { "nixpkgs-fmt" } },
          },
        },
      })

      vim.lsp.enable({ "gopls", "ts_ls", "pyright", "nil_ls", "terraformls", "bashls" })

      -- LSP keymaps (attached per buffer)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }
          vim.keymap.set("n", "gd",         vim.lsp.buf.definition,    opts)
          vim.keymap.set("n", "gD",         vim.lsp.buf.declaration,   opts)
          vim.keymap.set("n", "gr",         vim.lsp.buf.references,    opts)
          vim.keymap.set("n", "gi",         vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "K",          vim.lsp.buf.hover,         opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,        opts)
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>ds", vim.diagnostic.open_float, opts)
          vim.keymap.set("n", "[d",         vim.diagnostic.goto_prev,  opts)
          vim.keymap.set("n", "]d",         vim.diagnostic.goto_next,  opts)
        end,
      })

      -- Diagnostic icons (VSCode style)
      vim.diagnostic.config({
        virtual_text  = true,
        signs         = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = "always" },
      })

      -- ============================================================
      -- Completion (nvim-cmp)
      -- ============================================================
      local cmp     = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"]     = cmp.mapping.abort(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<Tab>"]     = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"]   = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = function(entry, item)
            local source_labels = {
              copilot = "[Copilot]",
              nvim_lsp = "[LSP]",
              luasnip  = "[Snippet]",
              buffer   = "[Buffer]",
              path     = "[Path]",
            }
            item.menu = source_labels[entry.source.name] or entry.source.name
            return item
          end,
        },
      })

      -- ============================================================
      -- GitHub Copilot
      -- ============================================================
      require("copilot").setup({
        suggestion = { enabled = false },  -- handled via cmp
        panel      = { enabled = false },
      })
      require("copilot_cmp").setup()

      -- ============================================================
      -- Telescope (Ctrl+P / Cmd+Shift+F)
      -- ============================================================
      local telescope = require("telescope.builtin")
      vim.keymap.set("n", "<C-p>",      telescope.find_files,  { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", telescope.live_grep,   { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", telescope.buffers,     { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fs", telescope.lsp_document_symbols, { desc = "Document symbols" })
      vim.keymap.set("n", "<leader>fr", telescope.lsp_references,       { desc = "References" })
      vim.keymap.set("n", "<leader>fd", telescope.diagnostics,          { desc = "Diagnostics" })

      require("telescope").setup({
        defaults = {
          layout_config = { horizontal = { preview_width = 0.55 } },
          file_ignore_patterns = { "node_modules", ".git/" },
        },
      })

      -- ============================================================
      -- Git (GitLens-like)
      -- ============================================================
      require("gitsigns").setup({
        current_line_blame = true,
        current_line_blame_opts = {
          delay = 500,
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
          end
          map("n", "]c", function() gs.next_hunk() end,  "Next hunk")
          map("n", "[c", function() gs.prev_hunk() end,  "Prev hunk")
          map("n", "<leader>hs", gs.stage_hunk,           "Stage hunk")
          map("n", "<leader>hr", gs.reset_hunk,           "Reset hunk")
          map("n", "<leader>hp", gs.preview_hunk,         "Preview hunk")
          map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
          map("n", "<leader>hd", gs.diffthis,             "Diff this")
        end,
      })

      -- ============================================================
      -- Format on save (conform.nvim)
      -- ============================================================
      require("conform").setup({
        formatters_by_ft = {
          go               = { "gofmt" },
          javascript       = { "prettier" },
          typescript       = { "prettier" },
          javascriptreact  = { "prettier" },
          typescriptreact  = { "prettier" },
          json             = { "prettier" },
          css              = { "prettier" },
          html             = { "prettier" },
          yaml             = { "prettier" },
          markdown         = { "prettier" },
          python           = { "black" },
          nix              = { "nixpkgs_fmt" },
          terraform        = { "terraform_fmt" },
          sh               = { "shfmt" },
          bash             = { "shfmt" },
        },
        format_on_save = {
          timeout_ms   = 1000,
          lsp_fallback = true,
        },
      })

      -- ============================================================
      -- Indent guides
      -- ============================================================
      require("ibl").setup({
        indent = { char = "│" },
        scope  = { enabled = true },
      })

      -- ============================================================
      -- Auto pairs
      -- ============================================================
      require("nvim-autopairs").setup({ check_ts = true })
      -- integrate with cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      -- ============================================================
      -- Comments (gcc / gc)
      -- ============================================================
      require("Comment").setup()

      -- ============================================================
      -- Which-key (shows available keybindings)
      -- ============================================================
      local wk = require("which-key")
      wk.setup()
      wk.add({
        { "<leader>h", group = "Git hunks" },
        { "<leader>f", group = "Find / Telescope" },
        { "<leader>c", group = "Code actions" },
      })

      -- ? = keybindings cheatsheet (like lazygit)
      vim.keymap.set("n", "?", function() telescope.keymaps() end, { desc = "Keybindings cheatsheet" })

      -- ============================================================
      -- Trailing whitespace on save (matches VSCode trimTrailingWhitespace)
      -- ============================================================
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern  = "*",
        callback = function()
          local pos = vim.fn.getpos(".")
          vim.cmd([[silent! %s/\s\+$//e]])
          vim.fn.setpos(".", pos)
        end,
      })

      -- ============================================================
      -- Keymaps (VSCode-like)
      -- ============================================================

      -- Explorer (Ctrl+B = focus/open like VSCode, Ctrl+\ = toggle)
      vim.keymap.set("n", "<C-b>",      ":NvimTreeFocus<CR>",   { silent = true, desc = "Focus explorer" })
      vim.keymap.set("n", "<C-\\>",     ":NvimTreeToggle<CR>",  { silent = true, desc = "Toggle explorer" })
      vim.keymap.set("n", "<leader>e",  ":NvimTreeFocus<CR>",   { silent = true, desc = "Focus explorer" })

      -- Save (Ctrl+S)
      vim.keymap.set({ "n", "v" }, "<C-s>", ":w<CR>",           { silent = true })
      vim.keymap.set("i",          "<C-s>", "<Esc>:w<CR>a",     { silent = true })

      -- Undo / Redo (Ctrl+Z / Ctrl+Y)
      vim.keymap.set("n", "<C-z>",      "u",                    { silent = true, desc = "Undo" })
      vim.keymap.set("i", "<C-z>",      "<C-o>u",               { silent = true, desc = "Undo" })
      vim.keymap.set("n", "<C-y>",      "<C-r>",                { silent = true, desc = "Redo" })
      vim.keymap.set("i", "<C-y>",      "<C-o><C-r>",           { silent = true, desc = "Redo" })

      -- Find files (Ctrl+P — explicit in case telescope section failed)
      vim.keymap.set("n", "<C-p>",      function() telescope.find_files() end,              { desc = "Find files" })

      -- Find in file (Ctrl+F)
      vim.keymap.set("n", "<C-f>",      function() telescope.current_buffer_fuzzy_find() end, { desc = "Find in file" })
      vim.keymap.set("i", "<C-f>",      "<Esc><cmd>Telescope current_buffer_fuzzy_find<CR>",  { desc = "Find in file" })

      -- Find in project (Ctrl+Shift+F)
      vim.keymap.set("n", "<C-S-f>",    function() telescope.live_grep() end,   { desc = "Find in project" })

      -- Toggle comment (Ctrl+/)  -- terminals may send Ctrl+/ as Ctrl+_
      vim.keymap.set("n", "<C-/>",      "gcc",  { remap = true, silent = true, desc = "Toggle comment" })
      vim.keymap.set("v", "<C-/>",      "gc",   { remap = true, silent = true, desc = "Toggle comment" })
      vim.keymap.set("i", "<C-/>",      "<Esc>gcc<CR>i", { remap = true, silent = true, desc = "Toggle comment" })
      vim.keymap.set("n", "<C-_>",      "gcc",  { remap = true, silent = true, desc = "Toggle comment" })
      vim.keymap.set("v", "<C-_>",      "gc",   { remap = true, silent = true, desc = "Toggle comment" })

      -- Close buffer (Ctrl+W)
      vim.keymap.set("n", "<C-w>",      ":bdelete<CR>",         { silent = true, desc = "Close buffer" })
      vim.keymap.set("n", "<leader>bd", ":bdelete<CR>",         { silent = true, desc = "Close buffer" })

      -- Close all other buffers (Ctrl+K, Ctrl+W — VSCode chord)
      vim.keymap.set("n", "<C-k><C-w>", function()
        local cur = vim.fn.bufnr()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if buf ~= cur and vim.api.nvim_buf_is_loaded(buf) then
            vim.cmd("bdelete " .. buf)
          end
        end
      end, { silent = true, desc = "Close all other buffers" })

      -- Buffer navigation (Ctrl+Tab / Ctrl+Shift+Tab)
      vim.keymap.set("n", "<C-Tab>",    ":bnext<CR>",           { silent = true, desc = "Next buffer" })
      vim.keymap.set("n", "<C-S-Tab>",  ":bprevious<CR>",       { silent = true, desc = "Prev buffer" })
      vim.keymap.set("n", "<S-l>",      ":bnext<CR>",           { silent = true })
      vim.keymap.set("n", "<S-h>",      ":bprevious<CR>",       { silent = true })

      -- Delete line (Ctrl+Shift+K)
      vim.keymap.set("n", "<C-S-k>",    "dd",                   { silent = true, desc = "Delete line" })
      vim.keymap.set("i", "<C-S-k>",    "<Esc>ddi",             { silent = true, desc = "Delete line" })

      -- Duplicate line (Shift+Alt+Down/Up)
      vim.keymap.set("n", "<S-A-Down>", "yyp",                  { silent = true, desc = "Duplicate line down" })
      vim.keymap.set("n", "<S-A-Up>",   "yyP",                  { silent = true, desc = "Duplicate line up" })
      vim.keymap.set("i", "<S-A-Down>", "<Esc>yypi",            { silent = true, desc = "Duplicate line down" })
      vim.keymap.set("i", "<S-A-Up>",   "<Esc>yyPi",            { silent = true, desc = "Duplicate line up" })

      -- Select all (Ctrl+A)
      vim.keymap.set("n", "<C-a>",      "ggVG",                 { silent = true, desc = "Select all" })

      -- Split navigation (Ctrl+hjkl)
      vim.keymap.set("n", "<C-h>",      "<C-w>h",               { silent = true })
      vim.keymap.set("n", "<C-j>",      "<C-w>j",               { silent = true })
      vim.keymap.set("n", "<C-k>",      "<C-w>k",               { silent = true })
      vim.keymap.set("n", "<C-l>",      "<C-w>l",               { silent = true })

      -- Move lines (Alt+Up/Down like VSCode)
      vim.keymap.set("n", "<A-Down>",   ":m .+1<CR>==",         { silent = true, desc = "Move line down" })
      vim.keymap.set("n", "<A-Up>",     ":m .-2<CR>==",         { silent = true, desc = "Move line up" })
      vim.keymap.set("v", "<A-Down>",   ":m '>+1<CR>gv=gv",     { silent = true, desc = "Move selection down" })
      vim.keymap.set("v", "<A-Up>",     ":m '<-2<CR>gv=gv",     { silent = true, desc = "Move selection up" })
      vim.keymap.set("n", "<A-j>",      ":m .+1<CR>==",         { silent = true })
      vim.keymap.set("n", "<A-k>",      ":m .-2<CR>==",         { silent = true })
      vim.keymap.set("v", "<A-j>",      ":m '>+1<CR>gv=gv",     { silent = true })
      vim.keymap.set("v", "<A-k>",      ":m '<-2<CR>gv=gv",     { silent = true })

      -- Stay in indent mode (Tab/Shift+Tab in visual like VSCode)
      vim.keymap.set("v", "<",          "<gv")
      vim.keymap.set("v", ">",          ">gv")

      -- Clear search highlight
      vim.keymap.set("n", "<Esc>",      ":nohlsearch<CR>",      { silent = true })

      -- Terminal (Ctrl+` like VSCode)
      vim.keymap.set("n", "<C-`>",      ":split | terminal<CR>", { silent = true, desc = "Open terminal" })
      vim.keymap.set("n", "<leader>t",  ":split | terminal<CR>", { silent = true, desc = "Open terminal" })
    '';
  };
}
