const express = require('express');
require('dotenv').config();
const app = express();
const sequelize = require('../../config/db');
const cors = require('cors');
const path = require('path');

// Configuração recomendada:
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

const users = require('./routes/userRoute');
const codes = require('./routes/codeRoute');
const friendships = require('./routes/friendshipRoute');
const presence = require('./routes/presenceRoute');
const chats = require('./routes/chatRoute');
const uploads = require('./routes/uploadRoute');
const posts = require('./routes/feedRoute');

app.use(express.json());
app.use('/users', users);
app.use('/codes', codes);
app.use('/friendships', friendships);
app.use('/presence', presence);
app.use('/chats', chats);
app.use('/uploads', uploads);
app.use('/posts', posts);
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

function startHttpServer(port) {
  sequelize.sync({ force: true })
  .then(() => {
    console.log('Database synced successfully!');
    app.listen(port, () => {
      console.log(`Server running at http://localhost:${port}`);
    });
  })
  .catch(err => {
    console.error('Error syncing the database:', err);
  });
}

module.exports = { startHttpServer };
