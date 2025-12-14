// Service Category Model
class ServiceCategory {
  final String id;
  final String name;
  final String icon;
  final String description;
  final List<String> subCategories;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.subCategories,
  });
}

// Pre-defined categories
class ServiceCategories {
  static List<ServiceCategory> getAllCategories() {
    return [
      ServiceCategory(
        id: 'salon',
        name: 'Salon',
        icon: '💇',
        description: 'Haircut, Hair Color, Hair Spa',
        subCategories: ['Haircut', 'Hair Color', 'Hair Spa', 'Hair Treatment', 'Keratin'],
      ),
      ServiceCategory(
        id: 'parlour',
        name: 'Parlour',
        icon: '💄',
        description: 'Facial, Cleanup, Threading',
        subCategories: ['Facial', 'Cleanup', 'Threading', 'Waxing', 'Bleach'],
      ),
      ServiceCategory(
        id: 'beautician_home',
        name: 'Beautician at Home',
        icon: '🏠',
        description: 'Home service for makeup, facial',
        subCategories: ['Bridal Makeup', 'Party Makeup', 'Facial at Home', 'Mehndi at Home'],
      ),
      ServiceCategory(
        id: 'spa',
        name: 'Spa Center',
        icon: '🧖',
        description: 'Full body massage, Spa treatments',
        subCategories: ['Swedish Massage', 'Deep Tissue', 'Hot Stone', 'Aromatherapy'],
      ),
      ServiceCategory(
        id: 'massage',
        name: 'Massage Therapy',
        icon: '💆',
        description: 'Therapeutic massages',
        subCategories: ['Head Massage', 'Foot Massage', 'Back Massage', 'Full Body'],
      ),
      ServiceCategory(
        id: 'makeup_artist',
        name: 'Makeup Artist',
        icon: '💋',
        description: 'Professional makeup services',
        subCategories: ['Bridal Makeup', 'Party Makeup', 'Fashion Makeup', 'Engagement Makeup'],
      ),
      ServiceCategory(
        id: 'mehndi',
        name: 'Mehndi Artist',
        icon: '🎨',
        description: 'Bridal & Arabic mehndi',
        subCategories: ['Bridal Mehndi', 'Arabic Mehndi', 'Simple Mehndi', 'Glitter Mehndi'],
      ),
    ];
  }
}
