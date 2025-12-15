import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PromotionsScreen extends StatefulWidget {
  const PromotionsScreen({super.key});

  @override
  State<PromotionsScreen> createState() => _PromotionsScreenState();
}

class _PromotionsScreenState extends State<PromotionsScreen> {
  List<Map<String, dynamic>> _promotions = [];
  
  @override
  void initState() {
    super.initState();
    _loadPromotions();
  }
  
  Future<void> _loadPromotions() async {
    final prefs = await SharedPreferences.getInstance();
    final promotionsJson = prefs.getString('promotions') ?? '[]';
    setState(() {
      _promotions = List<Map<String, dynamic>>.from(jsonDecode(promotionsJson));
    });
  }
  
  Future<void> _savePromotions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('promotions', jsonEncode(_promotions));
  }

  void _createPromotion() {
    showDialog(
      context: context,
      builder: (context) => _CreatePromotionDialog(
        onAdd: (promoData) {
          setState(() {
            _promotions.add(promoData);
          });
          _savePromotions();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Promotion created successfully!'),
              backgroundColor: Color(0xFF34A853),
            ),
          );
        },
      ),
    );
  }
  
  void _togglePromotion(int index) {
    setState(() {
      _promotions[index]['active'] = !_promotions[index]['active'];
    });
    _savePromotions();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_promotions[index]['active']
            ? 'Promotion activated!'
            : 'Promotion deactivated'),
        backgroundColor: _promotions[index]['active']
            ? const Color(0xFF34A853)
            : Colors.orange,
      ),
    );
  }
  
  void _deletePromotion(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        title: const Text('Delete Promotion?', style: TextStyle(color: Colors.white)),
        content: Text(
          'Remove "${_promotions[index]['title']}" promotion?',
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
                _promotions.removeAt(index);
              });
              _savePromotions();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Promotion deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activePromotions = _promotions.where((p) => p['active'] == true).length;
    
    return Scaffold(
      backgroundColor: const Color(0xFF050509),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        title: const Text('Promotions & Offers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createPromotion,
            tooltip: 'Create Promotion',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF34A853), Color(0xFF0F9D58)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_offer, size: 40, color: Colors.white),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Active Promotions',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$activePromotions active • ${_promotions.length - activePromotions} inactive',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            if (_promotions.isEmpty)
              // Empty State
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(48),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.local_offer,
                      size: 80,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No promotions yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create offers to attract more customers',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _createPromotion,
                      icon: const Icon(Icons.add),
                      label: const Text('Create Promotion'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF34A853),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                    ),
                  ],
                ),
              )
            else
              // Promotions List
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'All Promotions (${_promotions.length})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _createPromotion,
                        icon: const Icon(Icons.add, color: Color(0xFF34A853)),
                        label: const Text(
                          'Create New',
                          style: TextStyle(color: Color(0xFF34A853)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...(_promotions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final promo = entry.value;
                    return _buildPromotionCard(promo, index);
                  })),
                ],
              ),
            
            const SizedBox(height: 32),
            
            // Tips
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
                  Icon(Icons.lightbulb, color: Colors.blue, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Tip: Offer 10-20% discounts during slow days to increase bookings!',
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
  
  Widget _buildPromotionCard(Map<String, dynamic> promo, int index) {
    final isActive = promo['active'] == true;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isActive
              ? [
                  const Color(0xFF34A853).withValues(alpha: 0.2),
                  const Color(0xFF34A853).withValues(alpha: 0.1),
                ]
              : [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.05),
                ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive
              ? const Color(0xFF34A853)
              : Colors.white.withValues(alpha: 0.2),
          width: isActive ? 2 : 1,
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
                  Icons.local_offer,
                  color: isActive ? const Color(0xFF34A853) : Colors.grey,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      promo['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      promo['description'],
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF34A853) : Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isActive ? 'ACTIVE' : 'INACTIVE',
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
          const Divider(color: Colors.white24),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.percent,
                    size: 16,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${promo['discount']}% OFF',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF34A853),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Until ${promo['endDate']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _togglePromotion(index),
                  icon: Icon(isActive ? Icons.pause : Icons.play_arrow, size: 16),
                  label: Text(isActive ? 'Deactivate' : 'Activate'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isActive ? Colors.orange : const Color(0xFF34A853),
                    side: BorderSide(
                      color: isActive ? Colors.orange : const Color(0xFF34A853),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _deletePromotion(index),
                  icon: const Icon(Icons.delete_outline, size: 16),
                  label: const Text('Delete'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CreatePromotionDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;
  
  const _CreatePromotionDialog({required this.onAdd});

  @override
  State<_CreatePromotionDialog> createState() => _CreatePromotionDialogState();
}

class _CreatePromotionDialogState extends State<_CreatePromotionDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  double _discount = 10;
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF111827),
      title: const Text('Create Promotion', style: TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Promotion Title',
                labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                hintText: 'e.g., Weekend Special',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                prefixIcon: const Icon(Icons.title, color: Color(0xFF34A853)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              style: const TextStyle(color: Colors.white),
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                hintText: 'e.g., Get 20% off on all services',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                prefixIcon: const Icon(Icons.description, color: Color(0xFF34A853)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discount: ${_discount.toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Slider(
                  value: _discount,
                  min: 5,
                  max: 50,
                  divisions: 9,
                  activeColor: const Color(0xFF34A853),
                  onChanged: (value) {
                    setState(() {
                      _discount = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today, color: Color(0xFF34A853)),
              title: const Text('End Date', style: TextStyle(color: Colors.white70)),
              subtitle: Text(
                _endDate.toString().substring(0, 10),
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _endDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  setState(() {
                    _endDate = date;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
              widget.onAdd({
                'title': _titleController.text,
                'description': _descriptionController.text,
                'discount': _discount.toInt(),
                'endDate': _endDate.toString().substring(0, 10),
                'active': true,
                'createdDate': DateTime.now().toString().substring(0, 10),
              });
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF34A853),
          ),
          child: const Text('Create'),
        ),
      ],
    );
  }
}
