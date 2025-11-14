const express = require('express');
const app = express();
const port = process.env.PORT || 3000;
app.get('/', (req, res) => res.send('Hello from DevOps Demo!'));
app.listen(port, () => console.log(`Demo app listening on ${port}`));
