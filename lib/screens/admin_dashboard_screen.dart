import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'admin_users_screen.dart';
import 'admin_bookings_screen.dart';
import 'admin_providers_screen.dart';
import 'admin_revenue_screen.dart';
import 'admin_settings_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // Mock data - In production, fetch from database
  final Map<String, dynamic> _stats = {
    'totalUsers': 100,
    'premiumUsers': 30,
    'freeUsers': 65,
    'totalProviders': 20,
    'activeBookings': 245,
    'completedBookings': 3890,
    'revenue': 2850000, // Monthly revenue from subscriptions
    'pendingApprovals': 3,
    'todayBookings': 38,
    'monthlyGrowth': 22.5,
  };
  
  // Financial breakdown - Annual projections
  final Map<String, dynamic> _financials = {
    // Revenue Streams (Annual)
    'subscriptionRevenue': 34200000, // PKR 2.85M x 12 months
    'commissionRevenue': 7020000, // 15% commission on PKR 46.8M bookings/year
    'totalAnnualRevenue': 41220000, // Total PKR 41.22M/year
    
    // Operating Expenses (Annual)
    'expenses': {
      'hosting': {
        'webflow': 0, // Using Flutter (not Webflow)
        'firebase': 120000, // PKR 10,000/month x 12
        'cloudStorage': 60000, // PKR 5,000/month x 12
        'database': 180000, // MySQL hosting PKR 15,000/month x 12
      },
      'domain': {
        'domainRegistration': 15000, // PKR 15,000/year (.com domain)
        'ssl': 0, // Free with Firebase/Cloudflare
      },
      'apis': {
        'geminiAI': 240000, // Google Gemini API PKR 20,000/month x 12
        'maps': 120000, // Google Maps API PKR 10,000/month x 12
        'sms': 180000, // SMS notifications PKR 15,000/month x 12
      },
      'maintenance': {
        'serverMaintenance': 300000, // PKR 25,000/month x 12
        'bugFixes': 240000, // PKR 20,000/month x 12
        'updates': 180000, // PKR 15,000/month x 12
      },
      'marketing': {
        'googleAds': 600000, // PKR 50,000/month x 12
        'socialMedia': 360000, // PKR 30,000/month x 12
        'seo': 240000, // PKR 20,000/month x 12
      },
      'team': {
        'support': 1800000, // 2 agents @ PKR 75,000/month x 12
        'developer': 1200000, // Part-time @ PKR 100,000/month x 12
      },
    },
    'totalAnnualExpenses': 6035000, // Total PKR 6.035M/year
    'netProfit': 35185000, // PKR 41.22M - PKR 6.035M = PKR 35.185M/year
    'profitMargin': 85.4, // 85.4% profit margin
    
    // Valuation Metrics (for sale price calculation - not displayed)
    'monthlyRecurringRevenue': 2850000, // MRR from subscriptions
    'annualRecurringRevenue': 34200000, // ARR
    'valuationMultiple': 3.5, // Industry standard 3-4x ARR for SaaS
    'exclusiveSalePrice': 119700000, // PKR 119.7M (3.5x ARR) - NOT DISPLAYED
  };

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      backgroundColor: const Color(0xFF050509),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        title: const Row(
          children: [
            Icon(Icons.admin_panel_settings, color: Color(0xFFFFD700)),
            SizedBox(width: 12),
            Text('Admin Dashboard'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                // Refresh data
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Dashboard refreshed'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    child: user?.photoURL == null
                        ? const Icon(Icons.admin_panel_settings, size: 35)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome Back, Admin!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? 'admin@glamora.com',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Quick Stats Grid
            const Text(
              'Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard(
                  icon: Icons.people,
                  title: 'Total Users',
                  value: _stats['totalUsers'].toString(),
                  color: const Color(0xFF4285F4),
                  trend: '+${_stats['monthlyGrowth']}%',
                ),
                _buildStatCard(
                  icon: Icons.store,
                  title: 'Providers',
                  value: _stats['totalProviders'].toString(),
                  color: const Color(0xFF34A853),
                  trend: '+12',
                ),
                _buildStatCard(
                  icon: Icons.calendar_today,
                  title: 'Active Bookings',
                  value: _stats['activeBookings'].toString(),
                  color: const Color(0xFFFBBC05),
                  trend: '${_stats['todayBookings']} today',
                ),
                _buildStatCard(
                  icon: Icons.attach_money,
                  title: 'Revenue',
                  value: 'Rs ${(_stats['revenue'] / 1000).toStringAsFixed(0)}K',
                  color: const Color(0xFFEA4335),
                  trend: '+15.8%',
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Annual Revenue & Expense Breakdown
            const Text(
              'Annual Financial Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            
            // Revenue Section
            _buildFinancialCard(
              title: 'Annual Revenue',
              amount: _financials['totalAnnualRevenue'],
              color: const Color(0xFF34A853),
              icon: Icons.trending_up,
              items: [
                {'label': 'Subscription Revenue', 'value': _financials['subscriptionRevenue']},
                {'label': 'Commission Revenue (15%)', 'value': _financials['commissionRevenue']},
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Expenses Breakdown
            _buildFinancialCard(
              title: 'Annual Expenses',
              amount: _financials['totalAnnualExpenses'],
              color: const Color(0xFFEA4335),
              icon: Icons.receipt_long,
              items: _buildExpenseItems(),
            ),
            
            const SizedBox(height: 16),
            
            // Net Profit
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(Icons.account_balance_wallet, color: Colors.white, size: 28),
                      SizedBox(width: 12),
                      Text(
                        'Net Annual Profit',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'PKR ${(_financials['netProfit'] / 1000000).toStringAsFixed(2)}M',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Profit Margin: ${_financials['profitMargin'].toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Pending Approvals Alert
            if (_stats['pendingApprovals'] > 0)
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber, color: Colors.orange, size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pending Approvals',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${_stats['pendingApprovals']} providers waiting for approval',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AdminProvidersScreen(),
                          ),
                        );
                      },
                      child: const Text('Review'),
                    ),
                  ],
                ),
              ),
            
            // Management Options
            const Text(
              'Management',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildManagementOption(
              icon: Icons.people_outline,
              title: 'User Management',
              subtitle: '${_stats['totalUsers']} registered users',
              color: const Color(0xFF4285F4),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AdminUsersScreen(),
                  ),
                );
              },
            ),
            
            _buildManagementOption(
              icon: Icons.store_outlined,
              title: 'Service Providers',
              subtitle: '${_stats['totalProviders']} active providers',
              color: const Color(0xFF34A853),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AdminProvidersScreen(),
                  ),
                );
              },
            ),
            
            _buildManagementOption(
              icon: Icons.calendar_today_outlined,
              title: 'Booking Management',
              subtitle: '${_stats['activeBookings']} active bookings',
              color: const Color(0xFFFBBC05),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AdminBookingsScreen(),
                  ),
                );
              },
            ),
            
            _buildManagementOption(
              icon: Icons.analytics_outlined,
              title: 'Revenue & Analytics',
              subtitle: 'Track earnings and commissions',
              color: const Color(0xFFEA4335),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AdminRevenueScreen(),
                  ),
                );
              },
            ),
            
            _buildManagementOption(
              icon: Icons.settings_outlined,
              title: 'App Settings',
              subtitle: 'Configure app parameters',
              color: const Color(0xFFA855F7),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AdminSettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    String? trend,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.2),
            color.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 28),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    trend,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildManagementOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
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
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper method to build expense items
  List<Map<String, dynamic>> _buildExpenseItems() {
    final expenses = _financials['expenses'] as Map<String, dynamic>;
    List<Map<String, dynamic>> items = [];
    
    // Hosting expenses
    final hosting = expenses['hosting'] as Map<String, dynamic>;
    items.add({'label': 'Firebase Hosting', 'value': hosting['firebase']});
    items.add({'label': 'Cloud Storage', 'value': hosting['cloudStorage']});
    items.add({'label': 'MySQL Database', 'value': hosting['database']});
    
    // Domain
    final domain = expenses['domain'] as Map<String, dynamic>;
    items.add({'label': 'Domain Registration', 'value': domain['domainRegistration']});
    
    // APIs
    final apis = expenses['apis'] as Map<String, dynamic>;
    items.add({'label': 'Google Gemini AI', 'value': apis['geminiAI']});
    items.add({'label': 'Google Maps API', 'value': apis['maps']});
    items.add({'label': 'SMS Notifications', 'value': apis['sms']});
    
    // Maintenance
    final maintenance = expenses['maintenance'] as Map<String, dynamic>;
    items.add({'label': 'Server Maintenance', 'value': maintenance['serverMaintenance']});
    items.add({'label': 'Bug Fixes & Updates', 'value': maintenance['bugFixes'] + maintenance['updates']});
    
    // Marketing
    final marketing = expenses['marketing'] as Map<String, dynamic>;
    items.add({'label': 'Google Ads', 'value': marketing['googleAds']});
    items.add({'label': 'Social Media Marketing', 'value': marketing['socialMedia']});
    items.add({'label': 'SEO Services', 'value': marketing['seo']});
    
    // Team
    final team = expenses['team'] as Map<String, dynamic>;
    items.add({'label': 'Support Team', 'value': team['support']});
    items.add({'label': 'Developer (Part-time)', 'value': team['developer']});
    
    return items;
  }
  
  // Helper method to build financial card
  Widget _buildFinancialCard({
    required String title,
    required int amount,
    required Color color,
    required IconData icon,
    required List<Map<String, dynamic>> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'PKR ${(amount / 1000000).toStringAsFixed(2)}M',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item['label'],
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  'PKR ${(item['value'] / 1000).toStringAsFixed(0)}K',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
