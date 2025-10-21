require("hazot.core")
require("hazot.lazy")

-- Monkey patch to hide deprecation warnings"
do
    local notify = vim.notify
    vim.notify = function(msg, level, opts)
        if type(msg) == "string" and msg:match("client%.is_stopped is deprecated") then
            return
        end
        return notify(msg, level, opts)
    end
end

do
    local notify = vim.notify
    vim.notify = function(msg, level, opts)
        if type(msg) == "string" and msg:match("client%.supports_method is deprecated") then
            return
        end
        return notify(msg, level, opts)
    end
end

-- Create an autocmd that runs very early
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        -- Filter out specific deprecation warnings
        local notify = vim.notify
        vim.notify = function(msg, level, opts)
            -- Suppress copilot-cmp and lspsaga deprecation warnings
            if type(msg) == "string" then
                if msg:match("client%.is_stopped") or msg:match("client%.supports_method") then
                    return
                end
            end
            notify(msg, level, opts)
        end
    end,
})
