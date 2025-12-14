import 'package:flutter/material.dart';
import '../models/financial.dart';

class InventoryManagementScreen extends StatefulWidget {
  const InventoryManagementScreen({super.key});

  @override
  State<InventoryManagementScreen> createState() => _InventoryManagementScreenState();
}

class _InventoryManagementScreenState extends State<InventoryManagementScreen> {
  String _selectedCategory = 'All';
  
  // Mock inventory data
  final List<InventoryItem> _inventory = [
    InventoryItem(
      id: '1',
      name: 'Hair Color - Black',
      category: 'Hair Products',
      quantity: 15,
      costPrice: 800,
      sellingPrice: 1500,
      minStockLevel: 10,
      supplier: 'Beauty Supplies Co',
    ),
    InventoryItem(
      id: '2',
      name: 'Facial Cream',
      category: 'Skin Care',
      quantity: 5,
      costPrice: 1200,
      sellingPrice: 2000,
      minStockLevel: 8,
      supplier: 'Skin Care Direct',
    ),
    InventoryItem(
      id: '3',
      name: 'Makeup Brushes Set',
      category: 'Makeup Tools',
      quantity: 20,
      costPrice: 1500,
      sellingPrice: 3000,
      minStockLevel: 5,
      supplier: 'Beauty Tools Ltd',
    ),
    InventoryItem(
      id: '4',
      name: 'Nail Polish - Red',
      category: 'Nail Care',
      quantity: 3,
      costPrice: 300,
      sellingPrice: 600,
      minStockLevel: 10,
      supplier: 'Nail Pro',
    ),
  ];

  List<String> get _categories {
    final cats = _inventory.map((item) => item.category).toSet().toList();
    return ['All', ...cats];
  }

  List<InventoryItem> get _filteredInventory {
    if (_selectedCategory == 'All') return _inventory;
    return _inventory.where((item) => item.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final lowStockItems = _inventory.where((item) => item.isLowStock).length;
    
    return Scaffold(
      backgroundColor: const Color(0xFF050509),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        title: const Text('Inventory Management'),
        actions: [
          if (lowStockItems > 0)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, size: 16),
                  const SizedBox(width: 4),
                  Text('$lowStockItems Low Stock'),
                ],
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          _buildStatsRow(),
          Expanded(
            child: _buildInventoryList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addInventoryItem,
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
        backgroundColor: const Color(0xFFA855F7),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFFF8D7C4), Color(0xFFA855F7)],
                      )
                    : null,
                color: isSelected ? null : const Color(0xFF111827),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : Colors.white.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white60,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsRow() {
    final totalItems = _filteredInventory.length;
    final totalValue = _filteredInventory.fold(
      0.0,
      (sum, item) => sum + (item.quantity * item.costPrice),
    );
    final lowStock = _filteredInventory.where((item) => item.isLowStock).length;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Items',
              '$totalItems',
              Icons.inventory_2,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Total Value',
              'Rs ${totalValue.toInt()}',
              Icons.attach_money,
              Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Low Stock',
              '$lowStock',
              Icons.warning,
              Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.2),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredInventory.length,
      itemBuilder: (context, index) {
        final item = _filteredInventory[index];
        return _buildInventoryCard(item);
      },
    );
  }

  Widget _buildInventoryCard(InventoryItem item) {
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isLowStock
              ? Colors.red.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.2),
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
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFF8D7C4).withValues(alpha: 0.3),
                      const Color(0xFFA855F7).withValues(alpha: 0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.inventory, color: Color(0xFFF8D7C4)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.category,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              if (item.isLowStock)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'LOW',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 16),
          const Divider(color: Colors.white12),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildInfoColumn('Quantity', '${item.quantity}', Icons.numbers),
              ),
              Expanded(
                child: _buildInfoColumn('Cost', 'Rs ${item.costPrice.toInt()}', Icons.shopping_cart),
              ),
              Expanded(
                child: _buildInfoColumn('Selling', 'Rs ${item.sellingPrice.toInt()}', Icons.sell),
              ),
              Expanded(
                child: _buildInfoColumn('Min', '${item.minStockLevel}', Icons.warning_amber),
              ),
            ],
          ),
          
          if (item.supplier != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.local_shipping,
                  size: 14,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  'Supplier: ${item.supplier}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _editItem(item),
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFF8D7C4),
                    side: const BorderSide(color: Color(0xFFF8D7C4)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _updateStock(item),
                  icon: const Icon(Icons.add_circle, size: 16),
                  label: const Text('Add Stock'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green,
                    side: const BorderSide(color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _deleteItem(item.id),
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.white.withValues(alpha: 0.6),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  void _addInventoryItem() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add Item dialog coming soon!')),
    );
  }

  void _editItem(InventoryItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit item: ${item.name}')),
    );
  }

  void _updateStock(InventoryItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Update stock for: ${item.name}')),
    );
  }

  void _deleteItem(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        title: const Text('Delete Item?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to delete this inventory item?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _inventory.removeWhere((item) => item.id == id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Item deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
