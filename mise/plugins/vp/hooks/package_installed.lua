local vp = require("vp")

function PLUGIN:PackageInstalled(ctx)
    local installed = vp.installed()
    local results = {}
    for _, package in ipairs(ctx.packages) do
        local version = installed[package.name]
        if version then
            table.insert(results, {
                name = package.name,
                state = "installed",
                version = version,
            })
        else
            table.insert(results, { name = package.name, state = "missing" })
        end
    end
    return { packages = results }
end
