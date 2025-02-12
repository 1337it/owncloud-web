module.exports = {
  env: {
    browser: true,
    es6: true,
    amd: true
  },
  extends: [
    'standard',
    'prettier/standard',
    'plugin:prettier/recommended',
    'plugin:jest/recommended'
  ],
  parser: 'vue-eslint-parser',
  parserOptions: {
    parser: {
      "js": "@babel/eslint-parser",
      "ts": "@typescript-eslint/parser",
    },
    requireConfigFile: false,
    sourceType: 'module'
  },
  rules: {
    /**
     * TODO: fix project import issues and then enable it
     * 'sort-imports': 'warn',
     */
    'require-await': 'warn',
    'no-new': 'off',
    'jest/no-standalone-expect': 'off',
    'node/no-callback-literal': 'off',
    'unused-imports/no-unused-imports': 'error'
  },
  globals: {
    require: false,
    requirejs: false
  },
  plugins: ['jest', 'unused-imports'],
  ignorePatterns: ['packages/web-integration-oc10/js'],
  overrides: [
    {
      files: ['**/*.vue'],
      extends: ['plugin:vue/recommended', 'prettier/vue']
    },
    {
      files: ['**/*.ts'],
      parser: '@typescript-eslint/parser',
      extends: ['plugin:@typescript-eslint/recommended'],
      rules: {
        '@typescript-eslint/no-extra-semi': 'off',
        '@typescript-eslint/no-explicit-any': 'off'
      }
    }
  ]
}
