P = function(stuff)
	print(vim.inspect(stuff))
	return stuff
end

if pcall(require, "plenary") then
	RELOAD = require("plenary.reload").reload_module
	R = function(module)
		RELOAD(module)
		return require(module)
	end
else
	R = function(module)
		package.loaded[module] = nil
		return require(module)
	end
end

TC = function(list, x)
	for _, v in pairs(list) do
		if v == x then
			return true
		end
	end
	return false
end
