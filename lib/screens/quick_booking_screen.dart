import 'package:flutter/material.dart';

import 'booking_confirmation_screen.dart';

class QuickBookingScreen extends StatefulWidget {
  const QuickBookingScreen({super.key});

  @override
  State<QuickBookingScreen> createState() => _QuickBookingScreenState();
}

class _QuickBookingScreenState extends State<QuickBookingScreen> {
  final TextEditingController _serviceController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  bool _isLoading = false;
  bool _showResults = false;

  // Mock booking results
  final List<Map<String, dynamic>> _bookingSlots = [
    {
      'time': 'Today, 3:00 PM',
      'stylist': 'Aisha Khan',
      'rating': 4.8,
      'price': 'PKR 2,400',
      'duration': '45 mins',
      'waitTime': 'No wait',
    },
    {
      'time': 'Today, 4:30 PM',
      'stylist': 'Omar Farooq',
      'rating': 4.9,
      'price': 'PKR 2,100',
      'duration': '30 mins',
      'waitTime': '15 min wait',
    },
    {
      'time': 'Tomorrow, 11:00 AM',
      'stylist': 'Zara Malik',
      'rating': 4.7,
      'price': 'PKR 2,800',
      'duration': '60 mins',
      'waitTime': 'No wait',
    },
  ];

  void _findSlots() async {
    if (_serviceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a service type')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate AI processing delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _showResults = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Booking'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tell us what you want, and we\'ll find you the best time, stylist, and price automatically.',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _serviceController,
              decoration: InputDecoration(
                labelText: 'Service type (e.g. Haircut, Makeup)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(
                labelText: 'Preferred time (optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'AI will suggest the shortest wait time, cheapest slot, and best-rated stylist in your area.',
              style: TextStyle(fontSize: 13, color: Colors.white70),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _showResults ? _buildResultsView() : const SizedBox.shrink(),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _findSlots,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.black,
                          ),
                        ),
                      )
                    : const Text('Find slots'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Best Slots for You',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          ..._bookingSlots.map((slot) => _buildSlotCard(slot)),
        ],
      ),
    );
  }

  Widget _buildSlotCard(Map<String, dynamic> slot) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0x33111827), Color(0x331F2933)],
        ),
        border: Border.all(color: const Color(0x33F8D7C4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                slot['time'],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withValues(alpha: 0.3)
                ),
                child: Text(
                  slot['waitTime'],
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                slot['stylist'],
                style: const TextStyle(fontSize: 13),
              ),
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    '${slot['rating']}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                slot['price'],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                slot['duration'],
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // Navigate to confirmation screen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const BookingConfirmationScreen(),
                  ),
                );
              },
              child: const Text('Book this slot'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _serviceController.dispose();
    _timeController.dispose();
    super.dispose();
  }
}
