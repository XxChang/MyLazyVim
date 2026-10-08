return {
  {
    "mrcjkb/rustaceanvim",
    opts = function(_, opts)
      opts.server = opts.server or {}
      local old_on_init = opts.server.on_init

      opts.server.on_init = function(client, init_result)
        -- 如果工作区根目录存在 rust-project.json，切换到 rust-project 模式
        local root = client.config.root_dir or vim.fn.getcwd()
        local rust_project = root .. "/rust-project.json"
        if vim.fn.filereadable(rust_project) == 1 then
          client.config.settings = vim.tbl_deep_extend("force", client.config.settings or {}, {
            ["rust-analyzer"] = {
              linkedProjects = { rust_project },
            },
          })
          client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        end

        if old_on_init then
          old_on_init(client, init_result)
        end
      end

      return opts
    end,
  },
}
