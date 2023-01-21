local mod = get_mod("loadfile")

local message = "Hello Mourningstar"

mod:echo(message)
mod:notify(message)
mod:info(message)
mod:error(message)
mod:warning(message)
mod:debug(message)