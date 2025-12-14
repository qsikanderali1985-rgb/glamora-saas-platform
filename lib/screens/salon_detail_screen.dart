import 'package:flutter/material.dart';

import 'quick_booking_screen.dart';

class SalonDetailScreen extends StatelessWidget {
  const SalonDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salon Details'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: const LinearGradient(
                colors: [Color(0xFFA855F7), Color(0xFF2563EB)],
              ),
            ),
            child: Stack(
              children: const [
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Text(
                    'Luxe Glow Studio',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '0.8 km • Women & Men',
            style: TextStyle(fontSize: 13, color: Colors.white70),
          ),
          const SizedBox(height: 8),
          const Text(
            'Premium salon experience with bridal, party, and grooming packages.',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 20),
          const Text(
            'Popular services',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          _ServiceTile(title: 'Soft glam makeup', price: 'PKR 4,500'),
          const SizedBox(height: 8),
          _ServiceTile(title: 'Luxury haircut & blowdry', price: 'PKR 2,800'),
          const SizedBox(height: 8),
          _ServiceTile(title: 'Bridal signature look', price: 'PKR 18,000'),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to booking flow with preselected salon
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const QuickBookingScreen(),
                                  ),
                                );
              },
              child: const Text('Book now'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final String title;
  final String price;

  const _ServiceTile({required this.title, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0x33111827), Color(0x331F2933)],
        ),
        border: Border.all(color: const Color(0x33F8D7C4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Text(
            price,
            style: const TextStyle(fontSize: 13, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
