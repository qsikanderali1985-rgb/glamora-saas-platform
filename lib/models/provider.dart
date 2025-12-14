// Service Provider (Salon/Spa/Beautician) Model
class ServiceProvider {
  final String id;
  final String name;
  final String type; // salon, parlour, spa, etc.
  final String address;
  final double latitude;
  final double longitude;
  final double rating;
  final int totalReviews;
  final String imageUrl;
  final List<String> services;
  final bool isVerified;
  final bool isOpen;
  final String openingTime;
  final String closingTime;
  final double distance; // in km
  final bool hasHomeService;
  final double deliveryFee;
  final int minBookingTime; // in minutes
  final List<String> specialities;

  ServiceProvider({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.totalReviews,
    required this.imageUrl,
    required this.services,
    required this.isVerified,
    required this.isOpen,
    required this.openingTime,
    required this.closingTime,
    required this.distance,
    required this.hasHomeService,
    required this.deliveryFee,
    required this.minBookingTime,
    required this.specialities,
  });
}

// Service Model
class Service {
  final String id;
  final String providerId;
  final String name;
  final String description;
  final double price;
  final int duration; // in minutes
  final String category;
  final String subcategory;
  final List<String> beforeAfterImages;
  final bool isAvailable;
  final double discount; // percentage
  final String? staffName;
  final String? staffImage;

  Service({
    required this.id,
    required this.providerId,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.category,
    required this.subcategory,
    required this.beforeAfterImages,
    required this.isAvailable,
    required this.discount,
    this.staffName,
    this.staffImage,
  });

  double get finalPrice => price - (price * discount / 100);
}

// Deal/Package Model
class DealPackage {
  final String id;
  final String providerId;
  final String title;
  final String description;
  final double originalPrice;
  final double discountedPrice;
  final List<String> includedServices;
  final DateTime validUntil;
  final bool isActive;
  final String imageUrl;
  final int maxBookings;
  final int currentBookings;

  DealPackage({
    required this.id,
    required this.providerId,
    required this.title,
    required this.description,
    required this.originalPrice,
    required this.discountedPrice,
    required this.includedServices,
    required this.validUntil,
    required this.isActive,
    required this.imageUrl,
    required this.maxBookings,
    required this.currentBookings,
  });

  double get discountPercentage => 
      ((originalPrice - discountedPrice) / originalPrice * 100);
}
