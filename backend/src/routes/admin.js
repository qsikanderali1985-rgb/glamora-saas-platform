const express = require('express');
const router = express.Router();
const User = require('../models/User');
const Provider = require('../models/Provider');
const Booking = require('../models/Booking');

// Get dashboard statistics
router.get('/stats', async (req, res) => {
  try {
    const totalUsers = await User.count();
    const totalProviders = await Provider.count();
    const totalBookings = await Booking.count();
    const pendingApprovals = await Provider.count({ where: { status: 'pending' } });

    res.json({
      totalUsers,
      totalProviders,
      totalBookings,
      pendingApprovals
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
