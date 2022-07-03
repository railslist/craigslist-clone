const express = require('express');
const routes = require('./routes');

const app = express();
const port = process.env.PORT || 3000;

app.set('view engine', 'ejs');

app.use(express.static('public'));
app.use('/', routes);

app.listen(port, () => {
  console.log(`App listening on port ${port}`);
});
