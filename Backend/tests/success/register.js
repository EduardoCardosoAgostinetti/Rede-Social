const axios = require('axios');
//require('dotenv').config({ path: '../../.env' });

const baseUrl = 'http://localhost:3000';

const usersToRegister = [
    {
        username: 'admin1',
        nickname: 'Admin One',
        email: 'admin1@example.com',
        password: 'password123',
    },
    {
        username: 'admin2',
        nickname: 'Admin Two',
        email: 'mod2@example.com',
        password: 'password123',
    },
    {
        username: 'admin3',
        nickname: 'Admin Three',
        email: 'user3@example.com',
        password: 'password123',
    },
    {
        username: 'admin4',
        nickname: 'Admin Four',
        email: 'guest4@example.com',
        password: 'password123',
    },
];

(async () => {
    for (const user of usersToRegister) {
        try {
            const response = await axios.post(`${baseUrl}/users/register`, user);
            const { id, username, email } = response.data.data.content;

            console.log(`✅ Usuário registrado: ${username}`);
            console.log(`   ID: ${id}`);
            console.log(`   Email: ${email}`);
            console.log('---');
        } catch (error) {
            const errData = error.response?.data;
            if (errData?.message === 'Email is already in use' || errData?.message === 'Username is already in use') {
                console.warn(`⚠️ Usuário já existe: ${user.email} (${user.username})`);
            } else {
                console.error(`❌ Erro ao registrar ${user.email}:`, errData || error.message);
            }
        }
    }
})();
