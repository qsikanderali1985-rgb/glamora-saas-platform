import 'package:flutter/material.dart';

class AdminProvidersScreen extends StatefulWidget {
  const AdminProvidersScreen({super.key});

  @override
  State<AdminProvidersScreen> createState() => _AdminProvidersScreenState();
}

class _AdminProvidersScreenState extends State<AdminProvidersScreen> {
  String _filterStatus = 'all'; // all, pending, approved, rejected
  
  // Mock provider data
  final List<Map<String, dynamic>> _providers = [
    {
      'id': '1',
      'name': 'Glow Beauty Salon',
      'owner': 'Fatima Ahmed',
      'email': 'fatima@glow.com',
      'phone': '+92-300-1111111',
      'address': 'F-7 Markaz, Islamabad',
      'type': 'salon',
      'status': 'approved',
      'joinDate': '2024-01-10',
      'totalBookings': 234,
      'rating': 4.9,
      'commission': 15,
    },
    {
      'id': '2',
      'name': 'Elite Gentleman Barber',
      'owner': 'Ali Hassan',
      'email': 'ali@elite.com',
      'phone': '+92-301-2222222',
      'address': 'G-11 Markaz, Islamabad',
      'type': 'barber',
      'status': 'approved',
      'joinDate': '2024-02-15',
      'totalBookings': 456,
      'rating': 4.7,
      'commission': 15,
    },
    {
      'id': '3',
      'name': 'Beauty Haven',
      'owner': 'Zainab Khan',
      'email': 'zainab@haven.com',
      'phone': '+92-333-3333333',
      'address': 'F-10 Markaz, Islamabad',
      'type': 'salon',
      'status': 'pending',
      'joinDate': '2024-12-10',
      'totalBookings': 0,
      'rating': 0.0,
      'commission': 15,
    },
  ];
  
  List<Map<String, dynamic>> get _filteredProviders {
    if (_filterStatus == 'all') return _providers;
    return _providers.where((p) => p['status'] == _filterStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = _providers.where((p) => p['status'] == 'pending').length;
    
    return Scaffold(
      backgroundColor: const Color(0xFF050509),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        title: const Text('Service Providers'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildFilterChip('All', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('Pending ($pendingCount)', 'pending'),
                const SizedBox(width: 8),
                _buildFilterChip('Approved', 'approved'),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredProviders.length,
        itemBuilder: (context, index) {
          final provider = _filteredProviders[index];
          return _buildProviderCard(provider);
        },
      ),
    );
  }
  
  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filterStatus == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _filterStatus = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF34A853) : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF34A853) : Colors.white.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.7),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
  
  Widget _buildProviderCard(Map<String, dynamic> provider) {
    final isPending = provider['status'] == 'pending';
    final isApproved = provider['status'] == 'approved';
    
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
          color: isPending
              ? Colors.orange.withValues(alpha: 0.5)
              : isApproved
                  ? Colors.green.withValues(alpha: 0.5)
                  : Colors.red.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF34A853).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  provider['type'] == 'barber' ? Icons.face_retouching_natural : Icons.spa,
                  color: const Color(0xFF34A853),
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Owner: ${provider['owner']}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPending
                      ? Colors.orange
                      : isApproved
                          ? const Color(0xFF34A853)
                          : Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isPending ? 'PENDING' : isApproved ? 'APPROVED' : 'REJECTED',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            provider['address'],
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: Colors.white24),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isApproved) ...[
                _buildInfoChip(Icons.shopping_bag, '${provider['totalBookings']} bookings'),
                _buildInfoChip(Icons.star, '${provider['rating']} rating'),
                _buildInfoChip(Icons.percent, '${provider['commission']}% commission'),
              ] else
                _buildInfoChip(Icons.calendar_today, 'Applied: ${provider['joinDate']}'),
            ],
          ),
          if (isPending) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _approveProvider(provider),
                    icon: const Icon(Icons.check_circle, size: 16),
                    label: const Text('Approve'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF34A853),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _rejectProvider(provider),
                    icon: const Icon(Icons.cancel, size: 16),
                    label: const Text('Reject'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.6)),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
  
  void _approveProvider(Map<String, dynamic> provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        title: const Text('Approve Provider?', style: TextStyle(color: Colors.white)),
        content: Text(
          'Approve ${provider['name']} to start accepting bookings?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                provider['status'] = 'approved';
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Provider approved successfully!'),
                  backgroundColor: Color(0xFF34A853),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF34A853),
            ),
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }
  
  void _rejectProvider(Map<String, dynamic> provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        title: const Text('Reject Provider?', style: TextStyle(color: Colors.white)),
        content: Text(
          'Reject ${provider['name']}? They will be notified.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                provider['status'] = 'rejected';
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Provider rejected'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }
}
