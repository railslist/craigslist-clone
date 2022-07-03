const express = require('express');
const router = express.Router();

const data = {
  city: 'Orlando',
  state: 'FL',
};

router.use((req, res, next) => {
  res.data = data;
  next();
});

router.get('/', (req, res) => {
  res.render('main', res.data);
});

module.exports = router;
