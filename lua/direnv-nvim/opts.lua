---@class DirenvAutocmdSetup
---@field autocmd_event string
---@field autocmd_pattern string
---@field get_cwd fun(): string | nil

---@class DirenvHook
---@field msg "status" | "diff" | nil

---@class DirenvOnFinishedOpts
---@field pattern table<string>

---@class DirenvOpts
---@field type "buffer" | "dir" | "custom"
---@field buffer_setup DirenvAutocmdSetup
---@field dir_setup DirenvAutocmdSetup
---@field custom_setup DirenvAutocmdSetup
---@field async boolean
---@field hook DirenvHook
---@field on_direnv_finished_opts DirenvOnFinishedOpts
---@field on_direnv_finished fun() | nil
local default_opts = {
	type = "buffer",
	buffer_setup = {
		autocmd_event = "BufEnter",
		autocmd_pattern = "*",
		get_cwd = function()
			local buf = vim.api.nvim_buf_get_name(0)
			if vim.fn.filereadable(buf) == 1 then
				return vim.fs.dirname(buf)
			else
				return nil
			end
		end,
	},
	dir_setup = {
		autocmd_event = "DirChanged",
		autocmd_pattern = "*",
		get_cwd = function()
			return vim.uv.cwd()
		end,
	},
	custom_setup = {
		autocmd_event = "BufEnter",
		autocmd_pattern = "*",
		get_cwd = function()
			vim.notify_once(
				"You need to define a custom_setup.get_cwd option",
				vim.log.levels.WARN,
				{ title = "direnv.nvim" }
			)
			return nil
		end,
	},
	async = false,
	hook = {
		msg = "status",
	},
	on_direnv_finished_opts = {
		pattern = { "DirenvReady", "DirenvNotFound" },
	},
	on_direnv_finished = nil,
}

return default_opts
