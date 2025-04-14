return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  opts = {
    provider = "ollama",
    ollama = {
      endpoint = "http://localhost:11434",
      model = "qwen2.5-coder:7b",
      stream = true,
      -- add a new route called getActivityPerId
    },
    behaviour = {
      --- ... existing behaviours
      enable_cursor_planning_mode = true, -- enable cursor planning mode!
      auto_suggestions = false,         -- Experimental stage
    },
    rag_service = {
      enabled = true,                -- Enables the RAG service
      host_mount = os.getenv("HOME"), -- Host mount path for the rag service
      provider = "ollama",           -- The provider to use for RAG service (e.g. openai or ollama)
      llm_model = "qwen2.5-coder:1.5b", -- The LLM model to use for RAG service
      embed_model = "nomic-embed-text", -- The embedding model to use for RAG service
    },
    vendors = {
      deepseek8b = {
        __inherited_from = "ollama",
        model = "deepseek-r1:8b",
      },
      deepseek14b = {
        __inherited_from = "ollama",
        model = "deepseek-r1:14b",
      },
      codegemma = {
        __inherited_from = "ollama",
        model = "codegemma:latest",
      },
      codegemma2b = {
        __inherited_from = "ollama",
        model = "codegemma:2b",
      },
      llama = {
        __inherited_from = "ollama",
        model = "llama3.1:8b",
      },
      deepseekcoder = {
        __inherited_from = "ollama",
        model = "deepseek-coder:1.3b",
      },
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "echasnovski/mini.pick",       -- for file_selector provider mini.pick
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp",            -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua",            -- for file_selector provider fzf
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua",      -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
