
# 📱 Social MVP – Rede Social com Flutter & Node.js

> Projeto MVP de uma rede social com funcionalidades de autenticação, amizades, feed, chat em tempo real e muito mais.

---

## 📌 Sobre o Projeto

Este é um projeto MVP (Produto Mínimo Viável) de uma rede social, desenvolvido com **Flutter** no frontend e **Node.js** no backend. Ele possui funcionalidades básicas de redes sociais, como login, registro, gerenciamento de perfil, amizade, chat privado via WebSocket, feed de postagens com imagem e presença online.

---

## 🚀 Tecnologias Utilizadas

### 📱 Frontend (Flutter)

- Flutter SDK ^3.8.1
- `http` – Requisições REST
- `shared_preferences` – Armazenamento local
- `provider` – Gerenciamento de estado
- `go_router` – Navegação declarativa
- `web_socket_channel` – Comunicação em tempo real
- `image_picker` – Seleção de imagens
- `jwt_decoder` – Decodificação de token JWT
- Internacionalização (`flutter_localizations`, `flutter_gen`)
- `http_parser`, `path`, `cupertino_icons`

### 🌐 Backend (Node.js + Express)

- `express` – Framework web
- `sequelize` + `pg` – ORM com PostgreSQL
- `jsonwebtoken` – Autenticação JWT
- `bcryptjs` – Criptografia de senhas
- `multer` – Upload de arquivos
- `sharp` – Redimensionamento de imagem
- `nodemailer` – E-mail para recuperação de senha
- `ws` – WebSocket nativo
- `dotenv`, `cors`, `uuid`, `express-validator`

---

## 🧪 Funcionalidades

### Autenticação e Usuário
- Registro de usuário
- Login com JWT
- Alteração de nickname, username e senha
- Upload de foto de perfil
- Recuperação de senha via código

### Amizades
- Procurar usuários por nickname
- Enviar, aceitar ou rejeitar solicitações de amizade
- Listar amigos adicionados e solicitações pendentes

### Feed
- Criar postagens com imagem
- Visualizar feed de postagens

### Chat Privado
- Chat privado entre amigos
- Envio e recebimento de mensagens em tempo real via WebSocket

### Presença Online
- Atualização de status online/offline em tempo real

---

## 📂 Estrutura de Rotas Backend (Node.js)

| Recurso        | Método | Rota                                         | Descrição                                     |
|----------------|--------|----------------------------------------------|-----------------------------------------------|
| Auth           | POST   | `/users/register`                            | Registro de novo usuário                      |
|                | POST   | `/users/login`                               | Login do usuário                              |
|                | PUT    | `/users/nickname`                            | Alterar nickname                              |
|                | PUT    | `/users/username`                            | Alterar username                              |
|                | PUT    | `/users/password`                            | Alterar senha                                 |
| Upload         | POST   | `/uploads/uploadProfilePhoto`                | Upload de foto de perfil                      |
| Amizades       | GET    | `/friendships/getFriends`                    | Listar amigos                                 |
|                | GET    | `/friendships/searchByNickname/:nickname`    | Buscar por nickname                           |
|                | POST   | `/friendships/sendFriendRequest`             | Enviar solicitação                            |
|                | GET    | `/friendships/getPendingFriendRequests`      | Solicitações recebidas                        |
|                | POST   | `/friendships/respondToFriendRequest`        | Aceitar ou recusar solicitação                |
|                | GET    | `/friendships/getSentPendingFriendRequests`  | Solicitações enviadas                         |
| Feed           | POST   | `/posts/post`                                | Criar postagem com imagem                     |
|                | GET    | `/posts/feed`                                | Ver feed de postagens                         |
| Chat           | GET    | `/chats/me`                                  | Listar chats do usuário                       |
|                | GET    | `/chats/private/:friendId`                   | Criar ou acessar chat privado                 |
|                | GET    | `/chats/:chatId/messages`                    | Ver mensagens do chat                         |
|                | POST   | `/chats/:chatId/messages`                    | Enviar mensagem                               |
| Código         | POST   | `/codes/request`                             | Solicitar código de recuperação               |
|                | POST   | `/codes/verify`                              | Verificar código de recuperação               |
|                | POST   | `/codes/resetPass`                           | Redefinir senha                               |
| Presença       | PUT    | `/presence/updatePresence`                   | Atualizar status online/offline               |

---

## ⚙️ Instalação e Execução

### 1. Clone o repositório

```bash
git clone https://github.com/seu-usuario/seu-repo.git
cd seu-repo
```

### 2. Backend (Node.js)

```bash
cd backend
npm install
npm run dev
```

### 3. Frontend (Flutter)

```bash
cd app
flutter pub get
flutter run -d edge
```

---

## 📡 Comunicação em Tempo Real

- O app utiliza `web_socket_channel` (Flutter) e `ws` (Node.js) para chat privado.
- A presença online é sincronizada automaticamente com atualização via WebSocket.

---

## 📁 Estrutura Básica

```
/app               # Flutter (Frontend)
  └── lib/
      └── pages/
      └── services/
      └── l10n/
      └── main.dart

/backend           # Node.js (Backend)
  └── routes/
  └── controllers/
  └── models/
  └── config/
  └── servers.js
```

---

## ✅ Testes Automatizados

Rodar todos os testes:

```bash
npm run tests
```

---

## 🛡️ Autenticação

Todas as rotas protegidas utilizam middleware JWT. O token é armazenado no app Flutter usando `SharedPreferences` e enviado via `Authorization` nos headers.

---

## 📄 Licença

Este projeto é privado/MVP.
