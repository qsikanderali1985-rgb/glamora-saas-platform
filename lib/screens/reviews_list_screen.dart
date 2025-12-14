import 'package:flutter/material.dart';
import '../models/review.dart';
import 'write_review_screen.dart';

class ReviewsListScreen extends StatefulWidget {
  final String providerId;
  final String providerName;

  const ReviewsListScreen({
    super.key,
    required this.providerId,
    required this.providerName,
  });

  @override
  State<ReviewsListScreen> createState() => _ReviewsListScreenState();
}

class _ReviewsListScreenState extends State<ReviewsListScreen> {
  String _selectedFilter = 'all'; // all, 5, 4, 3, 2, 1
  
  // Mock reviews data
  final List<Review> _allReviews = [
    Review(
      id: '1',
      bookingId: 'BK001',
      customerId: 'C001',
      customerName: 'Fatima Ahmed',
      customerPhotoUrl: '',
      providerId: 'P001',
      providerName: 'Glow Beauty Salon',
      rating: 5.0,
      comment: 'Amazing experience! The stylist understood exactly what I wanted. My hair looks incredible and the products they used were top quality. The salon ambiance was so relaxing. Highly recommend!',
      photoUrls: ['before.jpg', 'after.jpg'],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      helpfulCount: 12,
      servicesTaken: ['Haircut', 'Hair Color'],
      providerResponse: 'Thank you so much Fatima! We\'re thrilled you loved your new look. Can\'t wait to see you again!',
      responseDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Review(
      id: '2',
      bookingId: 'BK002',
      customerId: 'C002',
      customerName: 'Ayesha Khan',
      customerPhotoUrl: '',
      providerId: 'P001',
      providerName: 'Glow Beauty Salon',
      rating: 4.0,
      comment: 'Very good service overall. The facial was relaxing and my skin feels great. Only minor issue was the wait time, but the quality made up for it.',
      photoUrls: [],
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      helpfulCount: 8,
      servicesTaken: ['Facial Treatment'],
    ),
    Review(
      id: '3',
      bookingId: 'BK003',
      customerId: 'C003',
      customerName: 'Sara Ali',
      customerPhotoUrl: '',
      providerId: 'P001',
      providerName: 'Glow Beauty Salon',
      rating: 5.0,
      comment: 'Best salon in town! Professional staff, clean environment, and amazing results. I\'ve been coming here for months and never disappointed.',
      photoUrls: ['result.jpg'],
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      helpfulCount: 20,
      servicesTaken: ['Makeup', 'Hairstyling'],
    ),
    Review(
      id: '4',
      bookingId: 'BK004',
      customerId: 'C004',
      customerName: 'Zara Hassan',
      customerPhotoUrl: '',
      providerId: 'P001',
      providerName: 'Glow Beauty Salon',
      rating: 3.0,
      comment: 'Decent service but expected more based on the reviews. The haircut was okay but not exactly what I asked for.',
      photoUrls: [],
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      helpfulCount: 3,
      servicesTaken: ['Haircut'],
    ),
  ];

  // Calculate rating stats
  RatingStats get _ratingStats {
    final breakdown = <int, int>{5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    double totalRating = 0;

    for (final review in _allReviews) {
      final stars = review.rating.round();
      breakdown[stars] = (breakdown[stars] ?? 0) + 1;
      totalRating += review.rating;
    }

    return RatingStats(
      averageRating: _allReviews.isEmpty ? 0 : totalRating / _allReviews.length,
      totalReviews: _allReviews.length,
      ratingBreakdown: breakdown,
    );
  }

  List<Review> get _filteredReviews {
    if (_selectedFilter == 'all') return _allReviews;
    final filterRating = int.parse(_selectedFilter).toDouble();
    return _allReviews.where((r) => r.rating == filterRating).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050509),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Reviews & Ratings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          // Rating Overview
          _buildRatingOverview(),
          const SizedBox(height: 20),

          // Filter Chips
          _buildFilterChips(),
          const SizedBox(height: 16),

          // Reviews List
          Expanded(
            child: _filteredReviews.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _filteredReviews.length,
                    itemBuilder: (context, index) {
                      return _buildReviewCard(_filteredReviews[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WriteReviewScreen(
                bookingId: 'demo_booking',
                providerId: widget.providerId,
                providerName: widget.providerName,
                servicesTaken: const ['Haircut', 'Makeup'],
              ),
            ),
          );
        },
        backgroundColor: const Color(0xFFA855F7),
        icon: const Icon(Icons.rate_review, color: Colors.white),
        label: const Text(
          'Write Review',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildRatingOverview() {
    final stats = _ratingStats;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFF8D7C4).withValues(alpha: 0.1),
            const Color(0xFFA855F7).withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFA855F7).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          // Average Rating
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  stats.averageRating.toStringAsFixed(1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Icon(
                      index < stats.averageRating.round()
                          ? Icons.star
                          : Icons.star_border,
                      color: const Color(0xFFFBBF24),
                      size: 20,
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  '${stats.totalReviews} reviews',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Rating Breakdown
          Expanded(
            flex: 3,
            child: Column(
              children: List.generate(5, (index) {
                final stars = 5 - index;
                final count = stats.getCount(stars);
                final percentage = stats.getPercentage(stars);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        '$stars',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.star,
                        color: Color(0xFFFBBF24),
                        size: 12,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: percentage / 100,
                              child: Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFF8D7C4), Color(0xFFA855F7)],
                                  ),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$count',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildFilterChip('All', 'all'),
          _buildFilterChip('⭐⭐⭐⭐⭐ 5', '5'),
          _buildFilterChip('⭐⭐⭐⭐ 4', '4'),
          _buildFilterChip('⭐⭐⭐ 3', '3'),
          _buildFilterChip('⭐⭐ 2', '2'),
          _buildFilterChip('⭐ 1', '1'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedFilter = value);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFFF8D7C4), Color(0xFFA855F7)],
                  )
                : null,
            color: isSelected ? null : const Color(0xFF111827).withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info & Rating
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF8D7C4), Color(0xFFA855F7)],
                  ),
                ),
                child: Center(
                  child: Text(
                    review.customerName[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.customerName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      review.timeAgo,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Rating stars
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.rating ? Icons.star : Icons.star_border,
                    color: const Color(0xFFFBBF24),
                    size: 16,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Services taken
          if (review.servicesTaken.isNotEmpty) ...[
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: review.servicesTaken.map((service) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA855F7).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(0xFFA855F7).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    service,
                    style: TextStyle(
                      color: const Color(0xFFA855F7),
                      fontSize: 11,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],

          // Review comment
          Text(
            review.comment,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),

          // Photos
          if (review.photoUrls.isNotEmpty) ...[
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: review.photoUrls.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF8D7C4), Color(0xFFA855F7)],
                      ),
                    ),
                    child: const Icon(Icons.image, color: Colors.white, size: 30),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Provider Response
          if (review.providerResponse != null) ...[
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFA855F7).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFA855F7).withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.store,
                        color: Color(0xFFA855F7),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Response from salon',
                        style: TextStyle(
                          color: Color(0xFFA855F7),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    review.providerResponse!,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Helpful button
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Marked as helpful!')),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.thumb_up_outlined,
                        size: 14,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Helpful (${review.helpfulCount})',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: 80,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No reviews with $_selectedFilter stars yet',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
