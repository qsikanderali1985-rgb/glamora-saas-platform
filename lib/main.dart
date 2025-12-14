import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'ai_style_finder_screen.dart';
import 'firebase_options.dart';
import 'mock_data.dart';
import 'role_selection_screen.dart';
import 'screens/quick_booking_screen.dart';
import 'screens/salon_detail_screen.dart';
import 'screens/enhanced_home_screen.dart';
import 'screens/owner_dashboard_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/chat_list_screen.dart';
import 'screens/category_detail_screen.dart';
import 'widgets/glamora_logo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const GlamoraApp());
}

class GlamoraApp extends StatelessWidget {
  const GlamoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Glamora',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF050509),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF8D7C4),
          secondary: Color(0xFFA855F7),
          surface: Color(0xFF111827),
          onPrimary: Colors.black,
          onSecondary: Colors.white,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
      home: const RoleSelectionScreen()
    );
  }
}

class GlamoraHomeShell extends StatefulWidget {
  final UserRole userRole;
  
  const GlamoraHomeShell({super.key, required this.userRole});

  @override
  State<GlamoraHomeShell> createState() => _GlamoraHomeShellState();
}

class _GlamoraHomeShellState extends State<GlamoraHomeShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Role-based pages
    final pages = widget.userRole == UserRole.customer
        ? [
            const EnhancedHomeScreen(), // Customer: Browse & Book
            ChatListScreen(currentUserId: 'current_user_id', userType: 'customer'), // Customer: Messages
            const ProfileScreen(), // Customer: Profile & Settings
          ]
        : [
            const OwnerDashboardScreen(), // Owner: Dashboard
            const StaffTasksScreen(), // Owner: Staff Management
            ChatListScreen(currentUserId: 'current_provider_id', userType: 'provider'), // Owner: Messages
            const ProfileScreen(), // Owner: Profile & Settings
          ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF050509).withValues(alpha: 0.9),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 20,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            selectedItemColor: const Color(0xFFF8D7C4),
            unselectedItemColor: Colors.white54,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: widget.userRole == UserRole.customer
                ? const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.explore_outlined),
                      label: 'Explore',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.chat_bubble_outline),
                      label: 'Messages',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline),
                      label: 'Profile',
                    ),
                  ]
                : const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.dashboard_outlined),
                      label: 'Dashboard',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.people_outline),
                      label: 'Staff',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.chat_bubble_outline),
                      label: 'Messages',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline),
                      label: 'Profile',
                    ),
                  ],
          ),
        ),
      ),
      floatingActionButton: _currentIndex == 0 && widget.userRole == UserRole.customer
          ? const _QuickBookingButton()
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _HomeHeader(),
            const SizedBox(height: 20),
            const _AISmartStyleCard(),
            const SizedBox(height: 24),
            const _CategoryRow(),
            const SizedBox(height: 24),
            const _NearbySalonsCarousel(),
            const SizedBox(height: 24),
            const _AIRecommendationSlider(),
          ],
        ),
      ),
    );
  }
}

class StaffTasksScreen extends StatelessWidget {
  const StaffTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Staff Task Board',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
            _StaffSkillScoreCard(),
            SizedBox(height: 16),
            _StaffTaskList(),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 4),
            const AnimatedGlamoraLogo(size: 28, showText: true),
          ],
        ),
        const AnimatedGlamoraLogo(size: 46, showText: false),
      ],
    );
  }
}

class _AISmartStyleCard extends StatelessWidget {
  const _AISmartStyleCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0x33F8D7C4), Color(0x33111827)],
        ),
        border: Border.all(
          color: const Color(0x66F8D7C4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF8D7C4).withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Smart Style Finder',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Upload a photo and let AI suggest the perfect haircut, beard, and makeup looks for your next event.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF8D7C4),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AiStyleFinderScreen(),
                      ),
                    );
                  },
                  child: const Text('Try now'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36),
              gradient: const LinearGradient(
                colors: [Color(0xFFA855F7), Color(0xFF2563EB)],
              ),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow();

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Haircut',
      'Makeup',
      'Spa',
      'Bridal',
      'Grooming',
    ];

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          return _GlassCategoryCard(label: categories[index]);
        },
      ),
    );
  }
}

class _GlassCategoryCard extends StatelessWidget {
  final String label;

  const _GlassCategoryCard({required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CategoryDetailScreen(category: label),
          ),
        );
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0x33F5E0D8), Color(0x33111827)],
          ),
          border: Border.all(
            color: const Color(0x66F5E0D8),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.star_border_rounded, color: Colors.white70, size: 26),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NearbySalonsCarousel extends StatelessWidget {
  const _NearbySalonsCarousel();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Nearby salons',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              'View all',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: mockSalons.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final salon = mockSalons[index];
              return _SalonCard(salon: salon);
            },
          ),
        ),
      ],
    );
  }
}

class _SalonCard extends StatelessWidget {
  final Salon salon;

  const _SalonCard({required this.salon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const SalonDetailScreen(),
          ),
        );
      },
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [Color(0x33111827), Color(0x331F2933)],
          ),
          border: Border.all(color: const Color(0x33F8D7C4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
                gradient: const LinearGradient(
                  colors: [Color(0xFFA855F7), Color(0xFF2563EB)],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black.withValues(alpha: 0.4)
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star,
                              color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text('${salon.rating}',
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    bottom: 12,
                    child: Text(
                      salon.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${salon.distanceKm.toStringAsFixed(1)} km • ${salon.audienceLabel}',
                    style:
                        const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    salon.priceSummary,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500),
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

class _AIRecommendationSlider extends StatelessWidget {
  const _AIRecommendationSlider();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'AI picks for you',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              'Refresh',
              style: TextStyle(fontSize: 13, color: Colors.white70),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return const _AIRecommendationCard();
            },
          ),
        ),
      ],
    );
  }
}

class _AIRecommendationCard extends StatelessWidget {
  const _AIRecommendationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0x3310B981), Color(0x33FBBF24)],
        ),
        border: Border.all(color: const Color(0x6610B981)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Tonight\'s party look',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 6),
          Text(
            'Soft glam + loose curls, perfectly tuned for your face shape.',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          Spacer(),
          Text(
            'View matching salons',
            style: TextStyle(
              fontSize: 12,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickBookingButton extends StatelessWidget {
  const _QuickBookingButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        gradient: const LinearGradient(
          colors: [Color(0xFFF8D7C4), Color(0xFFA855F7)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF8D7C4).withValues(alpha: 0.4),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.flash_on_rounded, color: Colors.black),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const QuickBookingScreen(),
            ),
          );
        },
      ),
    );
  }
}

class _StaffSkillScoreCard extends StatelessWidget {
  const _StaffSkillScoreCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0x3310B981), Color(0x33FBBF24)],
        ),
        border: Border.all(color: const Color(0x6610B981)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Expanded(
            child: Text(
              'Skill Score',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            '87',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _StaffTaskList extends StatelessWidget {
  const _StaffTaskList();

  @override
  Widget build(BuildContext context) {
    final tasks = [
      'Haircut • 2:00 PM • Ali',
      'Bridal makeup • 3:30 PM • Sana',
      'Gentlemen facial • 5:00 PM • Ahmed',
    ];

    return Expanded(
      child: ListView.separated(
        itemCount: tasks.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0x33111827), Color(0x331F2933)],
              ),
              border: Border.all(color: const Color(0x33F8D7C4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline,
                    color: Colors.white70, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    tasks[index],
                    style: const TextStyle(fontSize: 13),
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
