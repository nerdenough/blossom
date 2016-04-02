express = require 'express'
router = express.Router()

router.get '/', (req, res) ->
  res.render 'index',
    title: 'Blossom'
    config: req.config

module.exports = router
