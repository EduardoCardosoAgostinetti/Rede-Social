const WebSocket = require('ws');
const jwt = require('jsonwebtoken');
const Presence = require('../../config/models/presenceModel');
require('dotenv').config();

let wss;

function startWebSocketServer(port = 8080) {
  return new Promise((resolve) => {
    wss = new WebSocket.Server({ port });

    wss.on('listening', () => {
      console.log(`WebSocket server running on port ${port}`);
      resolve();
    });

    wss.on('connection', (ws, req) => {
      const clientIP = req.socket.remoteAddress;
      console.log(`Client connected: ${clientIP}`);

      ws.once('message', async (token) => {
        try {
          const decoded = jwt.verify(token.toString(), process.env.JWT_SECRET);
          const userId = decoded.id;

          ws.userId = userId; // ✅ armazena o userId no socket

          console.log(`Authenticated user: ${userId}`);

          await Presence.upsert({
            userId,
            status: 'online',
            lastLoginAt: new Date(),
          });

          const statusUpdate = JSON.stringify({
            type: 'presence_update',
            userId,
            status: 'online',
            lastLoginAt: new Date(),
          });

          wss.clients.forEach((client) => {
            if (client.readyState === WebSocket.OPEN) {
              client.send(statusUpdate);
            }
          });
        } catch (err) {
          console.error('Invalid token:', err.message);
          ws.close();
        }
      });

      ws.on('close', async () => {
        console.log(`Client disconnected: ${clientIP}`);
        if (ws.userId) {
          await Presence.update(
            { status: 'offline' },
            { where: { userId: ws.userId } }
          );

          const statusUpdate = JSON.stringify({
            type: 'presence_update',
            userId: ws.userId,
            status: 'offline',
          });

          wss.clients.forEach((client) => {
            if (client.readyState === WebSocket.OPEN) {
              client.send(statusUpdate);
            }
          });
        }
      });
    });
  });
}

function getWss() {
  return wss;
}

module.exports = { startWebSocketServer, getWss };
