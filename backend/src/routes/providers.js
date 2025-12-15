const express = require('express');
const router = express.Router();
const Provider = require('../models/Provider');

// Get all providers
router.get('/', async (req, res) => {
  try {
    const { city, type, status } = req.query;
    const where = {};

    if (city) where.city = city;
    if (type) where.type = type;
    if (status) where.status = status;

    const providers = await Provider.findAll({ 
      where,
      order: [['rating', 'DESC']]
    });

    res.json({ providers });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Create provider
router.post('/', async (req, res) => {
  try {
    const provider = await Provider.create(req.body);
    res.status(201).json({ provider });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get provider by ID
router.get('/:id', async (req, res) => {
  try {
    const provider = await Provider.findByPk(req.params.id);
    if (!provider) {
      return res.status(404).json({ error: 'Provider not found' });
    }
    res.json({ provider });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Update provider
router.put('/:id', async (req, res) => {
  try {
    const provider = await Provider.findByPk(req.params.id);
    if (!provider) {
      return res.status(404).json({ error: 'Provider not found' });
    }

    await provider.update(req.body);
    res.json({ provider });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Approve/Reject provider (admin only)
router.put('/:id/approve', async (req, res) => {
  try {
    const { status } = req.body; // 'approved' or 'rejected'
    const provider = await Provider.findByPk(req.params.id);
    
    if (!provider) {
      return res.status(404).json({ error: 'Provider not found' });
    }

    await provider.update({ status });
    res.json({ 
      message: `Provider ${status} successfully`,
      provider 
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
