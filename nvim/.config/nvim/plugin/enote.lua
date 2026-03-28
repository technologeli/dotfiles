-- Like Denote, but Enote, for Eli ;)
local uv = vim.uv
local enote_directory = vim.fn.expand("~/notes")
vim.opt.spellfile = vim.fs.joinpath(enote_directory, "20250902T135400--dictionary.en.utf-8.add")

local external_extensions = {
	"xlsx", "pptx", "docx",
	"pdf",
	"png", "jpg", "jpeg", "gif", "bmp", "svg", "webp"
}

local function slugify(str)
	-- Convert to lowercase, remove punctuation (except hyphens), replace spaces with hyphens
	str = str:lower():gsub("[^%w%s%-]", ""):gsub("%s+", "-")
	return str
end

local function get_timestamp()
	return os.date("%Y%m%dT%H%M%S")
end

local function get_notes_list()
	local items = vim.fn.systemlist("rg --follow --files " .. enote_directory)
	for i, item in ipairs(items) do
		items[i] = vim.fn.fnamemodify(item, ":t")
	end
	return items
end

local function prepend_to_file(str, filepath)
	local lines = vim.fn.readfile(filepath)
	table.insert(lines, 1, str)
	vim.fn.writefile(lines, filepath)
end

local function parse_filename(filename)
	local part1 = vim.split(filename, "--", { plain = true })
	local id = part1[1]

	-- tags are optional
	if filename:find("__") then
		local part2 = vim.split(part1[2], "__", { plain = true })
		local title = part2[1]
		local part3 = vim.split(part2[2], ".", { plain = true })
		local tags = part3[1]
		local ext = table.concat(vim.list_slice(part3, 2, #part3), ".")
		tags = vim.split(tags, "_", { plain = true })

		return {
			id = id,
			title = title,
			tags = tags,
			ext = ext
		}
	else
		local part2 = vim.split(part1[2], ".", { plain = true })
		local title = part2[1]
		local ext = table.concat(vim.list_slice(part2, 2, #part2), ".")

		return {
			id = id,
			title = title,
			tags = nil,
			ext = ext
		}
	end
end

local function replace_local_links(filepath)
	-- Read the file
	local file = io.open(filepath, "r")
	if not file then
		print("Could not open file: " .. filepath)
		return
	end
	local content = file:read("*all")
	file:close()

	local replaced = false
	local new_content = content:gsub("(%[(.-)%]%((.-)%))", function(full_match, text, url)
		if url:match("^%./") then
			local filedata = parse_filename(url:sub(3))
			local new_name = filedata.title .. "." .. filedata.ext
			replaced = true
			return "[" .. text .. "](./".. new_name ..")"
		else
			return full_match
		end
	end)

	-- Write back to the file
	file = io.open(filepath, "w")
	if file then
		file:write(new_content)
		file:close()
		if replaced then
			print("  - Replaced relative links")
		end
	else
		print("Could not write to file: " .. filepath)
	end
end

local function pick_notes()
	MiniPick.start({
		source = {
			items = get_notes_list(),
			name = "Notes",
			choose = function(filename)
				local extension = vim.fn.fnamemodify(filename, ":e")
				if vim.tbl_contains(external_extensions, extension:lower()) then
					-- open in external app
					vim.schedule(function()
						vim.ui.open(vim.fs.joinpath(enote_directory, filename))
					end)
				else
					-- open in neovim
					vim.schedule(function()
						vim.cmd("edit " .. vim.fs.joinpath(enote_directory, filename))
					end)
				end
			end,
		},
	})
end

local function extract_title(filename)
	local start_pos = filename:find("%-%-") -- Look for "--"
	if not start_pos then
		return filename:sub(1, filename:find("T") - 1)
	end

	-- Adjust to start extracting after "--"
	start_pos = start_pos + 2

	-- Look for "__" after "--"
	local end_pos = filename:find("__", start_pos)
	if not end_pos then
		-- If "__" not found, look for "."
		end_pos = filename:find("%.", start_pos)
	end

	-- If no "__" or ".", return from "--" to end of string
	if not end_pos then
		return filename:sub(start_pos)
	end

	return filename:sub(start_pos, end_pos - 1)
end

local function pick_link()
	MiniPick.start({
		source = {
			items = get_notes_list(),
			name = "Link to Note",
			choose = function(filename)
				vim.schedule(function()
					vim.ui.input({ prompt = "Link Text: ", default = extract_title(filename) }, function(text)
						if text == nil then
							local line = "[" .. extract_title(filename) .. "](./" .. filename .. ")"
							vim.cmd("normal! i" .. line)
						else
							local line = "[" .. text .. "](./" .. filename .. ")"
							vim.cmd("normal! i" .. line)
						end
					end)
				end)
			end,
		},
	})
end

local function create_note()
	vim.ui.input({ prompt = "Title: " }, function(title)
		local filename = get_timestamp()
		if title == nil then
			return
		end

		if title ~= "" then
			filename = filename .. "--" .. slugify(title)
		end

		vim.ui.input({ prompt = "Tags: " }, function(tags)
			if tags and tags ~= "" then
				local tag_str = tags:gsub("%s+", ""):gsub(",", "_")
				filename = filename .. "__" .. tag_str
			end

			filename = filename .. ".md"

			vim.cmd("edit " .. vim.fs.joinpath(enote_directory, filename))
		end)
	end)
end


local function is_created_today(name)
	local today = os.date("*t")

	return tonumber(string.sub(name, 1, 4)) == today.year
	and tonumber(string.sub(name, 5, 6)) == today.month
	and tonumber(string.sub(name, 7, 8)) == today.day
end

local function today()
	local files = {}
	local handle = uv.fs_scandir(enote_directory)
	if not handle then
		print("Directory not found: " .. enote_directory)
		return
	end

	while true do
		local name, type = uv.fs_scandir_next(handle)
		if not name then break end
		if type == 'file' and name:find("_journal") then
			local filepath = vim.fs.joinpath(enote_directory, name)
			local stat = uv.fs_stat(filepath)
			if is_created_today(name) then
				table.insert(files, { path = filepath, ctime = stat.ctime.sec })
			end
		end
	end

	if #files == 0 then
		print("No journal entry for today.")
		return
	end

	table.sort(files, function(a, b)
		return a.ctime > b.ctime
	end)

	local latest_file = files[1].path
	vim.cmd("edit " .. vim.fn.fnameescape(latest_file))
end

local function share(tags, target_directory)
	tags = vim.split(tags, ",", { plain = true })
	vim.notify("Files copied:")
	for name, type in vim.fs.dir(enote_directory) do
		if type == "file" then
			-- skip hidden files
			if name:sub(1, 1) ~= "." then
				local file = parse_filename(name)
				if file.tags ~= nil then
					local matches_all_tags = true
					for _, tag in ipairs(tags) do
						if not vim.tbl_contains(file.tags, tag) then
							matches_all_tags = false
						end
					end

					if matches_all_tags and vim.tbl_contains(file.tags, "shareable") then
						local new_name = file.title .. "." .. file.ext
						local new_path = vim.fs.joinpath(target_directory, new_name)
						local old_path = vim.fs.joinpath(enote_directory, name)

						local success = uv.fs_copyfile(old_path, new_path)
						if success then
							vim.notify("- " .. new_name)
						end

						-- don't put a date here because git will think it's a changed file
						if file.ext == "md" then
							prepend_to_file("<!-- This file was copied (autogenerated) from my notes. -->", new_path)
							replace_local_links(new_path)
						end
					end
				end
			end
		end
	end
end

vim.api.nvim_create_user_command("EnoteShare", function(opts)
	if #opts.fargs ~= 2 then
		vim.notify("Usage: :EnoteShare <tag> <target_directory>")
		return
	end
	local tag = opts.fargs[1]
	local target_directory = vim.fn.expand(opts.fargs[2])
	share(tag, target_directory)
end, { nargs = "+", complete = "dir" })

vim.api.nvim_create_user_command("EnoteAdopt", function(opts)
	local original_filename = opts.args
	if original_filename == "" then
		vim.notify("No file name given", vim.log.levels.ERROR)
		return
	end

	local filename = vim.fn.fnamemodify(original_filename, ":t:r")
	vim.ui.input({ prompt = "Title (make empty to slugify): ", default = filename }, function(title)
		if title == nil then
			return
		end

		if title == "" then
			title = slugify(filename)
		end

		filename = title

		local filetype = vim.fn.fnamemodify(original_filename, ":e")
		local new_filename = get_timestamp() .. "--" .. filename .. "." .. filetype
		vim.fn.rename(original_filename, vim.fs.joinpath(enote_directory, new_filename))
		vim.cmd("redraw")
		vim.notify("File renamed to " .. new_filename)
	end)
end, { nargs = 1, complete = "file" })

vim.api.nvim_create_user_command("EnoteSearch", function(opts)
	vim.cmd("sil grep -i \"" .. (opts.args or "") .. "\" " .. enote_directory)
	vim.cmd("copen")
end, { nargs = "*" })

vim.keymap.set({ "n", "i" }, "<C-l>", pick_link)
vim.keymap.set("n", "<leader>nf", pick_notes)
vim.keymap.set("n", "<leader>nn", create_note)
vim.keymap.set("n", "<leader>nt", today)
vim.keymap.set("n", "<leader>ns", ":EnoteSearch ")

