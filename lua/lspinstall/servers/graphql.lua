local config = require"lspinstall/util".extract_config("graphql")
config.default_config.cmd[1] = "./node_modules/.bin/graphql-lsp"

-- specify the path from where to look for the graphql config
config.default_config.on_new_config = function(new_config, new_root_dir)
  local new_cmd = vim.deepcopy(config.default_config.cmd)
  table.insert(new_cmd, '-c')
  table.insert(new_cmd, new_root_dir)
  new_config.cmd = new_cmd
end

return vim.tbl_extend('error', config, {
  install_script = [[

  if command -v yarn 2>/dev/null; then
    # yarn was found
    printf "\nfound yarn\n"
    ! test -f package.json && yarn init -y --scope=lspinstall || true
    yarn add graphql-language-service-cli@latest --ignore-engines
  else
    # yarn was not found
    printf "\ncannot find yarn\n"
    ! test -f package.json && npm init -y --scope=lspinstall || true
    npm install graphql-language-service-cli@latest
  fi

  ]]
})
