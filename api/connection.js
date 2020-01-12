const elasticsearch = require('elasticsearch')

// Core ES variables for this project
const index = 'bookworm.books'
const port = 9200
const host = process.env.ES_HOST || 'localhost'
const client = new elasticsearch.Client({ host: { host, port } })


module.exports = {
  client, index
}