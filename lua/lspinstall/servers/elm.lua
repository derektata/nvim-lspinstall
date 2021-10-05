local config = require"lspinstall/util".extract_config("elmls")
config.default_config.cmd[1] = "./node_modules/.bin/elm-language-server"

-- we don't install these globally, their location will be resolved automatically form node_modules
config.default_config.init_options.elmPath = nil
config.default_config.init_options.elmFormatPath = nil
config.default_config.init_options.elmTestPath = nil

-- elm, elm-test and elm-format are also installed so they can be used instead of the local versions
-- in ./node_modules/.bin/ if needed. e.g. with
-- ```
-- init_options = {
--  elmPath = require'lspinstall/util'.install_path('elm') .. "/node_modules/.bin/elm"
--  elmFormatPath = require'lspinstall/util'.install_path('elm') .. "/node_modules/.bin/elm-format"
--  elmTestPath = require'lspinstall/util'.install_path('elm') .. "/node_modules/.bin/elm-test"
-- }
-- ```
return vim.tbl_extend('error', config, {
  install_script = [[

  YARN=/usr/bin/yarn
  NPM=/usr/bin/npm

  Yarn() {
    ! test -f package.json && yarn init -y --scope=lspinstall || true
    yarn add elm@latest elm-test@latest elm-format@latest @elm-tooling/elm-language-server@latest --ignore-engines
  }

  Npm() {
    ! test -f package.json && npm init -y --scope=lspinstall || true
    npm install elm@latest elm-test@latest elm-format@latest @elm-tooling/elm-language-server@latest
  }

  if [ ! -x $NPM ] && [ ! -x $YARN ]; then
    # if npm and yarn are not on the system
    printf "\nCan't find npm or yarn on the system\n"
  elif [ -x $NPM ] && [ -x $YARN ]; then
    # if npm and yarn are on the system
    printf "\nFound npm & yarn ... using yarn\n"
    Yarn
  elif [ ! -x $NPM ]; then
    # if npm is not on the system
    printf "\nNpm not found..."
    Yarn
  elif [ ! -x $YARN ]; then
    # if yarn is not on the system
    printf "\nYarn not found..."
    Npm
  fi

  ]]
})
