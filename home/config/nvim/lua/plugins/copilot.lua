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

      local company_project_path = vim.fn.expand('~/company_workspaces/')
      -- 2단계에서 만든 폴더의 전체 경로
      local personal_config_path = vim.fn.expand('~/.config/copilot_personal_config')
      local company_config_path = vim.fn.expand('~/.config/copilot_company_config')
      -- Copilot이 실제로 찾는 심볼릭 링크의 경로
      local symlink_path = vim.fn.expand('~/.config/github-copilot')

      vim.g.copilot_active_config_path = vim.g.copilot_active_config_path or nil

      local function switch_copilot_context()
        -- 현재 버퍼의 전체 파일 경로를 가져옵니다.
        local current_file_path = vim.fn.expand('%:p')

        -- 만약 버퍼에 연결된 파일이 없다면 (예: Telescope, nvim-tree, 새 버퍼 등)
        -- 아무 작업도 하지 않고 함수를 종료합니다. 이것이 가장 중요한 변경점입니다.
        if current_file_path == '' then
          return
        end

        local required_config_path
        if string.find(vim.fn.expand('%:p'), company_project_path, 1, true) then
          required_config_path = company_config_path
        else
          required_config_path = personal_config_path
        end

        local context_name = (required_config_path == company_config_path) and "회사" or "개인"

        if vim.fn.isdirectory(required_config_path) == 0 then
          -- 2. 디렉토리가 없다면 (최초 설정), 새로 생성합니다.
          vim.fn.mkdir(required_config_path, 'p') -- -p 옵션으로 상위 디렉토리까지 생성
          vim.notify('[Copilot] ' .. context_name .. ' 프로필이 없어 새로 생성합니다.', vim.log.levels.WARN)
          vim.notify('잠시 후 `:Copilot auth`를 실행하여 ' .. context_name .. ' 계정으로 로그인해주세요.', vim.log.levels.WARN)
        end
        -- 심볼릭 링크가 가리키는 실제 경로를 읽어옴
        local current_real_path = vim.fn.resolve(symlink_path)

        if current_real_path ~= required_config_path then
          vim.schedule(function()
            local context_name = (required_config_path == company_config_path) and "회사" or "개인"
            vim.notify('[Copilot] ' .. context_name .. ' 계정으로 전환합니다...', vim.log.levels.INFO)

            -- 1. Copilot 비활성화
            vim.cmd('Copilot disable')
            vim.defer_fn(function()
              -- 3. 심볼릭 링크를 교체합니다.
              vim.fn.system('rm -rf ' .. vim.fn.shellescape(symlink_path))
              vim.fn.system('ln -s ' .. vim.fn.shellescape(required_config_path) .. ' ' .. vim.fn.shellescape(symlink_path))

              -- 4. 이제 안정적인 상태에서 Copilot을 다시 활성화합니다.
              vim.cmd('Copilot enable')

              vim.notify('[Copilot] ' .. context_name .. ' 계정으로 전환 완료!', vim.log.levels.INFO)
            end, 100) -- 100밀리초 지연. 만약 문제가 계속되면 150이나 200으로 늘려볼 수 있습니다.

          end)
        end
      end

      vim.api.nvim_create_autocmd('BufEnter', {
        group = vim.api.nvim_create_augroup('CopilotSymlinkSwitcher', { clear = true }),
        pattern = '*',
        callback = switch_copilot_context,
      })

      -- Neovim 시작 시 초기 컨텍스트 설정
      vim.defer_fn(switch_copilot_context, 100)

      -- ‼️ 여기에 경로들을 설정해주세요.
      -- local company_project_path = vim.fn.expand('~/company_workspaces/')
      -- local personal_config_path = vim.fn.expand('~/.config/github-copilot-personal')
      -- local company_config_path = vim.fn.expand('~/.config/github-copilot-company')

      -- -- 현재 활성화된 Copilot 설정 경로를 저장하기 위한 변수
      -- vim.g.copilot_active_config_path = vim.g.copilot_active_config_path or nil

      -- -- 설정 전환 함수
      -- local function switch_copilot_context()
      --   local current_file_path = vim.fn.expand('%:p')
      --   local required_config_path

      --   -- 현재 파일 경로에 따라 필요한 설정 폴더 경로 결정
      --   if string.find(current_file_path, company_project_path, 1, true) then
      --     required_config_path = company_config_path
      --   else
      --     required_config_path = personal_config_path
      --   end

      --   -- 필요한 설정과 현재 설정이 다를 경우에만 전환 실행
      --   if vim.g.copilot_active_config_path ~= required_config_path then

      --     -- <<<<<<<<<<<<<<< 여기가 핵심적인 수정 부분 >>>>>>>>>>>>>>>
      --     -- disable/enable 과정을 vim.schedule을 통해 안전하게 실행하도록 예약합니다.
      --     vim.schedule(function()
      --       local context_name = (required_config_path == company_config_path) and "회사" or "개인"
      --       vim.notify('[Copilot] ' .. context_name .. ' 계정으로 전환합니다...', vim.log.levels.INFO)

      --       vim.cmd('Copilot disable')
      --       vim.fn.setenv('XDG_CONFIG_HOME', required_config_path)
      --       vim.cmd('Copilot enable')

      --       vim.g.copilot_active_config_path = required_config_path
      --     end)
      --     -- <<<<<<<<<<<<<<<<<<<<<<<<<<< >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      --   end
      -- end

      -- -- Neovim에서 파일을 열 때마다 위 함수를 실행
      -- vim.api.nvim_create_autocmd('BufEnter', {
      --   group = vim.api.nvim_create_augroup('CopilotContextSwitcher', { clear = true }),
      --   pattern = '*',
      --   callback = switch_copilot_context,
      -- })

      -- Neovim 시작 시 초기 컨텍스트 설정

      -- local company_project_path = vim.fn.expand('~/company_workspaces/')
      -- local personal_github_username = 'hhosu107' -- ‼️ 본인의 '개인' GitHub 사용자 이름

              -- 상태 확인 및 전환을 실행하는 함수
      -- local function check_and_switch_copilot_user()
          -- ':Copilot status' 명령어의 결과값을 가져옴
      --   local status_output = vim.fn.execute('Copilot status')

          -- 결과값에서 실제 로그인된 사용자 이름을 추출 (예: "Signed in as <username>")
          -- 만약 로그아웃 상태라면 actual_user는 nil이 됨
          -- local actual_user = status_output:match("Signed in as (%S+)")

          -- 현재 파일 경로에 따라 필요한 컨텍스트 결정
          -- local required_context = 'personal'
          -- if string.find(vim.fn.expand('%:p'), company_project_path, 1, true) then
            -- required_context = 'company'
          -- end

        -- 1. 회사 프로젝트 폴더에 있을 때
        -- if required_context == 'company' then
          -- 현재 로그인된 유저가 '개인' 계정이라면 로그아웃을 실행
          --  if actual_user and actual_user == personal_github_username then
          --   vim.notify('[Copilot] 회사 계정 사용을 위해 로그아웃합니다.', vim.log.levels.INFO)
          --   vim.cmd('Copilot auth signout')
          -- end
        -- 2. 개인 프로젝트 폴더에 있을 때
        -- else -- required_context == 'personal'
          -- 현재 로그인된 유저가 있고, 그 유저가 '개인' 계정이 아니라면 (즉, 회사 계정이라면) 로그아웃 실행
          -- if actual_user and actual_user ~= personal_github_username then
            -- vim.notify('[Copilot] 개인 계정 사용을 위해 로그아웃합니다.', vim.log.levels.INFO)
            -- vim.cmd('Copilot auth signout')
          -- end
        -- end
      -- end

      -- Neovim에서 파일을 열 때마다 위 함수를 실행
      -- vim.api.nvim_create_autocmd('BufEnter', {
        -- group = vim.api.nvim_create_augroup('CopilotUserSwitcher', { clear = true }),
        -- pattern = '*',
        -- callback = check_and_switch_copilot_user,
      -- })
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
