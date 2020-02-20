var express = require('express')
var app = express()
const product = 'Fake Product'
app.get('/', function (req, res) {
res.send(`Hello ${product}`)
})
app.listen(8080, function () {
console.log('app started on http://localhost:8080/')
})
