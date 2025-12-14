import 'ai_style.dart';

// Booking Model
class Booking {
  final String id;
  final String userId;
  final String providerId;
  final String providerName;
  final List<BookingService> services;
  final DateTime bookingDate;
  final String timeSlot;
  final BookingType bookingType; // in-salon or at-home
  final BookingStatus status;
  final double totalAmount;
  final String? customerAddress; // for at-home service
  final String? customerPhone;
  final String? customerName;
  final String? specialInstructions;
  final DateTime createdAt;
  final String? assignedStaffId;
  final String? assignedStaffName;
  final PaymentStatus paymentStatus;
  final PaymentMethod? paymentMethod;
  final CustomerStyleSelection? aiStyleSelection; // AI-selected styles

  Booking({
    required this.id,
    required this.userId,
    required this.providerId,
    required this.providerName,
    required this.services,
    required this.bookingDate,
    required this.timeSlot,
    required this.bookingType,
    required this.status,
    required this.totalAmount,
    this.customerAddress,
    this.customerPhone,
    this.customerName,
    this.specialInstructions,
    required this.createdAt,
    this.assignedStaffId,
    this.assignedStaffName,
    required this.paymentStatus,
    this.paymentMethod,
    this.aiStyleSelection,
  });

  int get totalDuration {
    return services.fold(0, (sum, service) => sum + service.duration);
  }
}

// Booking Service (service within a booking)
class BookingService {
  final String serviceId;
  final String serviceName;
  final double price;
  final int duration; // in minutes
  final String? staffId;
  final String? staffName;

  BookingService({
    required this.serviceId,
    required this.serviceName,
    required this.price,
    required this.duration,
    this.staffId,
    this.staffName,
  });
}

// Booking Type
enum BookingType {
  inSalon,
  atHome,
}

// Booking Status
enum BookingStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
  noShow,
}

// Payment Status
enum PaymentStatus {
  pending,
  paid,
  refunded,
  failed,
}

// Payment Method
enum PaymentMethod {
  cash,
  jazzCash,
  easyPaisa,
  card,
  wallet,
}

// Time Slot Model
class TimeSlot {
  final String time;
  final bool isAvailable;
  final int availableStaff;
  final String displayTime;

  TimeSlot({
    required this.time,
    required this.isAvailable,
    required this.availableStaff,
    required this.displayTime,
  });
}

// Staff Model
class StaffMember {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final int totalReviews;
  final List<String> specialities;
  final bool isAvailable;
  final String? nextAvailableTime;

  StaffMember({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.totalReviews,
    required this.specialities,
    required this.isAvailable,
    this.nextAvailableTime,
  });
}
