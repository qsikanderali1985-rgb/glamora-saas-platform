const express = require('express');
const router = express.Router();
const admin = require('../config/firebase');
const User = require('../models/User');
const jwt = require('jsonwebtoken');

// Register/Login with Firebase
router.post('/login', async (req, res) => {
  try {
    const { firebaseToken, role } = req.body;

    // Verify Firebase token
    const decodedToken = await admin.auth().verifyIdToken(firebaseToken);
    const { uid, email, name, picture } = decodedToken;

    // Find or create user
    let user = await User.findOne({ where: { firebaseUid: uid } });
    
    if (!user) {
      user = await User.create({
        firebaseUid: uid,
        email: email || decodedToken.email,
        name: name || decodedToken.name || email.split('@')[0],
        photoUrl: picture,
        role: role || 'customer'
      });
    }

    // Generate JWT
    const token = jwt.sign(
      { userId: user.id, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
    );

    res.json({
      success: true,
      token,
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        role: user.role,
        photoUrl: user.photoUrl
      }
    });
  } catch (error) {
    res.status(401).json({ error: error.message });
  }
});

// Get current user
router.get('/me', async (req, res) => {
  try {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) {
      return res.status(401).json({ error: 'No token provided' });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const user = await User.findByPk(decoded.userId);

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json({ user });
  } catch (error) {
    res.status(401).json({ error: 'Invalid token' });
  }
});

module.exports = router;
