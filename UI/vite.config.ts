import { defineConfig } from 'vite'
import elmPlug from 'vite-plugin-elm'
// TODO: check the plugin asset handeler 
export default defineConfig({
    plugins: [elmPlug({ debug: true, optimize: false })]
})