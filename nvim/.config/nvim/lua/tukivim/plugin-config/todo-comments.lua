local ICONS = vim.tukivim.res.icons.todo_comments
vim.tukivim.utils.psetup("todo-comments", {
	signs = false, -- show icons in the signs column
	sign_priority = 999, -- sign priority

	-- keywords recognized as todo comments
	keywords = {
		--- icon  : used for the sign, and in search results
		--- color : can be a hex color, or a named color (see below)
		--- alt   : a set of other keywords that all map to this FIX keywords
		--- signs : configure signs for some keywords individually

		FIX = { icon = ICONS.FIX, color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
		TODO = { icon = ICONS.TODO, color = "info" },
		HACK = { icon = ICONS.HACK, color = "warning" },
		WARN = { icon = ICONS.WARN, color = "warning", alt = { "WARNING", "XXX" } },
		NOTE = { icon = ICONS.NOTE, color = "hint", alt = { "INFO" } },
		PERF = { icon = ICONS.PERF, alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
	},
	merge_keywords = true, -- when true, custom keywords will be merged with the defaults

	-- highlighting of the line containing the todo comment
	-- * before: highlights before the keyword (typically comment characters)
	-- * keyword: highlights of the keyword
	-- * after: highlights after the keyword (todo text)
	highlight = {
		before = "", -- "fg" or "bg" or empty
		keyword = "wide", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
		after = "fg", -- "fg" or "bg" or empty
		pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
		comments_only = true, -- uses treesitter to match keywords in comments only
		max_line_len = 400, -- ignore lines longer than this
		exclude = {}, -- list of file types to exclude highlighting
	},

	search = {
		command = "rg",
		args = {
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
		},

		-- regex that will be used to match keywords.
		-- don't replace the (KEYWORDS) placeholder
		pattern = [[\b(KEYWORDS):]], -- ripgrep regex
		-- pattern = [[\b(KEYWORDS)\b]],        -- match without the extra colon. You'll likely get false positives
	},
})
