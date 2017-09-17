const { dev_server: devServer } = require('../config')
const { NODE_ENV } = require('../env')

const isProduction = NODE_ENV === 'production'
const extractCSS = !(devServer && devServer.hmr)

module.exports = {
  test: /\.vue(\.erb)?$/,
  loader: 'vue-loader',
  options: {
    extractCSS: isProduction || extractCSS
  }
}
