{ config, pkgs, lib, inputs, unstable, ... }:
{
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    globals.mapleader = " ";
    luaLoader.enable = true;
    extraConfigLua = ''
      -- Set leader key to Space
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "
      vim.keymap.del("n", "<leader>o")
      local keymap = vim.keymap.set
      local opts = { noremap = true, silent = true }
      -- Tabs
      keymap("n", "<leader>T", ":tabnew<CR>", opts)        -- New tab
      keymap("n", "<leader>W", ":tabclose<CR>", opts)     -- Close tab
      keymap("n", "<leader><Tab>", ":tabnext<CR>", opts)  -- Next tab
      keymap("n", "<leader><S-Tab>", ":tabprevious<CR>", opts) -- Previous tab
      -- Splits
      keymap("n", "<leader>v", ":vsplit<CR>", opts)       -- Vertical split
      keymap("n", "<leader>3", ":vsplit<CR>", opts)       -- Vertical split
      keymap("n", "<leader>h", ":split<CR>", opts)        -- Horizontal split
      keymap("n", "<leader>2", ":split<CR>", opts)        -- Horizontal split
      keymap("n", "<leader>0", ":close<CR>", opts)        -- Close split/window
      -- Pane (window) navigation
      keymap("n", "<leader><Right>", "<C-w>l", opts)      -- Right pane
      keymap("n", "<leader><Left>", "<C-w>h", opts)       -- Left pane
      keymap("n", "<leader><Up>", "<C-w>k", opts)         -- Top pane
      keymap("n", "<leader><Down>", "<C-w>j", opts)       -- Bottom pane
      -- Save file
      keymap("n", "<leader>s", ":write<CR>", opts)
      -- Emacs
      -- Save file
      keymap("i", "<C-x>s", "<Esc>:w<CR>", opts)
      keymap("n", "<C-x>s", ":w<CR>", opts)
      keymap("i", "<C-x>s", "<C-o>:w<CR>", opts)
      -- Open file
      keymap("i", "<C-x>f", "<Esc>:e<Space>", opts)
      keymap("n", "<C-x>f", ":e<Space>", opts)
      -- File explorer
      keymap("n", "<C-x>d", ":Explore<CR>", opts)
      -- Quit
      keymap("n", "<C-x>c", ":q<CR>", opts)
      -- Insert mode navigation
      keymap("i", "<C-a>", "<Home>", opts)
      keymap("i", "<C-e>", "<End>", opts)
      keymap("i", "<C-b>", "<Left>", opts)
      keymap("i", "<C-f>", "<Right>", opts)
      keymap("i", "<C-p>", "<Up>", opts)
      keymap("i", "<C-n>", "<Down>", opts)
      -- Word navigation in insert mode
      keymap("i", "<M-b>", "<C-Left>", opts)
      keymap("i", "<M-f>", "<C-Right>", opts)
      -- Delete to end of line
      keymap("i", "<C-k>", "<C-o>D", opts)
      keymap("n", "<C-k>", "dd", opts)
      -- Clipboard operations
      keymap("v", "<M-w>", '"+y', opts)
      keymap("n", "<C-y>", '"+p', opts)
      keymap("i", "<C-y>", "<C-r>+", opts)
      -- Undo/Redo
      keymap("i", "<C-x>u", "<C-o>u", opts)
      keymap("n", "<C-x>u", "u", opts)
      keymap("n", "<C-x>r", "<C-r>", opts)
      -- Window management
      keymap("n", "<C-x>2", ":split<CR>", opts)
      keymap("n", "<C-x>3", ":vsplit<CR>", opts)
      keymap("n", "<C-x>1", ":only<CR>", opts)
      keymap("n", "<C-x>0", ":close<CR>", opts)
      keymap("n", "<C-x>o", "<C-w>w", opts)
      -- Tab management
      keymap("n", "<C-c>t", "<Esc>:tabnew<CR>", opts)
      keymap("n", "<C-c>w", "<Esc>:tabclose<CR>", opts)
      keymap("n", "<C-c><Tab>", "gt", opts)
      keymap("n", "<C-c><S-Tab>", "gT", opts)
      -- Buffer switch
      keymap("n", "<C-x>b", ":buffer<Space>", opts)
    '';
    plugins = {
      lualine.enable = true;
      telescope.enable = true;
      nvim-autopairs.enable = true;
      which-key.enable = true;
      web-devicons.enable = true;
      rainbow-delimiters.enable = true;
      colorizer.enable = true; # Hex Color Preview
      visual-multi.enable = true;
      # LSP
      cmp.enable = true;
      lsp.enable = true;
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          rust
          nix
          haskell
          markdown
          c
          lua
          html
          css
          json
          javascript
          nix
        ];
      };
      rustaceanvim.enable = true;
      markdown-preview.enable = true;
      treesitter-textobjects.enable = true;
      treesitter-context.enable = true;
    };
    keymaps = [
      {
        key = "<leader>ff";
        action = "require('felescope.builfin').find_files";
        mode = "n";
      }
      {
        key = "<leader>ss";
        action = ":Telescope live_grep<CR>";
        mode = "n";
      }
      {
        key = "<leader>bb";
        action = ":Telescope buffers<CR>";
        mode = "n";
      }
      {
        key = "<leader>o";
        action = "<C-w>w";
        mode = "n";
      }
    ];
    opts = {
      # Numbers
      number = true;
      relativenumber = true;
      # Tab
      tabstop = 2;
      softtabstop = 2;
      showtabline = 2;
      expandtab = true;
      smartindent = true; # Enable smart indentation.
      shiftwidth = 2; # Number of spaces to use for each step of (auto)indent.
      breakindent = true; # Enable break indent.
      cursorline = true; # Highlight screen line of cursor.
      scrolloff = 8; # Minimum number of screen lines to keep above and below the cursor.
      mouse = "a"; # Enable Mouse
      # Folding
      foldmethod = "manual";
      foldenable = false;
      linebreak = true; # Wrap long lines at a character.
      swapfile = false; # Disable Swap File Creation
      spell = false; # Spellcheck
      timeoutlen = 300; # Timeout for Mapped Squence
      termguicolors = true; # Enable 24-bit RGB Colors in TUI
      showmode = true; # Show mode in the Command Line
      # Splitting
      splitbelow = true;
      splitkeep = "screen";
      splitright = true;
      cmdheight = 0; # Hide cmd line unless needed.
      fillchars = {
        eob = " "; # Remove EOB
      };
    };
  };
}
