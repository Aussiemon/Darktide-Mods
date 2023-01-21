local mod = get_mod("loadfile")

local callstack = Script.callstack()

mod:notify("Callstack length:" .. tostring(string.len(callstack)))
mod:debug(callstack)