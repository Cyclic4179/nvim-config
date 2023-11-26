local home = vim.fn.getenv('HOME')
local java17path = vim.fn.getenv('JAVA_SE_17')
local jdtls = require('jdtls')


-- The on_attach function is used to set key maps after the language server
-- attaches to the current buffer
local on_attach = function(client, bufnr)
    -- buffer mappings (not just for java), also present in ./lsp.lua
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    --vim.keymap.set({ 'i', 'n' }, '<C-h>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>f', function()
        vim.lsp.buf.format { async = true }
    end, opts)

    -- Java extensions provided by jdtls
    vim.keymap.set('n', '<C-o>', jdtls.organize_imports, opts)
    vim.keymap.set('n', '<leader>ev', jdtls.extract_variable, opts)
    vim.keymap.set('n', '<leader>ec', jdtls.extract_constant, opts)
    vim.keymap.set('v', '<leader>em', jdtls.extract_method, opts)
end

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    --cmd = {

    --    -- 💀
    --    'java', -- or '/path/to/java17_or_newer/bin/java'
    --    -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    --    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    --    '-Dosgi.bundles.defaultStartLevel=4',
    --    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    --    '-Dlog.protocol=true',
    --    '-Dlog.level=ALL',
    --    '-Xmx1g',
    --    '--add-modules=ALL-SYSTEM',
    --    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    --    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

    --    -- 💀
    --    '-jar', '/path/to/jdtls_install_location/plugins/org.eclipse.equinox.launcher_VERSION_NUMBER.jar',
    --    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
    --    -- Must point to the                                                     Change this to
    --    -- eclipse.jdt.ls installation                                           the actual version


    --    -- 💀
    --    '-configuration', '/path/to/jdtls_install_location/config_SYSTEM',
    --    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
    --    -- Must point to the                      Change to one of `linux`, `win` or `mac`
    --    -- eclipse.jdt.ls installation            Depending on your system.


    --    -- 💀
    --    -- See `data directory configuration` section in the README
    --    '-data', '/path/to/unique/per/project/workspace/folder'
    --},

    cmd = { "jdt-language-server", "-data", home .. "/.cache/jdtls/workspace" },
    --root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
    --root_dir = function(fname)
    --    return require("lspconfig").util.root_pattern("pom.xml", "gradle.build", ".git")(fname) or vim.fn.getcwd()
    --end,

    -- 💀
    -- This is the default if not provided, you can remove it. Or adjust as needed.
    -- One dedicated LSP server & client will be started per unique root_dir
    --root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
        java = {
            configuration = {
                runtimes = {
                    {
                        name = "JavaSE-17",
                        path = java17path
                    }
                }
            }
        }
    },

    -- Language server `initializationOptions`
    -- You need to extend the `bundles` with paths to jar files
    -- if you want to use additional eclipse.jdt.ls plugins.
    --
    -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
    --
    -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
    --init_options = {
    --    bundles = {}
    --},
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
jdtls.start_or_attach(config)
