import 'package:flutter/material.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  String _searchQuery = '';
  String _filterStatus = 'all'; // all, active, blocked
  
  // Mock user data
  final List<Map<String, dynamic>> _users = [
    {
      'id': '1',
      'name': 'Ahmed Khan',
      'email': 'ahmed@example.com',
      'phone': '+92-300-1234567',
      'role': 'customer',
      'status': 'active',
      'joinDate': '2024-01-15',
      'totalBookings': 24,
      'totalSpent': 45000,
    },
    {
      'id': '2',
      'name': 'Sara Ali',
      'email': 'sara@example.com',
      'phone': '+92-301-9876543',
      'role': 'customer',
      'status': 'active',
      'joinDate': '2024-02-20',
      'totalBookings': 18,
      'totalSpent': 32500,
    },
    {
      'id': '3',
      'name': 'Hassan Raza',
      'email': 'hassan@example.com',
      'phone': '+92-333-5555555',
      'role': 'customer',
      'status': 'blocked',
      'joinDate': '2024-03-10',
      'totalBookings': 5,
      'totalSpent': 8000,
    },
  ];
  
  List<Map<String, dynamic>> get _filteredUsers {
    return _users.where((user) {
      final matchesSearch = user['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
                           user['email'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _filterStatus == 'all' || user['status'] == _filterStatus;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050509),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        title: const Text('User Management'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search users...',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              // Filter Chips
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Row(
                  children: [
                    _buildFilterChip('All', 'all'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Active', 'active'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Blocked', 'blocked'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredUsers.length,
        itemBuilder: (context, index) {
          final user = _filteredUsers[index];
          return _buildUserCard(user);
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
          color: isSelected ? const Color(0xFF4285F4) : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF4285F4) : Colors.white.withValues(alpha: 0.3),
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
  
  Widget _buildUserCard(Map<String, dynamic> user) {
    final isBlocked = user['status'] == 'blocked';
    
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
          color: isBlocked ? Colors.red.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: const Color(0xFF4285F4),
                child: Text(
                  user['name'].toString().substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            user['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isBlocked ? Colors.red : const Color(0xFF34A853),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isBlocked ? 'BLOCKED' : 'ACTIVE',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user['email'],
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
          const SizedBox(height: 12),
          const Divider(color: Colors.white24),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoChip(Icons.calendar_today, 'Joined: ${user['joinDate']}'),
              _buildInfoChip(Icons.shopping_bag, '${user['totalBookings']} bookings'),
              _buildInfoChip(Icons.attach_money, 'Rs ${(user['totalSpent'] / 1000).toStringAsFixed(0)}K'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _viewUserDetails(user),
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('View Details'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _toggleUserStatus(user),
                  icon: Icon(isBlocked ? Icons.check_circle : Icons.block, size: 16),
                  label: Text(isBlocked ? 'Unblock' : 'Block'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isBlocked ? const Color(0xFF34A853) : Colors.red,
                  ),
                ),
              ),
            ],
          ),
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
  
  void _viewUserDetails(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        title: Text(user['name'], style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Email:', user['email']),
            _buildDetailRow('Phone:', user['phone']),
            _buildDetailRow('Role:', user['role']),
            _buildDetailRow('Status:', user['status']),
            _buildDetailRow('Join Date:', user['joinDate']),
            _buildDetailRow('Total Bookings:', user['totalBookings'].toString()),
            _buildDetailRow('Total Spent:', 'Rs ${user['totalSpent']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
  
  void _toggleUserStatus(Map<String, dynamic> user) {
    final isBlocked = user['status'] == 'blocked';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        title: Text(
          isBlocked ? 'Unblock User?' : 'Block User?',
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          isBlocked
              ? 'Are you sure you want to unblock ${user['name']}? They will regain access to the app.'
              : 'Are you sure you want to block ${user['name']}? They will lose access to the app.',
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
                user['status'] = isBlocked ? 'active' : 'blocked';
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('User ${isBlocked ? 'unblocked' : 'blocked'} successfully'),
                  backgroundColor: isBlocked ? const Color(0xFF34A853) : Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isBlocked ? const Color(0xFF34A853) : Colors.red,
            ),
            child: Text(isBlocked ? 'Unblock' : 'Block'),
          ),
        ],
      ),
    );
  }
}
