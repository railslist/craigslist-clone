const express = require('express');
const mainRoutes = require('./main');

const router = express.Router();

router.use('/', mainRoutes);

// About page route.
router.get('/about', function (req, res) {
  res.send('About this wiki');
});

module.exports = router;
