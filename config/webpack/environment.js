const { environment } = require('@rails/webpacker')

Webpacker::Compiler.env['RAILS_ENV'] = 'abc123'

module.exports = environment
