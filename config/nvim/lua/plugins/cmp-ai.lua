return {
  "tzachar/cmp-ai",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
  },
  config = function()
    require("cmp_ai.config"):setup({
      max_lines = 100,
      provider = "Ollama",
      provider_options = {
        model = "qwen2.5-coder:1.5b",
        prompt = function(lines_before, lines_after)
          -- You may include filetype and/or other project-wise context in this string as well.
          -- Consult model documentation in case there are special tokens for this.
          return "<|fim_prefix|>" .. lines_before .. "<|fim_suffix|>" .. lines_after .. "<|fim_middle|>"
        end,
      },
      notify = true,
      notify_callback = function(msg)
        vim.notify(msg)
      end,
      run_on_every_keystroke = false,
    })
  end,
}
