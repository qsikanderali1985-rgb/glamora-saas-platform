class Salon {
  final String id;
  final String name;
  final double rating;
  final double distanceKm;
  final String audienceLabel;
  final String priceSummary;

  const Salon({
    required this.id,
    required this.name,
    required this.rating,
    required this.distanceKm,
    required this.audienceLabel,
    required this.priceSummary,
  });
}

class Service {
  final String id;
  final String salonId;
  final String title;
  final String priceLabel;

  const Service({
    required this.id,
    required this.salonId,
    required this.title,
    required this.priceLabel,
  });
}

class BookingSummaryStats {
  final int todayBookings;
  final double todayRevenue;

  const BookingSummaryStats({
    required this.todayBookings,
    required this.todayRevenue,
  });
}

const mockSalons = <Salon>[
  Salon(
    id: 'salon_1',
    name: 'Luxe Glow Studio',
    rating: 4.9,
    distanceKm: 0.8,
    audienceLabel: 'Women & Men',
    priceSummary: 'Starting from PKR 1,500',
  ),
  Salon(
    id: 'salon_2',
    name: 'Emerald Spa Lounge',
    rating: 4.7,
    distanceKm: 1.2,
    audienceLabel: 'Spa & Wellness',
    priceSummary: 'Packages from PKR 3,000',
  ),
  Salon(
    id: 'salon_3',
    name: 'Neon Fade Barbers',
    rating: 4.8,
    distanceKm: 0.5,
    audienceLabel: 'Men\'s Grooming',
    priceSummary: 'Cuts from PKR 900',
  ),
];

const mockServicesForSalon1 = <Service>[
  Service(
    id: 'svc_1',
    salonId: 'salon_1',
    title: 'Soft glam makeup',
    priceLabel: 'PKR 4,500',
  ),
  Service(
    id: 'svc_2',
    salonId: 'salon_1',
    title: 'Luxury haircut & blowdry',
    priceLabel: 'PKR 2,800',
  ),
  Service(
    id: 'svc_3',
    salonId: 'salon_1',
    title: 'Bridal signature look',
    priceLabel: 'PKR 18,000',
  ),
];

const mockBookingStats = BookingSummaryStats(
  todayBookings: 18,
  todayRevenue: 45200,
);
