local mod = get_mod("loadfile")

local globals = {}
for key in pairs(_G.CLASS) do
	globals[key] = key
end
mod:dump_to_file(globals, "globals", 1)