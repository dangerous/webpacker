const { resolve } = require('path')
const { existsSync } = require('fs')
const dotEnv = require('dotenv')

const NODE_ENV = process.env.NODE_ENV || 'development'
const WEBPACKER_ENV_REGEX = /^WEBPACKER_/i

const isBoolean = str => /^true/.test(str) || /^false/.test(str)

const fetch = key => process.env[key]

const envFiles = [
  `env.${NODE_ENV}.local`,
  `env.${NODE_ENV}`,
  NODE_ENV !== 'test' && 'env.local',
  '.env'
].filter(Boolean)

envFiles.forEach((envFile) => {
  const envFilePath = resolve(process.cwd(), envFile)

  if (existsSync(envFilePath)) {
    dotEnv.config({
      path: envFilePath
    })
  }
})

const env = Object.keys(JSON.parse(JSON.stringify(process.env)))
  .filter(key => WEBPACKER_ENV_REGEX.test(key))
  .reduce((processEnv, key) => {
    /* eslint no-param-reassign: 0 */
    processEnv[key] = isBoolean(fetch(key)) ? JSON.parse(fetch(key)) : fetch(key)
    return processEnv
  }, {
    NODE_ENV
  }
)

module.exports = env
