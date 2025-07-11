const axios = require('axios');

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

const statuses = ['offline'];

function getRandomStatus() {
    return statuses[Math.floor(Math.random() * statuses.length)];
}

(async () => {
    for (const user of users) {
        try {
            // 2. Login
            const loginResponse = await axios.post(`${baseUrl}/users/login`, {
                username: user.username,
                password: user.password,
            });

            const token = loginResponse.data.data.content.token;
            const { id, username } = loginResponse.data.data.content.user;

            console.log(`✅ Logged in: ${username} (${id})`);

            // 3. Update presence
            const status = getRandomStatus();
            const presenceResponse = await axios.put(
                `${baseUrl}/presence/updatePresence`,
                { status },
                {
                    headers: {
                        Authorization: `Bearer ${token}`,
                    },
                }
            );

            console.log(`   → Presence set to: ${status}`);
            console.log(`   Response:`, presenceResponse.data);
            console.log('---');

        } catch (error) {
            console.error(`❌ Error for ${user.email}:`, error.response?.data || error.message);
        }
    }
})();
