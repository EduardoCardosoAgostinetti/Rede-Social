const User = require('./models/userModel');
const Friendship = require('./models/friendshipModel');
const Code = require('./models/codeModel');
const Presence = require('./models/presenceModel');
const {Chat, Message} = require('./models/chatModel');
const Post = require('./models/postModel');

//User
User.hasMany(Friendship, { foreignKey: 'requesterId', as: 'requestedFriends' });
User.hasMany(Friendship, { foreignKey: 'receiverId', as: 'receivedFriends' });
User.hasMany(Code, { foreignKey: 'userId' });

//Friendship
Friendship.belongsTo(User, { foreignKey: 'requesterId', as: 'requester' });
Friendship.belongsTo(User, { foreignKey: 'receiverId', as: 'receiver' });

//Code
Code.belongsTo(User, { foreignKey: 'userId', onDelete: 'CASCADE' });

// Presence
User.hasOne(Presence, { foreignKey: 'userId', as: 'presence' });
Presence.belongsTo(User, { foreignKey: 'userId', as: 'user' });

// Cada chat pertence a dois usuários (user1 e user2)
Chat.belongsTo(User, { foreignKey: 'user1Id', as: 'user1' });
Chat.belongsTo(User, { foreignKey: 'user2Id', as: 'user2' });

// Usuário tem muitas conversas onde ele é user1
User.hasMany(Chat, { foreignKey: 'user1Id', as: 'chatsAsUser1' });

// Usuário tem muitas conversas onde ele é user2
User.hasMany(Chat, { foreignKey: 'user2Id', as: 'chatsAsUser2' });

// Chat tem muitas mensagens
Chat.hasMany(Message, { foreignKey: 'chatId', as: 'messages' });
Message.belongsTo(Chat, { foreignKey: 'chatId' });

// Mensagem tem um remetente (usuário)
User.hasMany(Message, { foreignKey: 'senderId', as: 'sentMessages' });
Message.belongsTo(User, { foreignKey: 'senderId', as: 'sender' });

User.hasMany(Post, { foreignKey: 'userId' });
Post.belongsTo(User, { foreignKey: 'userId' });


module.exports = { User, Friendship, Code, Presence, Chat, Message, Post };