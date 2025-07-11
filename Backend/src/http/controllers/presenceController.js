const { Presence } = require('../../../config/associations');

exports.updatePresence = async (req, res) => {
    try {
        const userId = req.user.id;
        const { status } = req.body;

        // Validate status
        const validStatuses = ['online', 'offline'];
        if (!validStatuses.includes(status)) {
            return res.status(400).json({
                success: false,
                code: 37,
                message: 'Invalid status value',
                data: {
                    msg: 'Status must be either "online" or "offline"',
                    content: { received: status },
                },
            });
        }

        // Find or create the presence entry
        let presence = await Presence.findOne({ where: { userId } });

        if (!presence) {
            presence = await Presence.create({
                userId,
                status,
                lastLoginAt: status === 'online' ? new Date() : null,
            });
        } else {
            presence.status = status;
            if (status === 'online') {
                presence.lastLoginAt = new Date();
            }
            await presence.save();
        }

        return res.status(200).json({
            success: true,
            code: 38,
            message: 'Presence updated',
            data: {
                msg: 'User presence successfully updated',
                content: presence,
            },
        });
    } catch (error) {
        console.error('Error updating presence:', error);
        return res.status(500).json({
            success: false,
            code: 39,
            message: 'Internal server error',
            data: {
                msg: error.message,
                content: null,
            },
        });
    }
};
