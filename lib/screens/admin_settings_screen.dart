import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  double _commissionRate = 15.0;
  int _minBookingTime = 30;
  int _maxCancellationHours = 24;
  bool _autoApproveProviders = false;
  bool _maintenanceMode = false;
  
  final TextEditingController _supportEmailController = TextEditingController(text: 'support@glamora.com');
  final TextEditingController _supportPhoneController = TextEditingController(text: '+92-300-1234567');

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _commissionRate = prefs.getDouble('admin_commission_rate') ?? 15.0;
      _minBookingTime = prefs.getInt('admin_min_booking_time') ?? 30;
      _maxCancellationHours = prefs.getInt('admin_max_cancellation_hours') ?? 24;
      _autoApproveProviders = prefs.getBool('admin_auto_approve') ?? false;
      _maintenanceMode = prefs.getBool('admin_maintenance_mode') ?? false;
    });
  }
  
  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050509),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        title: const Text('App Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Business Settings
            const Text(
              'Business Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildSliderSetting(
              icon: Icons.percent,
              title: 'Commission Rate',
              subtitle: '${_commissionRate.toStringAsFixed(1)}% per booking',
              value: _commissionRate,
              min: 5.0,
              max: 30.0,
              divisions: 50,
              onChanged: (value) {
                setState(() {
                  _commissionRate = value;
                });
                _saveSetting('admin_commission_rate', value);
              },
            ),
            
            _buildSliderSetting(
              icon: Icons.timer,
              title: 'Minimum Booking Time',
              subtitle: '$_minBookingTime minutes advance notice',
              value: _minBookingTime.toDouble(),
              min: 15,
              max: 120,
              divisions: 21,
              onChanged: (value) {
                setState(() {
                  _minBookingTime = value.toInt();
                });
                _saveSetting('admin_min_booking_time', value.toInt());
              },
            ),
            
            _buildSliderSetting(
              icon: Icons.cancel_schedule_send,
              title: 'Cancellation Window',
              subtitle: '$_maxCancellationHours hours before booking',
              value: _maxCancellationHours.toDouble(),
              min: 1,
              max: 72,
              divisions: 71,
              onChanged: (value) {
                setState(() {
                  _maxCancellationHours = value.toInt();
                });
                _saveSetting('admin_max_cancellation_hours', value.toInt());
              },
            ),
            
            const SizedBox(height: 32),
            
            // Provider Settings
            const Text(
              'Provider Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildToggleSetting(
              icon: Icons.verified,
              title: 'Auto-Approve Providers',
              subtitle: 'Automatically approve new provider registrations',
              value: _autoApproveProviders,
              onChanged: (value) {
                setState(() {
                  _autoApproveProviders = value;
                });
                _saveSetting('admin_auto_approve', value);
              },
            ),
            
            const SizedBox(height: 32),
            
            // App Control
            const Text(
              'App Control',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildToggleSetting(
              icon: Icons.build,
              title: 'Maintenance Mode',
              subtitle: 'Put app in maintenance mode (users can\'t book)',
              value: _maintenanceMode,
              onChanged: (value) {
                setState(() {
                  _maintenanceMode = value;
                });
                _saveSetting('admin_maintenance_mode', value);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(value
                        ? 'App is now in maintenance mode'
                        : 'App is now live'),
                    backgroundColor: value ? Colors.orange : const Color(0xFF34A853),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 32),
            
            // Contact Information
            const Text(
              'Support Contact',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _supportEmailController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Support Email',
                labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                prefixIcon: const Icon(Icons.email, color: Color(0xFFA855F7)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            TextField(
              controller: _supportPhoneController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Support Phone',
                labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                prefixIcon: const Icon(Icons.phone, color: Color(0xFFA855F7)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Contact information updated'),
                      backgroundColor: Color(0xFF34A853),
                    ),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text('Save Contact Info'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA855F7),
                  padding: const EdgeInsets.all(16),
                ),
              ),
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
                      'Changes to commission rate and booking time will apply to new bookings only.',
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
  
  Widget _buildSliderSetting({
    required IconData icon,
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFA855F7), size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: const Color(0xFFA855F7),
            inactiveColor: Colors.white.withValues(alpha: 0.2),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
  
  Widget _buildToggleSetting({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          Icon(icon, color: const Color(0xFFA855F7), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
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
