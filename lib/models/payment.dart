// Payment Models

enum PaymentMethod {
  jazzcash,
  easypaisa,
  creditCard,
  debitCard,
  wallet,
  cod,
}

enum PaymentStatus {
  pending,
  processing,
  success,
  failed,
  refunded,
}

enum TransactionType {
  credit,
  debit,
}

class Payment {
  final String id;
  final String bookingId;
  final double amount;
  final PaymentMethod method;
  final PaymentStatus status;
  final DateTime createdAt;
  final String? transactionId;
  final String? errorMessage;
  final Map<String, dynamic>? paymentDetails;

  Payment({
    required this.id,
    required this.bookingId,
    required this.amount,
    required this.method,
    required this.status,
    required this.createdAt,
    this.transactionId,
    this.errorMessage,
    this.paymentDetails,
  });

  String get methodName {
    switch (method) {
      case PaymentMethod.jazzcash:
        return 'JazzCash';
      case PaymentMethod.easypaisa:
        return 'EasyPaisa';
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.debitCard:
        return 'Debit Card';
      case PaymentMethod.wallet:
        return 'Glamora Wallet';
      case PaymentMethod.cod:
        return 'Cash on Delivery';
    }
  }

  String get statusText {
    switch (status) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.processing:
        return 'Processing';
      case PaymentStatus.success:
        return 'Success';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.refunded:
        return 'Refunded';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingId': bookingId,
      'amount': amount,
      'method': method.toString(),
      'status': status.toString(),
      'createdAt': createdAt.toIso8601String(),
      'transactionId': transactionId,
      'errorMessage': errorMessage,
      'paymentDetails': paymentDetails,
    };
  }
}

class Wallet {
  final String userId;
  double balance;
  final List<WalletTransaction> transactions;

  Wallet({
    required this.userId,
    required this.balance,
    this.transactions = const [],
  });

  void addMoney(double amount, String description) {
    balance += amount;
    transactions.insert(
      0,
      WalletTransaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: TransactionType.credit,
        amount: amount,
        description: description,
        timestamp: DateTime.now(),
      ),
    );
  }

  bool deductMoney(double amount, String description, {String? bookingId}) {
    if (balance >= amount) {
      balance -= amount;
      transactions.insert(
        0,
        WalletTransaction(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: TransactionType.debit,
          amount: amount,
          description: description,
          timestamp: DateTime.now(),
          relatedBookingId: bookingId,
        ),
      );
      return true;
    }
    return false;
  }
}

class WalletTransaction {
  final String id;
  final TransactionType type;
  final double amount;
  final String description;
  final DateTime timestamp;
  final String? relatedBookingId;

  WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.timestamp,
    this.relatedBookingId,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString(),
      'amount': amount,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'relatedBookingId': relatedBookingId,
    };
  }
}

class SavedCard {
  final String id;
  final String cardNumber; // Masked: **** **** **** 1234
  final String cardHolderName;
  final String expiryMonth;
  final String expiryYear;
  final CardBrand brand;
  final bool isDefault;

  SavedCard({
    required this.id,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryMonth,
    required this.expiryYear,
    required this.brand,
    this.isDefault = false,
  });

  String get expiryDate => '$expiryMonth/$expiryYear';

  String get brandName {
    switch (brand) {
      case CardBrand.visa:
        return 'Visa';
      case CardBrand.mastercard:
        return 'Mastercard';
      case CardBrand.americanExpress:
        return 'American Express';
      case CardBrand.unknown:
        return 'Card';
    }
  }
}

enum CardBrand {
  visa,
  mastercard,
  americanExpress,
  unknown,
}
