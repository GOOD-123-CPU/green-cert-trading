import js from '@eslint/js'
import pluginVue from 'eslint-plugin-vue'
import globals from 'globals'

export default [
  {
    ignores: ['dist/**', 'node_modules/**', '*.min.js'],
  },
  js.configs.recommended,
  ...pluginVue.configs['flat/essential'],
  {
    languageOptions: {
      ecmaVersion: 'latest',
      sourceType: 'module',
      globals: {
        ...globals.browser,
      },
    },
    rules: {
      // ---- 变量与作用域 ----
      'no-unused-vars': ['warn', { args: 'none', caughtErrors: 'none' }],
      'no-console': 'off', // 项目保留 console 用于调试定位
      'no-debugger': process.env.NODE_ENV === 'production' ? 'error' : 'warn',

      // ---- Vue 特定 ----
      'vue/multi-word-component-names': 'off', // 允许 Home.vue / Login.vue 等单词组件名
      'vue/no-unused-components': 'warn',
      'vue/no-v-html': 'off', // 富文本场景需要 v-html（已用 DOMPurify 消毒）
      'vue/require-default-prop': 'off',
      'vue/no-mutating-props': 'error',
    },
  },
]
