-- lazy.nvim 플러그인 설정
return {
  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true, -- 자동 제안 활성화
          keymap = {
            accept = "<Tab>", -- Tab 키로 제안 수락 (기존 설정 유지)
            accept_word = false,
            accept_line = false,
            next = "<M-]>",  -- 다음 제안 (필요에 따라 수정)
            prev = "<M-[>",  -- 이전 제안 (필요에 따라 수정)
            dismiss = "<C-]>", -- 제안 거절 (필요에 따라 수정)
          },
        },
        filetypes = {
          -- 특정 파일 형식에서 Copilot 비활성화 (필요에 따라 수정)
          ["TelescopePrompt"] = false,
        },
      })
    end,
  },

  -- nvim-cmp (자동 완성)
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "zbirenbaum/copilot-cmp", -- Copilot을 nvim-cmp 소스로 추가
      "L3MON4D3/LuaSnip",       -- Snippet 엔진 (선택 사항)
      "saadparwaiz1/cmp_luasnip", -- LuaSnip 통합 (선택 사항)
    },
    -- nvim-cmp 설정 (수정)
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),

          ["<Tab>"] = cmp.mapping(function(fallback)
            if require("copilot.suggestion").is_visible() then
              require("copilot.suggestion").accept()
            elseif cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback() -- <--- 여기가 중요! 다른 조건이 없을 때, 기본 탭 동작 실행
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback() -- Shift+Tab도 마찬가지로 기본 동작 허용
            end
          end, { "i", "s" }),
        -- (나머지 설정은 이전과 동일) ...
          ["<S-Tab>"] = cmp.mapping(function(fallback)
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
          { name = "copilot", group_index = 2 }, -- Copilot 소스 추가, 우선순위 설정
          { name = "nvim_lsp", group_index = 2 },
          { name = "luasnip", group_index = 2 },
          { name = "buffer",   group_index = 2 },
          { name = "path",     group_index = 2 },
        }),
        -- (선택 사항) Copilot 제안이 있을 때만 nvim-cmp 팝업 메뉴 표시
        experimental = {
          ghost_text = {
            hl_group = "LspCodeLens",
          },
        },
      })

      cmp.setup.cmdline(':', { -- ':' command line에 대한 설정
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'cmdline' }, -- ':' command line 소스 추가
          { name = "path" },
        })
      })

      cmp.setup.cmdline('/', { -- '/' search line에 대한 설정
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'buffer' }, -- '/' search line 소스 추가
        })
      })
    end,
  },
}
