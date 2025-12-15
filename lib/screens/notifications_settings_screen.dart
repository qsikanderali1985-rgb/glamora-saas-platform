import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  // Notification toggles
  bool _pushNotifications = true;
  bool _bookingReminders = true;
  bool _promotions = true;
  bool _newMessages = true;
  bool _providerUpdates = true;
  bool _emailNotifications = false;
  bool _smsNotifications = false;
  
  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }
  
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotifications = prefs.getBool('notif_push') ?? true;
      _bookingReminders = prefs.getBool('notif_bookings') ?? true;
      _promotions = prefs.getBool('notif_promotions') ?? true;
      _newMessages = prefs.getBool('notif_messages') ?? true;
      _providerUpdates = prefs.getBool('notif_provider') ?? true;
      _emailNotifications = prefs.getBool('notif_email') ?? false;
      _smsNotifications = prefs.getBool('notif_sms') ?? false;
    });
  }
  
  Future<void> _savePreference(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050509),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF8D7C4), Color(0xFFA855F7)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.notifications_active, size: 40, color: Colors.white),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notification Preferences',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Customize your notification experience',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Push Notifications Section
            const Text(
              'Push Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            
            _buildToggleOption(
              icon: Icons.notifications,
              title: 'Push Notifications',
              subtitle: 'Enable all push notifications',
              value: _pushNotifications,
              onChanged: (value) {
                setState(() => _pushNotifications = value);
                _savePreference('notif_push', value);
              },
            ),
            
            _buildToggleOption(
              icon: Icons.calendar_today,
              title: 'Booking Reminders',
              subtitle: '24h before your appointment',
              value: _bookingReminders,
              onChanged: (value) {
                setState(() => _bookingReminders = value);
                _savePreference('notif_bookings', value);
              },
            ),
            
            _buildToggleOption(
              icon: Icons.message,
              title: 'New Messages',
              subtitle: 'Get notified of new chat messages',
              value: _newMessages,
              onChanged: (value) {
                setState(() => _newMessages = value);
                _savePreference('notif_messages', value);
              },
            ),
            
            _buildToggleOption(
              icon: Icons.store,
              title: 'Provider Updates',
              subtitle: 'Status changes, new services',
              value: _providerUpdates,
              onChanged: (value) {
                setState(() => _providerUpdates = value);
                _savePreference('notif_provider', value);
              },
            ),
            
            _buildToggleOption(
              icon: Icons.local_offer,
              title: 'Promotions & Offers',
              subtitle: 'Special deals and discounts',
              value: _promotions,
              onChanged: (value) {
                setState(() => _promotions = value);
                _savePreference('notif_promotions', value);
              },
            ),
            
            const SizedBox(height: 32),
            
            // Other Channels
            const Text(
              'Other Channels',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            
            _buildToggleOption(
              icon: Icons.email,
              title: 'Email Notifications',
              subtitle: 'Receive updates via email',
              value: _emailNotifications,
              onChanged: (value) {
                setState(() => _emailNotifications = value);
                _savePreference('notif_email', value);
              },
            ),
            
            _buildToggleOption(
              icon: Icons.sms,
              title: 'SMS Notifications',
              subtitle: 'Important updates via SMS',
              value: _smsNotifications,
              onChanged: (value) {
                setState(() => _smsNotifications = value);
                _savePreference('notif_sms', value);
              },
            ),
            
            const SizedBox(height: 32),
            
            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.blue.withValues(alpha: 0.3),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'You can change these settings anytime. We respect your preferences and only send relevant updates.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildToggleOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8D7C4).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFFF8D7C4), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFFA855F7),
            activeTrackColor: const Color(0xFFA855F7).withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}
