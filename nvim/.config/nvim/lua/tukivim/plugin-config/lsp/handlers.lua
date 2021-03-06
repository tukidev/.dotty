local U = vim.tukivim.utils

local defaults = {}
defaults.signs = {
	{ name = "DiagnosticSignError", text = "" },
	{ name = "DiagnosticSignWarn", text = "" },
	{ name = "DiagnosticSignHint", text = "" },
	{ name = "DiagnosticSignInfo", text = "" },
}

defaults.config = {
	virtual_text = false, -- disable virtual text
	signs = { active = defaults.signs }, -- show signs
	update_in_insert = true,
	underline = true,
	severity_sort = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
}

function H()
	local self = {}

	self.capabilities = require("cmp_nvim_lsp").update_capabilities(
        vim.lsp.protocol.make_client_capabilities()
    )

    self.ignore_lsp_formatting = {
        'sumneko_lua',
    }

	local function lsp_highlight_document(client) -- TODO: relocate to `tukivim.utils.lsp` module
		-- Set autocommands conditional on server_capabilities
		if client.server_capabilities.document_highlight then
			vim.api.nvim_exec( -- TODO: relocate cmd to `tukivim.commands` module
				[[
                augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
                augroup END
                ]],
				false
			)
		end
	end

	function self.on_attach(client, bufnr)
        -- remove formatting capabilities from servers
        if U.has_value(self.ignore_lsp_formatting, client.name) then
            client.server_capabilities.document_formatting = false
            -- client.server_capabilities.document_range_formatting = false    -- WARN: doesn't work
        end

		vim.tukivim.keymaps.load_module_wk("lsp_wk", "f", bufnr)
		lsp_highlight_document(client)
	end

	function self.setup(config)
		config = config or defaults.config
		local signs = defaults.signs

		for _, sign in ipairs(signs) do
			vim.fn.sign_define(sign.name, {
				texthl = sign.name,
				text = sign.text,
				numhl = "",
			})
		end

		vim.diagnostic.config(config)

		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

		vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
			vim.lsp.handlers.signature_help,
			{ border = "rounded" }
		)

		return self
	end

	return self
end

return H()
