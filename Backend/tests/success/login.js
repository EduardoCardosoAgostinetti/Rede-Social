const axios = require('axios');
//require('dotenv').config({ path: '../../.env' });

const baseUrl = 'http://localhost:3000';

const users = [
    {
        username: 'admin1',
        nickname: 'Admin One',
        email: 'admin1@example.com',
        password: '123456',
    },
    {
        username: 'admin2',
        nickname: 'Admin Two',
        email: 'mod2@example.com',
        password: '123456',
    },
    {
        username: 'admin3',
        nickname: 'Admin Three',
        email: 'user3@example.com',
        password: '123456',
    },
    {
        username: 'admin4',
        nickname: 'Admin Four',
        email: 'guest4@example.com',
        password: '123456',
    },
];

(async () => {
    for (const user of users) {

        try {
            const loginRes = await axios.post(`${baseUrl}/users/login`, {
                username: user.username,
                password: user.password,
            });

            const { id, username } = loginRes.data.data.content.user;
            const token = loginRes.data.data.content.token;

            console.log(`✅ Login bem-sucedido: ${username}`);
            console.log(`   UUID: ${id}`);
            console.log(`   Token: ${token}`);
            console.log('---');
        } catch (loginErr) {
            console.error(`❌ Erro ao logar com ${user.email}:`, loginErr.response?.data || loginErr.message);
        }

    }
})();
