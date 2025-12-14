import 'package:flutter/material.dart';
import '../models/service_category.dart';
import '../models/provider.dart';
import '../models/chat.dart';
import '../widgets/animated_icon_wrapper.dart';
import 'booking_flow_screen.dart';
import 'ai_style_finder_screen.dart';
import 'chat_screen.dart';
import 'reviews_list_screen.dart';

class EnhancedHomeScreen extends StatefulWidget {
  const EnhancedHomeScreen({super.key});

  @override
  State<EnhancedHomeScreen> createState() => _EnhancedHomeScreenState();
}

class _EnhancedHomeScreenState extends State<EnhancedHomeScreen> {
  final String _selectedLocation = 'Current Location';
  String? _selectedCategory;
  String _sortBy = 'recommended'; // recommended, distance, rating, price
  bool _openNowOnly = false;
  final TextEditingController _searchController = TextEditingController();
  
  // Professional Demo Data - 30 Premium Salons across Pakistan
  final List<ServiceProvider> _nearbyProviders = [
    // Islamabad (10 salons)
    ServiceProvider(
      id: '1',
      name: 'Glow Beauty Salon',
      type: 'salon',
      address: 'F-7 Markaz, Islamabad',
      latitude: 33.7294,
      longitude: 73.0931,
      rating: 4.9,
      totalReviews: 342,
      imageUrl: '',
      services: ['Haircut', 'Hair Color', 'Facial', 'Bridal Makeup'],
      isVerified: true,
      isOpen: true,
      openingTime: '10:00 AM',
      closingTime: '8:00 PM',
      distance: 0.8,
      hasHomeService: true,
      deliveryFee: 500,
      minBookingTime: 30,
      specialities: ['Bridal Makeup', 'Hair Spa', 'Keratin Treatment'],
    ),
    ServiceProvider(
      id: '2',
      name: 'Luxe Spa & Wellness',
      type: 'spa',
      address: 'Blue Area, Islamabad',
      latitude: 33.7077,
      longitude: 73.0478,
      rating: 4.8,
      totalReviews: 289,
      imageUrl: '',
      services: ['Swedish Massage', 'Deep Tissue', 'Hot Stone', 'Aromatherapy'],
      isVerified: true,
      isOpen: true,
      openingTime: '11:00 AM',
      closingTime: '10:00 PM',
      distance: 1.2,
      hasHomeService: false,
      deliveryFee: 0,
      minBookingTime: 60,
      specialities: ['Couples Spa', 'Thai Massage', 'Body Scrub'],
    ),
    ServiceProvider(
      id: '3',
      name: 'Elite Gentleman Barber',
      type: 'barber',
      address: 'G-11 Markaz, Islamabad',
      latitude: 33.6844,
      longitude: 73.0479,
      rating: 4.7,
      totalReviews: 456,
      imageUrl: '',
      services: ['Haircut', 'Beard Trim', 'Shaving', 'Hair Color'],
      isVerified: true,
      isOpen: true,
      openingTime: '9:00 AM',
      closingTime: '9:00 PM',
      distance: 1.5,
      hasHomeService: true,
      deliveryFee: 300,
      minBookingTime: 20,
      specialities: ['Classic Shave', 'Fade Haircut', 'Beard Styling'],
    ),
    ServiceProvider(
      id: '4',
      name: 'Radiance Beauty Studio',
      type: 'salon',
      address: 'F-10 Markaz, Islamabad',
      latitude: 33.6973,
      longitude: 73.0515,
      rating: 4.6,
      totalReviews: 198,
      imageUrl: '',
      services: ['Manicure', 'Pedicure', 'Waxing', 'Threading'],
      isVerified: true,
      isOpen: false,
      openingTime: '10:00 AM',
      closingTime: '7:00 PM',
      distance: 2.1,
      hasHomeService: true,
      deliveryFee: 600,
      minBookingTime: 45,
      specialities: ['Nail Art', 'Gel Nails', 'Spa Manicure'],
    ),
    ServiceProvider(
      id: '5',
      name: 'Pearl Bridal Salon',
      type: 'salon',
      address: 'Kohsar Market, Islamabad',
      latitude: 33.7365,
      longitude: 73.0931,
      rating: 5.0,
      totalReviews: 167,
      imageUrl: '',
      services: ['Bridal Makeup', 'Mehndi', 'Hair Styling', 'Saree Draping'],
      isVerified: true,
      isOpen: true,
      openingTime: '11:00 AM',
      closingTime: '9:00 PM',
      distance: 0.5,
      hasHomeService: true,
      deliveryFee: 1000,
      minBookingTime: 120,
      specialities: ['Luxury Bridal Packages', 'HD Makeup', 'Party Makeup'],
    ),
    ServiceProvider(
      id: '6',
      name: 'Gents Salon Premium',
      type: 'barber',
      address: 'I-8 Markaz, Islamabad',
      latitude: 33.6700,
      longitude: 73.0747,
      rating: 4.5,
      totalReviews: 523,
      imageUrl: '',
      services: ['Haircut', 'Hair Color', 'Facial', 'Head Massage'],
      isVerified: true,
      isOpen: true,
      openingTime: '9:00 AM',
      closingTime: '10:00 PM',
      distance: 3.2,
      hasHomeService: false,
      deliveryFee: 0,
      minBookingTime: 30,
      specialities: ['Hair Straightening', 'Keratin', 'Face Bleach'],
    ),
    ServiceProvider(
      id: '7',
      name: 'Charm Beauty Lounge',
      type: 'salon',
      address: 'F-11 Markaz, Islamabad',
      latitude: 33.6813,
      longitude: 73.0425,
      rating: 4.7,
      totalReviews: 234,
      imageUrl: '',
      services: ['Hair Spa', 'Keratin', 'Rebonding', 'Hair Color'],
      isVerified: true,
      isOpen: true,
      openingTime: '10:00 AM',
      closingTime: '8:00 PM',
      distance: 1.8,
      hasHomeService: true,
      deliveryFee: 500,
      minBookingTime: 60,
      specialities: ['Brazilian Blowout', 'Ombre Hair', 'Balayage'],
    ),
    ServiceProvider(
      id: '8',
      name: 'Serenity Spa Center',
      type: 'spa',
      address: 'Centaurus Mall, Islamabad',
      latitude: 33.7077,
      longitude: 73.0514,
      rating: 4.9,
      totalReviews: 412,
      imageUrl: '',
      services: ['Body Massage', 'Face Spa', 'Body Polishing', 'Sauna'],
      isVerified: true,
      isOpen: true,
      openingTime: '10:00 AM',
      closingTime: '11:00 PM',
      distance: 1.3,
      hasHomeService: false,
      deliveryFee: 0,
      minBookingTime: 90,
      specialities: ['VIP Spa Packages', 'Steam Bath', 'Jacuzzi'],
    ),
    ServiceProvider(
      id: '9',
      name: 'Modern Cuts Studio',
      type: 'salon',
      address: 'G-9 Markaz, Islamabad',
      latitude: 33.6978,
      longitude: 73.0388,
      rating: 4.4,
      totalReviews: 178,
      imageUrl: '',
      services: ['Haircut', 'Blow Dry', 'Hair Styling', 'Highlights'],
      isVerified: false,
      isOpen: true,
      openingTime: '11:00 AM',
      closingTime: '8:00 PM',
      distance: 2.7,
      hasHomeService: true,
      deliveryFee: 400,
      minBookingTime: 40,
      specialities: ['Trendy Cuts', 'Color Correction', 'Hair Extensions'],
    ),
    ServiceProvider(
      id: '10',
      name: 'Royal Barber Shop',
      type: 'barber',
      address: 'Jinnah Super, Islamabad',
      latitude: 33.7254,
      longitude: 73.0611,
      rating: 4.8,
      totalReviews: 567,
      imageUrl: '',
      services: ['Haircut', 'Beard Trim', 'Hair Wash', 'Facial'],
      isVerified: true,
      isOpen: true,
      openingTime: '8:00 AM',
      closingTime: '10:00 PM',
      distance: 0.9,
      hasHomeService: false,
      deliveryFee: 0,
      minBookingTime: 25,
      specialities: ['Traditional Shave', 'Kids Haircut', 'Hair Coloring'],
    ),

    // Lahore (10 salons)
    ServiceProvider(
      id: '11',
      name: 'Glam Studio Lahore',
      type: 'salon',
      address: 'MM Alam Road, Gulberg, Lahore',
      latitude: 31.5204,
      longitude: 74.3587,
      rating: 4.9,
      totalReviews: 678,
      imageUrl: '',
      services: ['Bridal Makeup', 'Party Makeup', 'Hair Styling', 'Facial'],
      isVerified: true,
      isOpen: true,
      openingTime: '10:00 AM',
      closingTime: '9:00 PM',
      distance: 1.1,
      hasHomeService: true,
      deliveryFee: 800,
      minBookingTime: 90,
      specialities: ['HD Bridal Makeup', 'Airbrush Makeup', 'Hair Extensions'],
    ),
    ServiceProvider(
      id: '12',
      name: 'Elite Spa Lahore',
      type: 'spa',
      address: 'DHA Phase 5, Lahore',
      latitude: 31.4757,
      longitude: 74.4019,
      rating: 4.7,
      totalReviews: 345,
      imageUrl: '',
      services: ['Thai Massage', 'Swedish Massage', 'Body Scrub', 'Facial'],
      isVerified: true,
      isOpen: true,
      openingTime: '11:00 AM',
      closingTime: '10:00 PM',
      distance: 3.5,
      hasHomeService: false,
      deliveryFee: 0,
      minBookingTime: 60,
      specialities: ['Luxury Spa Packages', 'Couple Spa', 'Hot Stone'],
    ),
    ServiceProvider(
      id: '13',
      name: "Gentleman's Club Barber",
      type: 'barber',
      address: 'Liberty Market, Lahore',
      latitude: 31.5089,
      longitude: 74.3411,
      rating: 4.6,
      totalReviews: 789,
      imageUrl: '',
      services: ['Haircut', 'Beard Styling', 'Shaving', 'Hair Color'],
      isVerified: true,
      isOpen: true,
      openingTime: '9:00 AM',
      closingTime: '11:00 PM',
      distance: 2.3,
      hasHomeService: true,
      deliveryFee: 500,
      minBookingTime: 30,
      specialities: ['Premium Shave', 'Fade Cuts', 'Beard Grooming'],
    ),
    ServiceProvider(
      id: '14',
      name: 'Bliss Beauty Salon',
      type: 'salon',
      address: 'Johar Town, Lahore',
      latitude: 31.4693,
      longitude: 74.2728,
      rating: 4.8,
      totalReviews: 423,
      imageUrl: '',
      services: ['Haircut', 'Hair Color', 'Manicure', 'Pedicure'],
      isVerified: true,
      isOpen: true,
      openingTime: '10:00 AM',
      closingTime: '8:00 PM',
      distance: 4.2,
      hasHomeService: true,
      deliveryFee: 600,
      minBookingTime: 45,
      specialities: ['Balayage', 'Nail Art', 'Hair Spa'],
    ),
    ServiceProvider(
      id: '15',
      name: 'Luxury Bridal Studio',
      type: 'salon',
      address: 'Model Town, Lahore',
      latitude: 31.4867,
      longitude: 74.3232,
      rating: 5.0,
      totalReviews: 234,
      imageUrl: '',
      services: ['Bridal Packages', 'Mehndi', 'Hair Styling', 'Makeup'],
      isVerified: true,
      isOpen: true,
      openingTime: '11:00 AM',
      closingTime: '10:00 PM',
      distance: 2.8,
      hasHomeService: true,
      deliveryFee: 1500,
      minBookingTime: 180,
      specialities: ['Premium Bridal', 'Walima Makeup', 'Reception Makeup'],
    ),
    ServiceProvider(
      id: '16',
      name: 'Kings Barber Lounge',
      type: 'barber',
      address: 'Cavalry Ground, Lahore',
      latitude: 31.4846,
      longitude: 74.3456,
      rating: 4.7,
      totalReviews: 612,
      imageUrl: '',
      services: ['Haircut', 'Beard Trim', 'Hair Wash', 'Styling'],
      isVerified: true,
      isOpen: true,
      openingTime: '9:00 AM',
      closingTime: '10:00 PM',
      distance: 3.1,
      hasHomeService: false,
      deliveryFee: 0,
      minBookingTime: 25,
      specialities: ['Modern Cuts', 'Hair Designs', 'Beard Art'],
    ),
    ServiceProvider(
      id: '17',
      name: 'Oasis Wellness Spa',
      type: 'spa',
      address: 'Packages Mall, Lahore',
      latitude: 31.4693,
      longitude: 74.2732,
      rating: 4.9,
      totalReviews: 389,
      imageUrl: '',
      services: ['Body Massage', 'Facial', 'Body Polishing', 'Waxing'],
      isVerified: true,
      isOpen: true,
      openingTime: '10:00 AM',
      closingTime: '11:00 PM',
      distance: 4.5,
      hasHomeService: false,
      deliveryFee: 0,
      minBookingTime: 75,
      specialities: ['Aromatherapy', 'Deep Tissue', 'Reflexology'],
    ),
    ServiceProvider(
      id: '18',
      name: 'Glowing Skin Clinic',
      type: 'salon',
      address: 'Faisal Town, Lahore',
      latitude: 31.4307,
      longitude: 74.2847,
      rating: 4.5,
      totalReviews: 278,
      imageUrl: '',
      services: ['Facial', 'Skin Treatment', 'Laser', 'Anti-Aging'],
      isVerified: true,
      isOpen: false,
      openingTime: '10:00 AM',
      closingTime: '7:00 PM',
      distance: 5.2,
      hasHomeService: false,
      deliveryFee: 0,
      minBookingTime: 60,
      specialities: ['Hydrafacial', 'Chemical Peel', 'Microdermabrasion'],
    ),
    ServiceProvider(
      id: '19',
      name: 'Trendy Cuts Salon',
      type: 'salon',
      address: 'Allama Iqbal Town, Lahore',
      latitude: 31.5065,
      longitude: 74.3088,
      rating: 4.4,
      totalReviews: 456,
      imageUrl: '',
      services: ['Haircut', 'Hair Color', 'Keratin', 'Rebonding'],
      isVerified: false,
      isOpen: true,
      openingTime: '11:00 AM',
      closingTime: '9:00 PM',
      distance: 3.7,
      hasHomeService: true,
      deliveryFee: 500,
      minBookingTime: 50,
      specialities: ['Hair Smoothing', 'Perming', 'Highlights'],
    ),
    ServiceProvider(
      id: '20',
      name: 'Premium Gents Salon',
      type: 'barber',
      address: 'Wapda Town, Lahore',
      latitude: 31.4166,
      longitude: 74.2665,
      rating: 4.6,
      totalReviews: 534,
      imageUrl: '',
      services: ['Haircut', 'Shave', 'Facial', 'Hair Spa'],
      isVerified: true,
      isOpen: true,
      openingTime: '8:00 AM',
      closingTime: '10:00 PM',
      distance: 6.1,
      hasHomeService: true,
      deliveryFee: 400,
      minBookingTime: 30,
      specialities: ['Royal Shave', 'Hair Treatment', 'Scalp Massage'],
    ),

    // Karachi (10 salons)
    ServiceProvider(
      id: '21',
      name: 'Elegance Beauty Parlor',
      type: 'salon',
      address: 'Clifton Block 2, Karachi',
      latitude: 24.8138,
      longitude: 67.0233,
      rating: 4.8,
      totalReviews: 892,
      imageUrl: '',
      services: ['Bridal Makeup', 'Hair Styling', 'Facial', 'Manicure'],
      isVerified: true,
      isOpen: true,
      openingTime: '10:00 AM',
      closingTime: '9:00 PM',
      distance: 1.4,
      hasHomeService: true,
      deliveryFee: 1000,
      minBookingTime: 75,
      specialities: ['Luxury Bridal Packages', 'Party Makeup', 'Hair Color'],
    ),
    ServiceProvider(
      id: '22',
      name: 'Ocean Spa Karachi',
      type: 'spa',
      address: 'DHA Phase 6, Karachi',
      latitude: 24.7963,
      longitude: 67.0656,
      rating: 4.9,
      totalReviews: 567,
      imageUrl: '',
      services: ['Body Massage', 'Facial', 'Sauna', 'Steam Bath'],
      isVerified: true,
      isOpen: true,
      openingTime: '11:00 AM',
      closingTime: '11:00 PM',
      distance: 2.7,
      hasHomeService: false,
      deliveryFee: 0,
      minBookingTime: 90,
      specialities: ['Hot Stone Massage', 'Thai Spa', 'Couples Treatment'],
    ),
    ServiceProvider(
      id: '23',
      name: 'Classic Barber Shop',
      type: 'barber',
      address: 'Gulshan-e-Iqbal, Karachi',
      latitude: 24.9214,
      longitude: 67.0822,
      rating: 4.7,
      totalReviews: 723,
      imageUrl: '',
      services: ['Haircut', 'Beard Styling', 'Shaving', 'Hair Color'],
      isVerified: true,
      isOpen: true,
      openingTime: '9:00 AM',
      closingTime: '10:00 PM',
      distance: 4.3,
      hasHomeService: true,
      deliveryFee: 600,
      minBookingTime: 30,
      specialities: ['Fade Cuts', 'Beard Grooming', 'Hair Designs'],
    ),
    ServiceProvider(
      id: '24',
      name: 'Divine Beauty Studio',
      type: 'salon',
      address: 'Saddar, Karachi',
      latitude: 24.8593,
      longitude: 67.0099,
      rating: 4.6,
      totalReviews: 445,
      imageUrl: '',
      services: ['Haircut', 'Manicure', 'Pedicure', 'Waxing'],
      isVerified: true,
      isOpen: true,
      openingTime: '10:00 AM',
      closingTime: '8:00 PM',
      distance: 3.2,
      hasHomeService: true,
      deliveryFee: 500,
      minBookingTime: 45,
      specialities: ['Gel Nails', 'Nail Art', 'Threading'],
    ),
    ServiceProvider(
      id: '25',
      name: 'Royal Touch Salon',
      type: 'salon',
      address: 'Bahadurabad, Karachi',
      latitude: 24.8949,
      longitude: 67.0681,
      rating: 4.5,
      totalReviews: 334,
      imageUrl: '',
      services: ['Hair Color', 'Keratin', 'Rebonding', 'Hair Spa'],
      isVerified: true,
      isOpen: false,
      openingTime: '10:00 AM',
      closingTime: '7:00 PM',
      distance: 5.1,
      hasHomeService: true,
      deliveryFee: 700,
      minBookingTime: 90,
      specialities: ['Brazilian Blowout', 'Balayage', 'Ombre'],
    ),
    ServiceProvider(
      id: '26',
      name: 'Modern Gents Salon',
      type: 'barber',
      address: 'Tariq Road, Karachi',
      latitude: 24.8734,
      longitude: 67.0514,
      rating: 4.8,
      totalReviews: 612,
      imageUrl: '',
      services: ['Haircut', 'Beard Trim', 'Hair Wash', 'Facial'],
      isVerified: true,
      isOpen: true,
      openingTime: '9:00 AM',
      closingTime: '11:00 PM',
      distance: 2.9,
      hasHomeService: false,
      deliveryFee: 0,
      minBookingTime: 25,
      specialities: ['Trending Cuts', 'Hair Straightening', 'Head Massage'],
    ),
    ServiceProvider(
      id: '27',
      name: 'Serenity Wellness Spa',
      type: 'spa',
      address: 'Zamzama Commercial, Karachi',
      latitude: 24.8115,
      longitude: 67.0283,
      rating: 4.9,
      totalReviews: 478,
      imageUrl: '',
      services: ['Full Body Massage', 'Facial', 'Body Polishing', 'Manicure'],
      isVerified: true,
      isOpen: true,
      openingTime: '10:00 AM',
      closingTime: '10:00 PM',
      distance: 1.8,
      hasHomeService: false,
      deliveryFee: 0,
      minBookingTime: 80,
      specialities: ['Aromatherapy', 'Deep Tissue', 'Swedish Massage'],
    ),
    ServiceProvider(
      id: '28',
      name: 'Glamour Studio',
      type: 'salon',
      address: 'Korangi, Karachi',
      latitude: 24.8478,
      longitude: 67.1112,
      rating: 4.4,
      totalReviews: 267,
      imageUrl: '',
      services: ['Bridal Makeup', 'Party Makeup', 'Hair Styling', 'Mehndi'],
      isVerified: false,
      isOpen: true,
      openingTime: '11:00 AM',
      closingTime: '9:00 PM',
      distance: 7.3,
      hasHomeService: true,
      deliveryFee: 800,
      minBookingTime: 120,
      specialities: ['Engagement Makeup', 'Walima Look', 'Reception Styling'],
    ),
    ServiceProvider(
      id: '29',
      name: 'Urban Barber Studio',
      type: 'barber',
      address: 'Malir, Karachi',
      latitude: 24.8934,
      longitude: 67.2007,
      rating: 4.6,
      totalReviews: 423,
      imageUrl: '',
      services: ['Haircut', 'Shaving', 'Hair Color', 'Beard Styling'],
      isVerified: true,
      isOpen: true,
      openingTime: '8:00 AM',
      closingTime: '10:00 PM',
      distance: 8.5,
      hasHomeService: true,
      deliveryFee: 500,
      minBookingTime: 30,
      specialities: ['Classic Shave', 'Modern Haircuts', 'Hair Designs'],
    ),
    ServiceProvider(
      id: '30',
      name: 'Paradise Beauty Center',
      type: 'salon',
      address: 'North Nazimabad, Karachi',
      latitude: 24.9269,
      longitude: 67.0394,
      rating: 4.7,
      totalReviews: 389,
      imageUrl: '',
      services: ['Haircut', 'Facial', 'Manicure', 'Pedicure', 'Waxing'],
      isVerified: true,
      isOpen: true,
      openingTime: '10:00 AM',
      closingTime: '8:00 PM',
      distance: 6.7,
      hasHomeService: true,
      deliveryFee: 600,
      minBookingTime: 50,
      specialities: ['Skin Care', 'Anti-Aging', 'Hair Treatments'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050509),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar with Location
            _buildSliverAppBar(),
            
            // Search Bar
            SliverToBoxAdapter(
              child: _buildSearchBar(),
            ),
            
            // Categories Horizontal List
            SliverToBoxAdapter(
              child: _buildCategoriesSection(),
            ),
            
            // Offers & Deals Banner
            SliverToBoxAdapter(
              child: _buildOffersSection(),
            ),
            
            // Nearby Providers List
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Nearby Services',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('See All'),
                    ),
                  ],
                ),
              ),
            ),
            
            // Provider Cards
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildProviderCard(_nearbyProviders[index]),
                childCount: _nearbyProviders.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: const Color(0xFF111827),
      title: Row(
        children: [
          AnimatedIconWrapper(
            icon: Icons.location_on,
            color: const Color(0xFFF8D7C4),
            size: 22,
            enableGlow: true,
            enablePulse: true,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Show location picker
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Deliver to',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  Text(
                    _selectedLocation,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: AnimatedIconWrapper(
              icon: Icons.notifications_outlined,
              color: Colors.white,
              size: 22,
              enableGlow: true,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Main Search Bar
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search for salons, services...',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFF8D7C4)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white70),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Filter Chips Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  'Sort: ${_getSortLabel()}',
                  Icons.sort,
                  () => _showSortOptions(),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  'Open Now',
                  Icons.access_time,
                  () {
                    setState(() {
                      _openNowOnly = !_openNowOnly;
                    });
                  },
                  isSelected: _openNowOnly,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  'Home Service',
                  Icons.home_outlined,
                  () {},
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  'Offers',
                  Icons.local_offer,
                  () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    final categories = ServiceCategories.getAllCategories();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = _selectedCategory == category.id;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = isSelected ? null : category.id;
                  });
                },
                child: Container(
                  width: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isSelected
                          ? [const Color(0xFFF8D7C4), const Color(0xFFA855F7)]
                          : [
                              Colors.white.withValues(alpha: 0.1),
                              Colors.white.withValues(alpha: 0.05),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        category.icon,
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.black : Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOffersSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // AI Style Finder Card with Advanced Animation
          _AIStyleFinderCard(),
          
          const SizedBox(height: 12),
          
          // Offers Banner
          Container(
            height: 150,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF8D7C4), Color(0xFFA855F7)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 20,
                  bottom: 10,
                  child: Text(
                    '✨',
                    style: TextStyle(
                      fontSize: 80,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '🎉 Special Offers',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Get 30% OFF on first booking',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('View Deals'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderCard(ServiceProvider provider) {
    return GestureDetector(
      onTap: () {
        // Navigate to booking flow
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BookingFlowScreen(provider: provider),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.1),
              Colors.white.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Provider Image
            Container(
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFF8D7C4).withValues(alpha: 0.3),
                    const Color(0xFFA855F7).withValues(alpha: 0.3),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  // Verified Badge
                  if (provider.isVerified)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.verified, size: 14, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'Verified',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Home Service Badge
                  if (provider.hasHomeService)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFA855F7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.home, size: 14, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'Home Service',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Provider Info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          provider.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: provider.isOpen ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          provider.isOpen ? 'Open' : 'Closed',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewsListScreen(
                                providerId: provider.id,
                                providerName: provider.name,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          '${provider.rating} (${provider.totalReviews} reviews)',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.location_on, color: Color(0xFFF8D7C4), size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${provider.distance} km',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.address,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white60,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: provider.specialities.map((speciality) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFF8D7C4).withValues(alpha: 0.3),
                              const Color(0xFFA855F7).withValues(alpha: 0.3),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          speciality,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Start chat with provider
                            final conversation = ChatConversation(
                              id: 'conv_${provider.id}',
                              customerId: 'current_user_id',
                              customerName: 'You',
                              providerId: provider.id,
                              providerName: provider.name,
                              lastActivity: DateTime.now(),
                            );
                            
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  conversation: conversation,
                                  currentUserId: 'current_user_id',
                                  userType: 'customer',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.chat_bubble_outline, size: 18),
                          label: const Text('Contact'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFF8D7C4),
                            side: const BorderSide(color: Color(0xFFF8D7C4)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BookingFlowScreen(provider: provider),
                              ),
                            );
                          },
                          icon: const Icon(Icons.calendar_month, size: 18),
                          label: const Text('Book Now'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ).copyWith(
                            backgroundColor: WidgetStateProperty.all(Colors.transparent),
                          ),
                        ).wrapWithGradient(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon, VoidCallback onTap, {bool isSelected = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFF8D7C4), Color(0xFFA855F7)],
                )
              : null,
          color: isSelected ? null : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Colors.white.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : const Color(0xFFF8D7C4),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSortLabel() {
    switch (_sortBy) {
      case 'recommended':
        return 'Recommended';
      case 'distance':
        return 'Distance';
      case 'rating':
        return 'Rating';
      case 'price':
        return 'Price';
      default:
        return 'Recommended';
    }
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111827),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sort By',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              _buildSortOption('Recommended', 'recommended', Icons.star),
              _buildSortOption('Distance', 'distance', Icons.location_on),
              _buildSortOption('Rating', 'rating', Icons.star_rate),
              _buildSortOption('Price (Low to High)', 'price', Icons.attach_money),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String label, String value, IconData icon) {
    final isSelected = _sortBy == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _sortBy = value;
        });
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFF8D7C4), Color(0xFFA855F7)],
                )
              : LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.1),
                    Colors.white.withValues(alpha: 0.05),
                  ],
                ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Colors.white.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFFF8D7C4),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : Colors.white,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.white),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

/// Advanced AI Style Finder Card with animations
class _AIStyleFinderCard extends StatefulWidget {
  const _AIStyleFinderCard();

  @override
  State<_AIStyleFinderCard> createState() => _AIStyleFinderCardState();
}

class _AIStyleFinderCardState extends State<_AIStyleFinderCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  late Animation<double> _iconRotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _iconRotateAnimation = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const AIStyleFinderScreen(),
          ),
        );
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFA855F7).withValues(alpha: 0.3),
                  const Color(0xFFF8D7C4).withValues(alpha: 0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFA855F7).withValues(alpha: 0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFA855F7).withValues(alpha: _glowAnimation.value),
                  blurRadius: 20,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFF8D7C4),
                        Color(0xFFEC4899),
                        Color(0xFFA855F7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFA855F7).withValues(alpha: 0.6),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Transform.rotate(
                    angle: _iconRotateAnimation.value,
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFFFFFFFF),
                            Color(0xFFF8D7C4),
                          ],
                        ).createShader(bounds),
                        child: const Text(
                          'AI Style Finder',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Upload photo & get AI recommendations',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Transform.scale(
                  scale: 1.0 + (_glowAnimation.value - 0.5) * 0.2,
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFFF8D7C4),
                    size: 20,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
