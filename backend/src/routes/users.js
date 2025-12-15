const express = require('express');
const router = express.Router();
const User = require('../models/User');

// Get all users (admin only)
router.get('/', async (req, res) => {
  try {
    const { status, role, search } = req.query;
    const where = {};

    if (status) where.status = status;
    if (role) where.role = role;
    
    const users = await User.findAll({ where });
    res.json({ users });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get user by ID
router.get('/:id', async (req, res) => {
  try {
    const user = await User.findByPk(req.params.id);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    res.json({ user });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Update user
router.put('/:id', async (req, res) => {
  try {
    const user = await User.findByPk(req.params.id);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    await user.update(req.body);
    res.json({ user });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Block/Unblock user (admin only)
router.put('/:id/block', async (req, res) => {
  try {
    const user = await User.findByPk(req.params.id);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    const newStatus = user.status === 'active' ? 'blocked' : 'active';
    await user.update({ status: newStatus });

    res.json({ 
      message: `User ${newStatus === 'blocked' ? 'blocked' : 'unblocked'} successfully`,
      user 
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
