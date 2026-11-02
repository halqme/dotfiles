local vp = require("vp")

function PLUGIN:PackageInstall(ctx)
    for _, package in ipairs(ctx.packages) do
        local spec = vp.spec(package)
        if ctx.dry_run then
            print("would install " .. spec)
        else
            vp.exec('"$VP" install -g "$SPEC"', spec)
        end
    end
end
