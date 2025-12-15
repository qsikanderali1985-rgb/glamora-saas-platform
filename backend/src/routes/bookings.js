const express = require('express');
const router = express.Router();
const Booking = require('../models/Booking');

// Create booking
router.post('/', async (req, res) => {
  try {
    const bookingNumber = 'BK' + Date.now();
    const booking = await Booking.create({
      ...req.body,
      bookingNumber
    });

    res.status(201).json({ booking });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get all bookings
router.get('/', async (req, res) => {
  try {
    const { userId, providerId, status } = req.query;
    const where = {};

    if (userId) where.userId = userId;
    if (providerId) where.providerId = providerId;
    if (status) where.status = status;

    const bookings = await Booking.findAll({ 
      where,
      order: [['createdAt', 'DESC']]
    });

    res.json({ bookings });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get booking by ID
router.get('/:id', async (req, res) => {
  try {
    const booking = await Booking.findByPk(req.params.id);
    if (!booking) {
      return res.status(404).json({ error: 'Booking not found' });
    }
    res.json({ booking });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Update booking status
router.put('/:id/status', async (req, res) => {
  try {
    const { status } = req.body;
    const booking = await Booking.findByPk(req.params.id);
    
    if (!booking) {
      return res.status(404).json({ error: 'Booking not found' });
    }

    await booking.update({ status });
    res.json({ booking });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Cancel booking
router.delete('/:id', async (req, res) => {
  try {
    const { reason, cancelledBy } = req.body;
    const booking = await Booking.findByPk(req.params.id);
    
    if (!booking) {
      return res.status(404).json({ error: 'Booking not found' });
    }

    await booking.update({ 
      status: 'cancelled',
      cancelReason: reason,
      cancelledBy
    });

    res.json({ message: 'Booking cancelled successfully', booking });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
