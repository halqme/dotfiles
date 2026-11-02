local cmd = require("cmd")
local file = require("file")
local json = require("json")

local M = {}

function M.home()
    local home = os.getenv("HOME")
    if not home or home == "" then
        error("HOME is not set")
    end
    return home
end

function M.binary()
    local path = M.home() .. "/.vite-plus/bin/vp"
    if file.exists(path) then
        return path
    end
    local ok, found = pcall(cmd.exec, "command -v vp")
    if ok then
        found = found:gsub("%s+$", "")
        if found ~= "" then
            return found
        end
    end
    error("Vite+ is not installed")
end

function M.installed()
    local raw = cmd.exec('"$VP" list -g --json', {
        cwd = M.home(),
        env = { VP = M.binary() },
    })
    if not raw:match("^%s*%[") then
        error("vp list -g --json did not return a JSON array")
    end
    local data = json.decode(raw)
    local versions = {}
    for _, item in ipairs(data) do
        if type(item) ~= "table" or type(item.name) ~= "string" or type(item.version) ~= "string" then
            error("vp list -g --json returned an invalid package entry")
        end
        versions[item.name] = item.version
    end
    return versions
end

function M.spec(package)
    if package.version and package.version ~= "" then
        return package.name .. "@" .. package.version
    end
    return package.name
end

function M.exec(command, spec)
    -- Record Node against the home directory, not the project where bootstrap ran.
    cmd.exec(command, {
        cwd = M.home(),
        env = { VP = M.binary(), SPEC = spec },
    })
end

return M
