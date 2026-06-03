return {
  {
    "mfussenegger/nvim-jdtls",
    opts = {
      settings = {
        java = {
          configuration = {
            updateBuildConfiguration = "interactive",
          },
          completion = {
            favoriteStaticMembers = {
              "org.assertj.core.api.Assertions.assertThat",
              "org.junit.jupiter.api.Assertions.*",
              "org.mockito.Mockito.*",
            },
          },
          import = {
            gradle = { enabled = true },
            maven = { enabled = true },
          },
          inlayHints = {
            parameterNames = { enabled = "all" },
          },
          saveActions = {
            organizeImports = true,
          },
        },
      },
    },
  },

  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "jdtls",
        "java-debug-adapter",
        "java-test",
      },
    },
  },
}
