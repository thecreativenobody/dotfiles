local lsp = require 'lspconfig'
local lsp_status = require 'lsp-status'
local utils = require 'creativenull.utils'
local M = {}

-- Register buffer keymaps
local function register_buf_keymaps()
  utils.buf_keymap('n', '<leader>ld', '<cmd>lua vim.lsp.buf.definition()<CR>')
  utils.buf_keymap('n', '<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
  utils.buf_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>')
  utils.buf_keymap('n', '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>')
  utils.buf_keymap('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  utils.buf_keymap('n', '<leader>le', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
  utils.buf_keymap('n', '<F2>',       '<cmd>lua vim.lsp.buf.rename()<CR>')
  utils.buf_keymap('i', '<C-y>',      'compe#confirm("<CR>")', { expr = true })
end

-- Register diagnostic view on cursor hold event
local function register_cursorhold_event()
  vim.cmd 'augroup lsp_diagnostic_popup'
  vim.cmd 'au!'
  vim.cmd 'au CursorHold  <buffer> lua vim.lsp.diagnostic.show_line_diagnostics()'
  vim.cmd 'au CursorMoved <buffer> lua vim.lsp.buf.clear_references()'
  vim.cmd 'augroup end'
end

-- LSP on attach event
local function on_attach(client, bufnr)
  print('Attached to ' .. client.name)
  lsp_status.on_attach(client)
  register_buf_keymaps()
  register_cursorhold_event()
end

-- Organize imports
-- https://www.reddit.com/r/neovim/comments/lwz8l7/how_to_use_tsservers_organize_imports_with_nvim/gpkueno?utm_source=share&utm_medium=web2x&context=3
local function ts_orgnize_imports()
  vim.lsp.buf.execute_command({
    command = '_typescript.organizeImports',
    arguments = { vim.api.nvim_buf_get_name(0) }
  })
end

_G.RegisterLsp = function(lsp_name, opts)
  local default_opts = {
    on_attach = on_attach,
    capabilities = lsp_status.capabilities
  }

  if lsp[lsp_name] == nil then
    vim.api.nvim_err_writeln(' "' .. lsp_name .. '" does not exist in nvim-lspconfig')
    return
  end

  if lsp_name == 'tsserver' then
    default_opts.commands = {
      TsserverOrganizeImports = {
        ts_orgnize_imports,
        description = 'Organize imports'
      }
    }
  end

  if opts ~= nil and not vim.tbl_isempty(opts) then
    -- Merge 'opts' w/ 'default_opts'. If keys are the same, then override key from 'opts'
    lsp[lsp_name].setup(vim.tbl_extend('force', default_opts, opts))
  else
    lsp[lsp_name].setup(default_opts)
  end
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  virtual_text = false,
  signs = true,
  update_in_insert = true,
})

-- vim.lsp.set_log_level("debug")

-- Examples below

--[[
lsp.tsserver.setup {
  on_attach = on_attach,
  capabilities = lsp_status.capabilities
}
--]]

--[[
lsp.denols.setup {
  on_attach = on_attach,
  capabilities = lsp_status.capabilities,
  init_options = {
    enable = true,
    unstable = true,
    importMap = './import_map.json'
  },
  root_dir = lsp.util.root_pattern('.denols')
}
--]]

--[[
lsp.vuels.setup {
  on_attach = on_attach,
  capabilities = lsp_status.capabilities,
  init_options = {
    config = {
      css = {},
      emmet = {},
      html = {
        suggest = {}
      },
      javascript = {
        format = {}
      },
      stylusSupremacy = {},
      typescript = {
        format = {}
      },
      vetur = {
        completion = {
          autoImport = false,
          tagCasing = "kebab",
          useScaffoldSnippets = false
        },
        format = {
          defaultFormatter = {
            js = "none",
            ts = "none"
          },
          defaultFormatterOptions = {},
          scriptInitialIndent = false,
          styleInitialIndent = false
        },
        useWorkspaceDependencies = false,
        validation = {
          script = true,
          style = true,
          template = false
        }
      }
    }
  }
}
--]]

--[[
lsp.jsonls.setup {
  on_attach = on_attach,
  capabilities = lsp_status.capabilities
}
--]]

--[[
lsp.intelephense.setup {
  on_attach = on_attach,
  capabilities = lsp_status.capabilities
}
--]]

--[[
local current_path = (...):gsub('%.init$', '')
require (current_path .. '.diagnosticls').setup {
  on_attach = on_attach,
  capabilities = lsp_status.capabilities
}
--]]
