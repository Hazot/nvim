require("hazot.core")
require("hazot.lazy")

-- Monkey patch deprecated methods
local mt = getmetatable(vim.lsp.client)
if mt and mt.__index then
    if mt.__index.is_stopped then
        mt.__index.is_stopped = function(self, ...)
            return self:is_stopped(...)
        end
    end
    if mt.__index.supports_method then
        mt.__index.supports_method = function(self, ...)
            return self:supports_method(...)
        end
    end
end
