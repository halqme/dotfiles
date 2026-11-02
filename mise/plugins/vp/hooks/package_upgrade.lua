local vp = require("vp")

function PLUGIN:PackageUpgrade(ctx)
    for _, package in ipairs(ctx.packages) do
        if not package.version or package.version == "" then
            if ctx.dry_run then
                print("would update " .. package.name)
            else
                vp.exec('"$VP" update -g "$SPEC"', package.name)
            end
        end
    end
end
