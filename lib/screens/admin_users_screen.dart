import 'package:flutter/material.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  String _searchQuery = '';
  String _filterStatus = 'all'; // all, active, blocked
  
  // Mock user data - 100 users with premium/free mix
  final List<Map<String, dynamic>> _users = [
    // PREMIUM USERS (30 users with active subscriptions)
    {'id': '1', 'name': 'Ahmed Khan', 'email': 'ahmed@example.com', 'phone': '+92-300-1234567', 'role': 'customer', 'status': 'active', 'joinDate': '2024-01-15', 'totalBookings': 45, 'totalSpent': 125000, 'isPremium': true, 'subscription': 'Gold', 'subscriptionEnd': '2025-01-15'},
    {'id': '2', 'name': 'Sara Ali', 'email': 'sara@example.com', 'phone': '+92-301-9876543', 'role': 'customer', 'status': 'active', 'joinDate': '2024-02-20', 'totalBookings': 38, 'totalSpent': 98000, 'isPremium': true, 'subscription': 'Platinum', 'subscriptionEnd': '2025-02-20'},
    {'id': '3', 'name': 'Fatima Noor', 'email': 'fatima@example.com', 'phone': '+92-333-1111111', 'role': 'customer', 'status': 'active', 'joinDate': '2024-01-05', 'totalBookings': 52, 'totalSpent': 145000, 'isPremium': true, 'subscription': 'Platinum', 'subscriptionEnd': '2025-01-05'},
    {'id': '4', 'name': 'Ali Raza', 'email': 'ali.raza@example.com', 'phone': '+92-321-2222222', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-12', 'totalBookings': 28, 'totalSpent': 67000, 'isPremium': true, 'subscription': 'Gold', 'subscriptionEnd': '2025-03-12'},
    {'id': '5', 'name': 'Ayesha Malik', 'email': 'ayesha@example.com', 'phone': '+92-345-3333333', 'role': 'customer', 'status': 'active', 'joinDate': '2024-02-08', 'totalBookings': 41, 'totalSpent': 110000, 'isPremium': true, 'subscription': 'Gold', 'subscriptionEnd': '2025-02-08'},
    {'id': '6', 'name': 'Usman Sheikh', 'email': 'usman@example.com', 'phone': '+92-300-4444444', 'role': 'customer', 'status': 'active', 'joinDate': '2024-01-20', 'totalBookings': 35, 'totalSpent': 89000, 'isPremium': true, 'subscription': 'Silver', 'subscriptionEnd': '2025-01-20'},
    {'id': '7', 'name': 'Zainab Ahmed', 'email': 'zainab@example.com', 'phone': '+92-311-5555555', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-01', 'totalBookings': 31, 'totalSpent': 78000, 'isPremium': true, 'subscription': 'Gold', 'subscriptionEnd': '2025-03-01'},
    {'id': '8', 'name': 'Hassan Ali', 'email': 'hassan.ali@example.com', 'phone': '+92-322-6666666', 'role': 'customer', 'status': 'active', 'joinDate': '2024-02-15', 'totalBookings': 44, 'totalSpent': 120000, 'isPremium': true, 'subscription': 'Platinum', 'subscriptionEnd': '2025-02-15'},
    {'id': '9', 'name': 'Mariam Khan', 'email': 'mariam@example.com', 'phone': '+92-333-7777777', 'role': 'customer', 'status': 'active', 'joinDate': '2024-01-10', 'totalBookings': 48, 'totalSpent': 135000, 'isPremium': true, 'subscription': 'Platinum', 'subscriptionEnd': '2025-01-10'},
    {'id': '10', 'name': 'Bilal Hussain', 'email': 'bilal@example.com', 'phone': '+92-300-8888888', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-05', 'totalBookings': 26, 'totalSpent': 62000, 'isPremium': true, 'subscription': 'Silver', 'subscriptionEnd': '2025-03-05'},
    {'id': '11', 'name': 'Hina Tariq', 'email': 'hina@example.com', 'phone': '+92-345-9999999', 'role': 'customer', 'status': 'active', 'joinDate': '2024-02-01', 'totalBookings': 39, 'totalSpent': 95000, 'isPremium': true, 'subscription': 'Gold', 'subscriptionEnd': '2025-02-01'},
    {'id': '12', 'name': 'Imran Malik', 'email': 'imran@example.com', 'phone': '+92-321-1234567', 'role': 'customer', 'status': 'active', 'joinDate': '2024-01-25', 'totalBookings': 42, 'totalSpent': 108000, 'isPremium': true, 'subscription': 'Platinum', 'subscriptionEnd': '2025-01-25'},
    {'id': '13', 'name': 'Sana Iqbal', 'email': 'sana@example.com', 'phone': '+92-333-2345678', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-10', 'totalBookings': 29, 'totalSpent': 72000, 'isPremium': true, 'subscription': 'Gold', 'subscriptionEnd': '2025-03-10'},
    {'id': '14', 'name': 'Kamran Abbas', 'email': 'kamran@example.com', 'phone': '+92-300-3456789', 'role': 'customer', 'status': 'active', 'joinDate': '2024-02-12', 'totalBookings': 36, 'totalSpent': 88000, 'isPremium': true, 'subscription': 'Silver', 'subscriptionEnd': '2025-02-12'},
    {'id': '15', 'name': 'Nadia Shah', 'email': 'nadia@example.com', 'phone': '+92-311-4567890', 'role': 'customer', 'status': 'active', 'joinDate': '2024-01-18', 'totalBookings': 46, 'totalSpent': 128000, 'isPremium': true, 'subscription': 'Platinum', 'subscriptionEnd': '2025-01-18'},
    {'id': '16', 'name': 'Rizwan Ahmed', 'email': 'rizwan@example.com', 'phone': '+92-322-5678901', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-08', 'totalBookings': 27, 'totalSpent': 65000, 'isPremium': true, 'subscription': 'Gold', 'subscriptionEnd': '2025-03-08'},
    {'id': '17', 'name': 'Farah Yusuf', 'email': 'farah@example.com', 'phone': '+92-333-6789012', 'role': 'customer', 'status': 'active', 'joinDate': '2024-02-05', 'totalBookings': 40, 'totalSpent': 102000, 'isPremium': true, 'subscription': 'Gold', 'subscriptionEnd': '2025-02-05'},
    {'id': '18', 'name': 'Tariq Jamil', 'email': 'tariq@example.com', 'phone': '+92-345-7890123', 'role': 'customer', 'status': 'active', 'joinDate': '2024-01-22', 'totalBookings': 43, 'totalSpent': 115000, 'isPremium': true, 'subscription': 'Platinum', 'subscriptionEnd': '2025-01-22'},
    {'id': '19', 'name': 'Sidra Nasir', 'email': 'sidra@example.com', 'phone': '+92-300-8901234', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-15', 'totalBookings': 25, 'totalSpent': 58000, 'isPremium': true, 'subscription': 'Silver', 'subscriptionEnd': '2025-03-15'},
    {'id': '20', 'name': 'Waqas Butt', 'email': 'waqas@example.com', 'phone': '+92-321-9012345', 'role': 'customer', 'status': 'active', 'joinDate': '2024-02-18', 'totalBookings': 37, 'totalSpent': 92000, 'isPremium': true, 'subscription': 'Gold', 'subscriptionEnd': '2025-02-18'},
    {'id': '21', 'name': 'Aliya Saeed', 'email': 'aliya@example.com', 'phone': '+92-333-1231234', 'role': 'customer', 'status': 'active', 'joinDate': '2024-01-12', 'totalBookings': 50, 'totalSpent': 140000, 'isPremium': true, 'subscription': 'Platinum', 'subscriptionEnd': '2025-01-12'},
    {'id': '22', 'name': 'Faizan Ali', 'email': 'faizan@example.com', 'phone': '+92-300-2342345', 'role': 'customer', 'status': 'active', 'joinDate': '2024-02-22', 'totalBookings': 33, 'totalSpent': 82000, 'isPremium': true, 'subscription': 'Gold', 'subscriptionEnd': '2025-02-22'},
    {'id': '23', 'name': 'Laiba Hassan', 'email': 'laiba@example.com', 'phone': '+92-345-3453456', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-18', 'totalBookings': 24, 'totalSpent': 55000, 'isPremium': true, 'subscription': 'Silver', 'subscriptionEnd': '2025-03-18'},
    {'id': '24', 'name': 'Muneeb Shah', 'email': 'muneeb@example.com', 'phone': '+92-311-4564567', 'role': 'customer', 'status': 'active', 'joinDate': '2024-01-28', 'totalBookings': 47, 'totalSpent': 132000, 'isPremium': true, 'subscription': 'Platinum', 'subscriptionEnd': '2025-01-28'},
    {'id': '25', 'name': 'Rabia Noor', 'email': 'rabia.noor@example.com', 'phone': '+92-322-5675678', 'role': 'customer', 'status': 'active', 'joinDate': '2024-02-14', 'totalBookings': 30, 'totalSpent': 75000, 'isPremium': true, 'subscription': 'Gold', 'subscriptionEnd': '2025-02-14'},
    {'id': '26', 'name': 'Saif Ullah', 'email': 'saif@example.com', 'phone': '+92-333-6786789', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-20', 'totalBookings': 22, 'totalSpent': 51000, 'isPremium': true, 'subscription': 'Silver', 'subscriptionEnd': '2025-03-20'},
    {'id': '27', 'name': 'Mahnoor Khan', 'email': 'mahnoor@example.com', 'phone': '+92-300-7897890', 'role': 'customer', 'status': 'active', 'joinDate': '2024-01-08', 'totalBookings': 49, 'totalSpent': 138000, 'isPremium': true, 'subscription': 'Platinum', 'subscriptionEnd': '2025-01-08'},
    {'id': '28', 'name': 'Adeel Raza', 'email': 'adeel@example.com', 'phone': '+92-345-8908901', 'role': 'customer', 'status': 'active', 'joinDate': '2024-02-25', 'totalBookings': 32, 'totalSpent': 79000, 'isPremium': true, 'subscription': 'Gold', 'subscriptionEnd': '2025-02-25'},
    {'id': '29', 'name': 'Kinza Malik', 'email': 'kinza@example.com', 'phone': '+92-311-9019012', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-22', 'totalBookings': 23, 'totalSpent': 53000, 'isPremium': true, 'subscription': 'Silver', 'subscriptionEnd': '2025-03-22'},
    {'id': '30', 'name': 'Hamza Butt', 'email': 'hamza.butt@example.com', 'phone': '+92-322-0120123', 'role': 'customer', 'status': 'active', 'joinDate': '2024-01-16', 'totalBookings': 45, 'totalSpent': 122000, 'isPremium': true, 'subscription': 'Platinum', 'subscriptionEnd': '2025-01-16'},
    
    // FREE USERS (65 active users)
    {'id': '31', 'name': 'Hassan Raza', 'email': 'hassan@example.com', 'phone': '+92-333-5555555', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-10', 'totalBookings': 12, 'totalSpent': 28000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '32', 'name': 'Amna Farooq', 'email': 'amna@example.com', 'phone': '+92-311-1122334', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-20', 'totalBookings': 8, 'totalSpent': 18500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '33', 'name': 'Hamza Ilyas', 'email': 'hamza@example.com', 'phone': '+92-322-2233445', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-01', 'totalBookings': 15, 'totalSpent': 35000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '34', 'name': 'Rabia Usman', 'email': 'rabia@example.com', 'phone': '+92-300-3344556', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-25', 'totalBookings': 10, 'totalSpent': 22000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '35', 'name': 'Adnan Qureshi', 'email': 'adnan@example.com', 'phone': '+92-333-4455667', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-05', 'totalBookings': 6, 'totalSpent': 14500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '36', 'name': 'Saima Riaz', 'email': 'saima@example.com', 'phone': '+92-345-5566778', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-28', 'totalBookings': 11, 'totalSpent': 25000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '37', 'name': 'Faisal Nadeem', 'email': 'faisal@example.com', 'phone': '+92-311-6677889', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-08', 'totalBookings': 7, 'totalSpent': 16000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '38', 'name': 'Kiran Abbas', 'email': 'kiran@example.com', 'phone': '+92-322-7788990', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-22', 'totalBookings': 13, 'totalSpent': 29500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '39', 'name': 'Shahid Akram', 'email': 'shahid@example.com', 'phone': '+92-300-8899001', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-02', 'totalBookings': 9, 'totalSpent': 20000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '40', 'name': 'Mehwish Khan', 'email': 'mehwish@example.com', 'phone': '+92-333-9900112', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-30', 'totalBookings': 14, 'totalSpent': 32000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '41', 'name': 'Asad Malik', 'email': 'asad@example.com', 'phone': '+92-345-0011223', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-10', 'totalBookings': 5, 'totalSpent': 12000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '42', 'name': 'Lubna Arif', 'email': 'lubna@example.com', 'phone': '+92-311-1122334', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-18', 'totalBookings': 16, 'totalSpent': 38000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '43', 'name': 'Majid Awan', 'email': 'majid@example.com', 'phone': '+92-322-2233445', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-06', 'totalBookings': 8, 'totalSpent': 19000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '44', 'name': 'Nighat Zaidi', 'email': 'nighat@example.com', 'phone': '+92-300-3344556', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-26', 'totalBookings': 11, 'totalSpent': 26000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '45', 'name': 'Owais Rafiq', 'email': 'owais@example.com', 'phone': '+92-333-4455667', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-12', 'totalBookings': 4, 'totalSpent': 9500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '46', 'name': 'Palwasha Noor', 'email': 'palwasha@example.com', 'phone': '+92-345-5566778', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-24', 'totalBookings': 12, 'totalSpent': 27500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '47', 'name': 'Qaiser Mahmood', 'email': 'qaiser@example.com', 'phone': '+92-311-6677889', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-09', 'totalBookings': 7, 'totalSpent': 17000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '48', 'name': 'Rida Imtiaz', 'email': 'rida@example.com', 'phone': '+92-322-7788990', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-21', 'totalBookings': 13, 'totalSpent': 30000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '49', 'name': 'Saad Bashir', 'email': 'saad@example.com', 'phone': '+92-300-8899001', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-04', 'totalBookings': 9, 'totalSpent': 21000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '50', 'name': 'Tayyaba Sheikh', 'email': 'tayyaba@example.com', 'phone': '+92-333-9900112', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-29', 'totalBookings': 10, 'totalSpent': 23500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '51', 'name': 'Umar Farooq', 'email': 'umar.farooq@example.com', 'phone': '+92-345-0011223', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-11', 'totalBookings': 6, 'totalSpent': 15000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '52', 'name': 'Warda Saleem', 'email': 'warda@example.com', 'phone': '+92-311-1122335', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-19', 'totalBookings': 14, 'totalSpent': 33000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '53', 'name': 'Yasir Abbasi', 'email': 'yasir@example.com', 'phone': '+92-322-2233446', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-07', 'totalBookings': 8, 'totalSpent': 18000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '54', 'name': 'Zahida Pervez', 'email': 'zahida@example.com', 'phone': '+92-300-3344557', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-27', 'totalBookings': 11, 'totalSpent': 24500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '55', 'name': 'Aamir Sohail', 'email': 'aamir@example.com', 'phone': '+92-333-4455668', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-13', 'totalBookings': 5, 'totalSpent': 11500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '56', 'name': 'Bushra Malik', 'email': 'bushra@example.com', 'phone': '+92-345-5566779', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-23', 'totalBookings': 12, 'totalSpent': 28500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '57', 'name': 'Danish Nawaz', 'email': 'danish@example.com', 'phone': '+92-311-6677890', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-03', 'totalBookings': 9, 'totalSpent': 22500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '58', 'name': 'Esha Riaz', 'email': 'esha@example.com', 'phone': '+92-322-7788991', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-31', 'totalBookings': 10, 'totalSpent': 24000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '59', 'name': 'Fahad Iqbal', 'email': 'fahad@example.com', 'phone': '+92-300-8899002', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-14', 'totalBookings': 4, 'totalSpent': 10000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '60', 'name': 'Geeti Sharma', 'email': 'geeti@example.com', 'phone': '+92-333-9900113', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-17', 'totalBookings': 15, 'totalSpent': 36000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '61', 'name': 'Haroon Rasheed', 'email': 'haroon@example.com', 'phone': '+92-345-0011224', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-15', 'totalBookings': 3, 'totalSpent': 8500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '62', 'name': 'Izza Fatima', 'email': 'izza@example.com', 'phone': '+92-311-1122336', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-16', 'totalBookings': 13, 'totalSpent': 31000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '63', 'name': 'Junaid Ali', 'email': 'junaid@example.com', 'phone': '+92-322-2233447', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-16', 'totalBookings': 7, 'totalSpent': 18500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '64', 'name': 'Komal Hassan', 'email': 'komal@example.com', 'phone': '+92-300-3344558', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-14', 'totalBookings': 12, 'totalSpent': 29000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '65', 'name': 'Liaqat Hussain', 'email': 'liaqat@example.com', 'phone': '+92-333-4455669', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-17', 'totalBookings': 6, 'totalSpent': 15500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '66', 'name': 'Maria Aslam', 'email': 'maria@example.com', 'phone': '+92-345-5566780', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-13', 'totalBookings': 14, 'totalSpent': 34000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '67', 'name': 'Naveed Anwar', 'email': 'naveed@example.com', 'phone': '+92-311-6677891', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-18', 'totalBookings': 5, 'totalSpent': 13000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '68', 'name': 'Omer Saeed', 'email': 'omer@example.com', 'phone': '+92-322-7788992', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-12', 'totalBookings': 16, 'totalSpent': 39000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '69', 'name': 'Parveen Malik', 'email': 'parveen@example.com', 'phone': '+92-300-8899003', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-19', 'totalBookings': 4, 'totalSpent': 11000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '70', 'name': 'Qasim Raza', 'email': 'qasim@example.com', 'phone': '+92-333-9900114', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-11', 'totalBookings': 13, 'totalSpent': 32500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '71', 'name': 'Romana Khan', 'email': 'romana@example.com', 'phone': '+92-345-0011225', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-20', 'totalBookings': 8, 'totalSpent': 20500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '72', 'name': 'Shahzad Butt', 'email': 'shahzad@example.com', 'phone': '+92-311-1122337', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-09', 'totalBookings': 11, 'totalSpent': 27000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '73', 'name': 'Tahira Naz', 'email': 'tahira@example.com', 'phone': '+92-322-2233448', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-21', 'totalBookings': 7, 'totalSpent': 17500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '74', 'name': 'Ubaid Ullah', 'email': 'ubaid@example.com', 'phone': '+92-300-3344559', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-08', 'totalBookings': 15, 'totalSpent': 37000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '75', 'name': 'Veena Sharma', 'email': 'veena@example.com', 'phone': '+92-333-4455670', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-22', 'totalBookings': 6, 'totalSpent': 14000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '76', 'name': 'Waleed Ahmed', 'email': 'waleed@example.com', 'phone': '+92-345-5566781', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-07', 'totalBookings': 12, 'totalSpent': 30500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '77', 'name': 'Xara Khan', 'email': 'xara@example.com', 'phone': '+92-311-6677892', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-23', 'totalBookings': 9, 'totalSpent': 23000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '78', 'name': 'Yusra Malik', 'email': 'yusra@example.com', 'phone': '+92-322-7788993', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-06', 'totalBookings': 10, 'totalSpent': 25500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '79', 'name': 'Zeeshan Abbasi', 'email': 'zeeshan@example.com', 'phone': '+92-300-8899004', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-24', 'totalBookings': 5, 'totalSpent': 12500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '80', 'name': 'Aiza Noor', 'email': 'aiza@example.com', 'phone': '+92-333-9900115', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-05', 'totalBookings': 14, 'totalSpent': 35500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '81', 'name': 'Basit Ali', 'email': 'basit@example.com', 'phone': '+92-345-0011226', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-25', 'totalBookings': 8, 'totalSpent': 19500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '82', 'name': 'Cybil Shah', 'email': 'cybil@example.com', 'phone': '+92-311-1122338', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-04', 'totalBookings': 11, 'totalSpent': 28000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '83', 'name': 'Danial Butt', 'email': 'danial@example.com', 'phone': '+92-322-2233449', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-26', 'totalBookings': 7, 'totalSpent': 16500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '84', 'name': 'Eliza Khan', 'email': 'eliza@example.com', 'phone': '+92-300-3344560', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-03', 'totalBookings': 13, 'totalSpent': 33500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '85', 'name': 'Faraz Iqbal', 'email': 'faraz@example.com', 'phone': '+92-333-4455671', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-27', 'totalBookings': 6, 'totalSpent': 15000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '86', 'name': 'Gul Hassan', 'email': 'gul@example.com', 'phone': '+92-345-5566782', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-02', 'totalBookings': 12, 'totalSpent': 31500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '87', 'name': 'Haris Jamil', 'email': 'haris@example.com', 'phone': '+92-311-6677893', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-28', 'totalBookings': 9, 'totalSpent': 24500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '88', 'name': 'Irsa Malik', 'email': 'irsa@example.com', 'phone': '+92-322-7788994', 'role': 'customer', 'status': 'active', 'joinDate': '2024-03-01', 'totalBookings': 10, 'totalSpent': 26500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '89', 'name': 'Jawad Raza', 'email': 'jawad@example.com', 'phone': '+92-300-8899005', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-29', 'totalBookings': 5, 'totalSpent': 13500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '90', 'name': 'Kashif Butt', 'email': 'kashif@example.com', 'phone': '+92-333-9900116', 'role': 'customer', 'status': 'active', 'joinDate': '2024-02-28', 'totalBookings': 14, 'totalSpent': 36500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '91', 'name': 'Laraib Shah', 'email': 'laraib@example.com', 'phone': '+92-345-0011227', 'role': 'customer', 'status': 'active', 'joinDate': '2024-04-30', 'totalBookings': 8, 'totalSpent': 21500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '92', 'name': 'Moiz Ahmed', 'email': 'moiz@example.com', 'phone': '+92-311-1122339', 'role': 'customer', 'status': 'active', 'joinDate': '2024-02-27', 'totalBookings': 11, 'totalSpent': 29500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '93', 'name': 'Noor Fatima', 'email': 'noor.fatima@example.com', 'phone': '+92-322-2233450', 'role': 'customer', 'status': 'active', 'joinDate': '2024-05-01', 'totalBookings': 7, 'totalSpent': 18000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '94', 'name': 'Osama Malik', 'email': 'osama@example.com', 'phone': '+92-300-3344561', 'role': 'customer', 'status': 'active', 'joinDate': '2024-02-26', 'totalBookings': 13, 'totalSpent': 34500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '95', 'name': 'Pakeeza Noor', 'email': 'pakeeza@example.com', 'phone': '+92-333-4455672', 'role': 'customer', 'status': 'active', 'joinDate': '2024-05-02', 'totalBookings': 6, 'totalSpent': 16000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '86', 'name': 'Qadir Shah', 'email': 'qadir@example.com', 'phone': '+92-345-5566783', 'role': 'customer', 'status': 'active', 'joinDate': '2024-02-25', 'totalBookings': 12, 'totalSpent': 32000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '87', 'name': 'Rabail Ahmed', 'email': 'rabail@example.com', 'phone': '+92-311-6677894', 'role': 'customer', 'status': 'active', 'joinDate': '2024-05-03', 'totalBookings': 9, 'totalSpent': 25000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '88', 'name': 'Salman Raza', 'email': 'salman@example.com', 'phone': '+92-322-7788995', 'role': 'customer', 'status': 'active', 'joinDate': '2024-02-24', 'totalBookings': 10, 'totalSpent': 27500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '89', 'name': 'Tania Malik', 'email': 'tania@example.com', 'phone': '+92-300-8899006', 'role': 'customer', 'status': 'active', 'joinDate': '2024-05-04', 'totalBookings': 5, 'totalSpent': 14500, 'isPremium': false, 'subscription': 'Free'},
    {'id': '90', 'name': 'Usman Ghani', 'email': 'usman.ghani@example.com', 'phone': '+92-333-9900117', 'role': 'customer', 'status': 'active', 'joinDate': '2024-02-23', 'totalBookings': 14, 'totalSpent': 38000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '91', 'name': 'Vamika Noor', 'email': 'vamika@example.com', 'phone': '+92-345-0011228', 'role': 'customer', 'status': 'active', 'joinDate': '2024-05-05', 'totalBookings': 8, 'totalSpent': 22000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '92', 'name': 'Wajid Ali', 'email': 'wajid@example.com', 'phone': '+92-311-1122340', 'role': 'customer', 'status': 'active', 'joinDate': '2024-02-22', 'totalBookings': 11, 'totalSpent': 30000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '93', 'name': 'Yumna Shah', 'email': 'yumna@example.com', 'phone': '+92-322-2233451', 'role': 'customer', 'status': 'active', 'joinDate': '2024-05-06', 'totalBookings': 7, 'totalSpent': 19000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '94', 'name': 'Zubair Ahmed', 'email': 'zubair@example.com', 'phone': '+92-300-3344562', 'role': 'customer', 'status': 'active', 'joinDate': '2024-02-21', 'totalBookings': 13, 'totalSpent': 35000, 'isPremium': false, 'subscription': 'Free'},
    {'id': '95', 'name': 'Amjad Khan', 'email': 'amjad@example.com', 'phone': '+92-333-4455673', 'role': 'customer', 'status': 'active', 'joinDate': '2024-05-07', 'totalBookings': 6, 'totalSpent': 16500, 'isPremium': false, 'subscription': 'Free'},
    
    // BLOCKED USERS (5 users)
    {'id': '96', 'name': 'Bilal Rasheed', 'email': 'bilal.rasheed@example.com', 'phone': '+92-300-1112233', 'role': 'customer', 'status': 'blocked', 'joinDate': '2024-01-12', 'totalBookings': 3, 'totalSpent': 5000, 'isPremium': false, 'subscription': 'Free', 'blockReason': 'Fraudulent activity'},
    {'id': '97', 'name': 'Huma Qazi', 'email': 'huma@example.com', 'phone': '+92-333-2223344', 'role': 'customer', 'status': 'blocked', 'joinDate': '2024-02-08', 'totalBookings': 2, 'totalSpent': 3500, 'isPremium': false, 'subscription': 'Free', 'blockReason': 'Payment issues'},
    {'id': '98', 'name': 'Nabeel Aziz', 'email': 'nabeel@example.com', 'phone': '+92-345-3334455', 'role': 'customer', 'status': 'blocked', 'joinDate': '2024-03-14', 'totalBookings': 1, 'totalSpent': 1500, 'isPremium': false, 'subscription': 'Free', 'blockReason': 'Violation of terms'},
    {'id': '99', 'name': 'Rehan Siddiqui', 'email': 'rehan@example.com', 'phone': '+92-311-4445566', 'role': 'customer', 'status': 'blocked', 'joinDate': '2024-01-20', 'totalBookings': 4, 'totalSpent': 7000, 'isPremium': false, 'subscription': 'Free', 'blockReason': 'Spam behavior'},
    {'id': '100', 'name': 'Sobia Khan', 'email': 'sobia@example.com', 'phone': '+92-322-5556677', 'role': 'customer', 'status': 'blocked', 'joinDate': '2024-02-25', 'totalBookings': 2, 'totalSpent': 4000, 'isPremium': false, 'subscription': 'Free', 'blockReason': 'Inappropriate conduct'},
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
                        // Premium Badge
                        if (user['isPremium'] == true)
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.stars, size: 12, color: Colors.white),
                                const SizedBox(width: 4),
                                Text(
                                  user['subscription'] ?? 'Premium',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        // Status Badge
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
            // Premium subscription details
            if (user['isPremium'] == true) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.workspace_premium, size: 16, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          '${user['subscription']} Member',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                       'Valid until: ${user['subscriptionEnd']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            // Block reason for blocked users
            if (user['blockReason'] != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.warning, size: 16, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          'Block Reason',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user['blockReason'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
