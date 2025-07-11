const axios = require('axios');

const baseUrl = 'http://localhost:3000/codes';

const usersToTest = [
  {
        username: 'admin1',
        nickname: 'Admin One',
        email: 'admin1@example.com',
        password: 'password123',
        newPassword:'123456'
    },
    {
        username: 'admin2',
        nickname: 'Admin Two',
        email: 'mod2@example.com',
        password: 'password123',
        newPassword:'123456'
    },
    {
        username: 'admin3',
        nickname: 'Admin Three',
        email: 'user3@example.com',
        password: 'password123',
        newPassword:'123456'
    },
    {
        username: 'admin4',
        nickname: 'Admin Four',
        email: 'guest4@example.com',
        password: 'password123',
        newPassword:'123456'
    },
];

(async () => {
  for (const user of usersToTest) {
    console.log(`🔄 Testando para: ${user.email}`);

    try {
      // 1️⃣ Request reset code
      console.log('📨 Solicitando código...');
      const requestRes = await axios.post(`${baseUrl}/request`, { email: user.email });
      const code = requestRes.data.data.content.code; // ⚠️ Remova do JSON em produção

      console.log(`✅ Código recebido: ${code}`);

      // 2️⃣ Verificar código
      console.log('🔍 Verificando código...');
      await axios.post(`${baseUrl}/verify`, {
        email: user.email,
        code,
      });
      console.log('✅ Código verificado com sucesso.');

      // 3️⃣ Resetar senha
      console.log('🔒 Redefinindo senha...');
      await axios.post(`${baseUrl}/resetPass`, {
        email: user.email,
        code,
        newPassword: user.newPassword,
      });
      console.log('✅ Senha redefinida com sucesso.\n');

    } catch (error) {
      const errData = error.response?.data;
      console.error(`❌ Erro com ${user.email}:`, errData?.message || error.message);
      if (errData?.data?.msg) {
        console.error('↳ Detalhe:', errData.data.msg);
      }
      console.log('---\n');
    }
  }
})();
