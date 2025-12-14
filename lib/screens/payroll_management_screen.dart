import 'package:flutter/material.dart';
import '../models/financial.dart';

class PayrollManagementScreen extends StatefulWidget {
  const PayrollManagementScreen({super.key});

  @override
  State<PayrollManagementScreen> createState() => _PayrollManagementScreenState();
}

class _PayrollManagementScreenState extends State<PayrollManagementScreen> {
  String _selectedTab = 'pending';
  
  // Mock payroll data
  final List<StaffPayroll> _payrolls = [
    StaffPayroll(
      id: '1',
      staffId: 'S001',
      staffName: 'Ayesha Khan',
      basicSalary: 40000,
      commission: 8000,
      bonus: 5000,
      deductions: 2000,
      paymentDate: DateTime(2025, 12, 31),
      status: 'pending',
    ),
    StaffPayroll(
      id: '2',
      staffId: 'S002',
      staffName: 'Maria Ali',
      basicSalary: 45000,
      commission: 12000,
      bonus: 3000,
      deductions: 1500,
      paymentDate: DateTime(2025, 12, 31),
      status: 'pending',
    ),
    StaffPayroll(
      id: '3',
      staffId: 'S003',
      staffName: 'Sana Ahmed',
      basicSalary: 35000,
      commission: 6000,
      bonus: 2000,
      deductions: 1000,
      paymentDate: DateTime(2025, 11, 30),
      status: 'paid',
    ),
  ];

  List<StaffPayroll> get _filteredPayrolls {
    return _payrolls.where((p) => p.status == _selectedTab).toList();
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = _payrolls.where((p) => p.status == 'pending').length;
    final totalPending = _payrolls
        .where((p) => p.status == 'pending')
        .fold(0.0, (sum, p) => sum + p.totalSalary);

    return Scaffold(
      backgroundColor: const Color(0xFF050509),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        title: const Text('Payroll Management'),
        actions: [
          if (pendingCount > 0)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.pending_actions, size: 16),
                  const SizedBox(width: 4),
                  Text('$pendingCount Pending'),
                ],
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          _buildSummaryCard(pendingCount, totalPending),
          Expanded(
            child: _buildPayrollList(),
          ),
        ],
      ),
      floatingActionButton: _selectedTab == 'pending'
          ? FloatingActionButton.extended(
              onPressed: _processAllPayments,
              icon: const Icon(Icons.payments),
              label: const Text('Process All'),
              backgroundColor: Colors.green,
            )
          : null,
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          _buildTab('pending', 'Pending', Icons.pending_actions),
          _buildTab('paid', 'Paid', Icons.check_circle),
        ],
      ),
    );
  }

  Widget _buildTab(String id, String label, IconData icon) {
    final isSelected = _selectedTab == id;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = id;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFFF8D7C4), Color(0xFFA855F7)],
                  )
                : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.white60,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : Colors.white60,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(int pendingCount, double totalPending) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withValues(alpha: 0.2),
            Colors.purple.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.purple.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.payments, color: Colors.purple, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedTab == 'pending' ? 'Pending Payments' : 'Paid This Month',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rs ${_selectedTab == 'pending' ? totalPending.toInt() : _payrolls.where((p) => p.status == 'paid').fold(0.0, (sum, p) => sum + p.totalSalary).toInt()}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${_selectedTab == 'pending' ? pendingCount : _payrolls.where((p) => p.status == 'paid').length} Staff Members',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayrollList() {
    if (_filteredPayrolls.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _selectedTab == 'pending' ? Icons.check_circle : Icons.payments,
              size: 64,
              color: Colors.white.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              _selectedTab == 'pending'
                  ? 'No Pending Payments'
                  : 'No Payment History',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredPayrolls.length,
      itemBuilder: (context, index) {
        final payroll = _filteredPayrolls[index];
        return _buildPayrollCard(payroll);
      },
    );
  }

  Widget _buildPayrollCard(StaffPayroll payroll) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          color: Colors.white.withValues(alpha: 0.2),
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
                child: const Icon(Icons.person, color: Color(0xFFF8D7C4)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      payroll.staffName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Staff ID: ${payroll.staffId}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: payroll.status == 'paid' ? Colors.green : Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  payroll.status.toUpperCase(),
                  style: const TextStyle(
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
          
          // Salary Breakdown
          _buildSalaryRow('Basic Salary', payroll.basicSalary, Colors.white),
          const SizedBox(height: 8),
          _buildSalaryRow('Commission', payroll.commission, Colors.green),
          const SizedBox(height: 8),
          _buildSalaryRow('Bonus', payroll.bonus, Colors.blue),
          const SizedBox(height: 8),
          _buildSalaryRow('Deductions', payroll.deductions, Colors.red, isNegative: true),
          
          const SizedBox(height: 12),
          const Divider(color: Colors.white24, thickness: 2),
          const SizedBox(height: 12),
          
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Salary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Rs ${payroll.totalSalary.toInt()}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF8D7C4),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 14,
                color: Colors.white.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 4),
              Text(
                'Payment Date: ${payroll.paymentDate.day}/${payroll.paymentDate.month}/${payroll.paymentDate.year}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          
          if (payroll.status == 'pending') ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _markAsPaid(payroll),
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Mark as Paid'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () => _editPayroll(payroll),
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFF8D7C4),
                    side: const BorderSide(color: Color(0xFFF8D7C4)),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSalaryRow(String label, double amount, Color color, {bool isNegative = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
        Text(
          '${isNegative ? '-' : '+'}Rs ${amount.toInt()}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  void _markAsPaid(StaffPayroll payroll) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        title: const Text('Confirm Payment', style: TextStyle(color: Colors.white)),
        content: Text(
          'Mark payroll as paid for ${payroll.staffName}?\nAmount: Rs ${payroll.totalSalary.toInt()}',
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
                final index = _payrolls.indexWhere((p) => p.id == payroll.id);
                if (index != -1) {
                  _payrolls[index] = StaffPayroll(
                    id: payroll.id,
                    staffId: payroll.staffId,
                    staffName: payroll.staffName,
                    basicSalary: payroll.basicSalary,
                    commission: payroll.commission,
                    bonus: payroll.bonus,
                    deductions: payroll.deductions,
                    paymentDate: DateTime.now(),
                    status: 'paid',
                  );
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Payment marked as paid for ${payroll.staffName}'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _editPayroll(StaffPayroll payroll) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit payroll for ${payroll.staffName}')),
    );
  }

  void _processAllPayments() {
    final pendingPayrolls = _payrolls.where((p) => p.status == 'pending').toList();
    if (pendingPayrolls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No pending payments')),
      );
      return;
    }

    final totalAmount = pendingPayrolls.fold(0.0, (sum, p) => sum + p.totalSalary);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        title: const Text('Process All Payments', style: TextStyle(color: Colors.white)),
        content: Text(
          'Process ${pendingPayrolls.length} payments?\nTotal Amount: Rs ${totalAmount.toInt()}',
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
                for (var i = 0; i < _payrolls.length; i++) {
                  if (_payrolls[i].status == 'pending') {
                    _payrolls[i] = StaffPayroll(
                      id: _payrolls[i].id,
                      staffId: _payrolls[i].staffId,
                      staffName: _payrolls[i].staffName,
                      basicSalary: _payrolls[i].basicSalary,
                      commission: _payrolls[i].commission,
                      bonus: _payrolls[i].bonus,
                      deductions: _payrolls[i].deductions,
                      paymentDate: DateTime.now(),
                      status: 'paid',
                    );
                  }
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All payments processed successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Process All'),
          ),
        ],
      ),
    );
  }
}
