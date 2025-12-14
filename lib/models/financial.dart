// Expense Model
class Expense {
  final String id;
  final String category;
  final String description;
  final double amount;
  final DateTime date;
  final String paymentMethod;
  final String? receipt;

  Expense({
    required this.id,
    required this.category,
    required this.description,
    required this.amount,
    required this.date,
    required this.paymentMethod,
    this.receipt,
  });
}

// Income Model
class Income {
  final String id;
  final String source;
  final String description;
  final double amount;
  final DateTime date;
  final String paymentMethod;
  final String? invoiceId;

  Income({
    required this.id,
    required this.source,
    required this.description,
    required this.amount,
    required this.date,
    required this.paymentMethod,
    this.invoiceId,
  });
}

// Inventory Item Model
class InventoryItem {
  final String id;
  final String name;
  final String category;
  final int quantity;
  final double costPrice;
  final double sellingPrice;
  final int minStockLevel;
  final String? supplier;

  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.costPrice,
    required this.sellingPrice,
    required this.minStockLevel,
    this.supplier,
  });

  bool get isLowStock => quantity <= minStockLevel;
}

// Staff Payroll Model
class StaffPayroll {
  final String id;
  final String staffId;
  final String staffName;
  final double basicSalary;
  final double commission;
  final double bonus;
  final double deductions;
  final DateTime paymentDate;
  final String status; // pending, paid

  StaffPayroll({
    required this.id,
    required this.staffId,
    required this.staffName,
    required this.basicSalary,
    required this.commission,
    required this.bonus,
    required this.deductions,
    required this.paymentDate,
    required this.status,
  });

  double get totalSalary => basicSalary + commission + bonus - deductions;
}

// Expense Categories
class ExpenseCategories {
  static const String rent = 'Rent';
  static const String utilities = 'Utilities';
  static const String supplies = 'Supplies';
  static const String marketing = 'Marketing';
  static const String salaries = 'Salaries';
  static const String maintenance = 'Maintenance';
  static const String other = 'Other';

  static List<String> get all => [
        rent,
        utilities,
        supplies,
        marketing,
        salaries,
        maintenance,
        other,
      ];
}

// Income Sources
class IncomeSources {
  static const String services = 'Services';
  static const String products = 'Products';
  static const String packages = 'Packages';
  static const String other = 'Other';

  static List<String> get all => [
        services,
        products,
        packages,
        other,
      ];
}
