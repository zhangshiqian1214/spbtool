local lfs = require "lfs"
local class = require "class"
local parser = require "sprotoparser"
local base64 = require "base64"


-- path查找的目录
-- path查找的模式
-- info_folder 是否进入子目录
local function find_dir_files(path, patten, intofolder, result)
	result = result or {}
	for file in lfs.dir(path) do
		if file ~= "." and file ~= ".." then
			local f = string.gsub(path.."/"..file, "//", "/")
			local attr = lfs.attributes(f)
			assert (type(attr) == "table")
			if attr.mode == "directory" and intofolder then
				find_dir_files(f, patten, intofolder, result)
			else
				if string.find(f, patten) ~= nil then
					table.insert(result, f)
				end
			end
		end
	end
	return result
end

local M = class()
function M:ctor()
	self._dump_path = nil      -- "./" or "./protocol/"
	self._sproto_files = {}
end

function M:set_dump_path(path)
	self._dump_path = path
end

function M:set_dump_file(file)
	self._dump_file = file
end

function M:load(path, intofolder)
	local files = find_dir_files(path, "%.sproto", intofolder)
	for _, file in pairs(files) do
		self._sproto_files[file] = true
	end
end

function M:clear()
	for k, _ in pairs(self._sproto_files) do
		self._sproto_files[k] = nil
	end
end

function M:parse()
	local text = ""
	for path, _ in pairs(self._sproto_files) do
		local f = assert(io.open(path), "Can't open "..path)
		local data = f:read "a"
		text = text .. "\n" .. data
		f:close()
	end
	return parser.parse(text)
end

function M:_dump(dump_file, isb64)
	dump_file = dump_file or self._dump_file
	if not dump_file then
		return
	end
	if _G.next(self._sproto_files) == nil then
		return
	end
	local dump_path = self._dump_path or ""
	local content = self:parse()
	local f = assert(io.open(dump_path..dump_file, "w+b"), "can't open "..self._dump_path..dump_file)
	if isb64 then
		f:write(base64.encode(content))
	else
		f:write(content)
	end
  	f:close()
end

function M:dump(dump_file)
	self:_dump(dump_file, false)
end

function M:base64_dump(dump_file)
	self:_dump(dump_file, true)
end

return M