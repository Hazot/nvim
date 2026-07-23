require("hazot.core")
require("hazot.lazy")

-- Create an autocmd that runs very early
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        -- Filter out specific deprecation warnings
        local notify = vim.notify
        vim.notify = function(msg, level, opts)
            -- Suppress copilot-cmp and lspsaga deprecation warnings
            if type(msg) == "string" then
                if msg:match("client%.supports_method") then
                    return
                end
            end
            notify(msg, level, opts)
        end
    end,
})
