import 'package:flutter/material.dart';
import '../mock_data.dart';
import 'salon_detail_screen.dart';

class CategoryDetailScreen extends StatelessWidget {
  final String category;

  const CategoryDetailScreen({super.key, required this.category});

  IconData _getCategoryIcon() {
    switch (category) {
      case 'Haircut':
        return Icons.content_cut;
      case 'Makeup':
        return Icons.brush;
      case 'Spa':
        return Icons.spa;
      case 'Bridal':
        return Icons.favorite;
      case 'Grooming':
        return Icons.face;
      default:
        return Icons.star;
    }
  }

  String _getCategoryDescription() {
    switch (category) {
      case 'Haircut':
        return 'Professional haircuts, styling, and hair treatments by expert stylists';
      case 'Makeup':
        return 'Bridal makeup, party makeup, and professional makeover services';
      case 'Spa':
        return 'Relaxing spa treatments, massages, facials, and wellness therapies';
      case 'Bridal':
        return 'Complete bridal packages including makeup, hair, and mehendi services';
      case 'Grooming':
        return 'Men\'s grooming, beard styling, facials, and skin care treatments';
      default:
        return 'Explore our premium beauty services';
    }
  }

  List<Map<String, dynamic>> _getCategoryServices() {
    switch (category) {
      case 'Haircut':
        return [
          {'name': 'Basic Haircut', 'price': 'PKR 800 - 1,500', 'duration': '30 mins'},
          {'name': 'Hair Styling', 'price': 'PKR 1,200 - 2,500', 'duration': '45 mins'},
          {'name': 'Hair Color', 'price': 'PKR 3,000 - 8,000', 'duration': '2 hours'},
          {'name': 'Keratin Treatment', 'price': 'PKR 8,000 - 15,000', 'duration': '3 hours'},
        ];
      case 'Makeup':
        return [
          {'name': 'Party Makeup', 'price': 'PKR 3,000 - 6,000', 'duration': '1 hour'},
          {'name': 'Bridal Makeup', 'price': 'PKR 15,000 - 40,000', 'duration': '2-3 hours'},
          {'name': 'Engagement Makeup', 'price': 'PKR 8,000 - 18,000', 'duration': '1.5 hours'},
          {'name': 'Natural Makeup', 'price': 'PKR 2,500 - 5,000', 'duration': '45 mins'},
        ];
      case 'Spa':
        return [
          {'name': 'Full Body Massage', 'price': 'PKR 3,500 - 6,000', 'duration': '1 hour'},
          {'name': 'Facial Treatment', 'price': 'PKR 2,000 - 4,500', 'duration': '1 hour'},
          {'name': 'Spa Package', 'price': 'PKR 8,000 - 15,000', 'duration': '3 hours'},
          {'name': 'Aromatherapy', 'price': 'PKR 4,000 - 7,000', 'duration': '1.5 hours'},
        ];
      case 'Bridal':
        return [
          {'name': 'Bridal Package', 'price': 'PKR 50,000 - 150,000', 'duration': 'Full day'},
          {'name': 'Mehendi + Makeup', 'price': 'PKR 25,000 - 60,000', 'duration': '4-5 hours'},
          {'name': 'Baraat Makeup', 'price': 'PKR 20,000 - 45,000', 'duration': '2-3 hours'},
          {'name': 'Valima Makeup', 'price': 'PKR 15,000 - 35,000', 'duration': '2 hours'},
        ];
      case 'Grooming':
        return [
          {'name': 'Beard Trimming', 'price': 'PKR 500 - 1,000', 'duration': '20 mins'},
          {'name': 'Facial (Men)', 'price': 'PKR 1,500 - 3,000', 'duration': '45 mins'},
          {'name': 'Hair + Beard', 'price': 'PKR 1,200 - 2,000', 'duration': '40 mins'},
          {'name': 'Full Grooming', 'price': 'PKR 3,000 - 5,500', 'duration': '1.5 hours'},
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final services = _getCategoryServices();
    
    return Scaffold(
      backgroundColor: const Color(0xFF050509),
      body: CustomScrollView(
        slivers: [
          // App Bar with Category Header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFF111827),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                category,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFF8D7C4).withValues(alpha: 0.3),
                      const Color(0xFFA855F7).withValues(alpha: 0.3),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    _getCategoryIcon(),
                    size: 80,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ),
          ),

          // Category Description
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.05),
                      Colors.white.withValues(alpha: 0.02),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Text(
                  _getCategoryDescription(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),

          // Services Section Header
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                'Popular Services',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Services List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final service = services[index];
                  return _buildServiceCard(service);
                },
                childCount: services.length,
              ),
            ),
          ),

          // Salons Section Header
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Text(
                'Top Salons',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Salons Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final salon = mockSalons[index % mockSalons.length];
                  return _buildSalonCard(context, salon);
                },
                childCount: 4,
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0x33111827), Color(0x331F2933)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x33F8D7C4)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFA855F7), Color(0xFF2563EB)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getCategoryIcon(),
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service['name'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      service['duration'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  service['price'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFF8D7C4),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Color(0xFFF8D7C4),
          ),
        ],
      ),
    );
  }

  Widget _buildSalonCard(BuildContext context, Salon salon) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const SalonDetailScreen(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0x33111827), Color(0x331F2933)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x33F8D7C4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                gradient: const LinearGradient(
                  colors: [Color(0xFFA855F7), Color(0xFF2563EB)],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.black.withValues(alpha: 0.4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '${salon.rating}',
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    salon.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${salon.distanceKm.toStringAsFixed(1)} km away',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    salon.priceSummary,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFF8D7C4),
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
}
