-- lsp.lua 수정본
require('mason').setup({
  PATH = "append"
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}

vim.lsp.set_log_level("debug")  -- avoid lsp log is too large issue

-- mason-lspconfig.setup() 함수 내부에 setup_handlers를 포함시킵니다.
require('mason-lspconfig').setup {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    handlers = { -- 'setup_handlers' 대신 'handlers' 필드를 사용합니다.
        ["rust_analyzer"] = function()
            -- rust_analyzer에 대한 특정 설정
            require("lspconfig").rust_analyzer.setup {
                capabilities = capabilities,
                -- 여기에 rust_analyzer의 추가 설정을 넣을 수 있습니다.
            }
        end,
        -- 기본 핸들러 (옵션)
        function(server_name)
            require("lspconfig")[server_name].setup {
                capabilities = capabilities,
            }
        end,
        -- Next, you can provide a dedicated handler for specific servers.
        -- For example, a handler override for the `rust_analyzer`:
    }
}
