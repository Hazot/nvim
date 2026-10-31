local M = {}

-- Prefer the project's .venv ruff, then $PATH, then uv's ~/.local/bin/ruff.
function M.ruff_bin(root)
    local venv_ruff = root and vim.fs.joinpath(root, ".venv/bin/ruff")
    if venv_ruff and vim.fn.executable(venv_ruff) == 1 then
        return venv_ruff
    end
    local from_path = vim.fn.exepath("ruff")
    if from_path ~= "" then
        return from_path
    end
    local uv_ruff = vim.fs.joinpath(vim.env.HOME, ".local/bin/ruff")
    return vim.fn.executable(uv_ruff) == 1 and uv_ruff or "ruff"
end

return M
