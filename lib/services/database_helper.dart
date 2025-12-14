import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('glamora.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Bookings table
    await db.execute('''
      CREATE TABLE bookings(
        id TEXT PRIMARY KEY,
        customerId TEXT NOT NULL,
        customerName TEXT NOT NULL,
        providerId TEXT NOT NULL,
        providerName TEXT NOT NULL,
        serviceType TEXT NOT NULL,
        services TEXT NOT NULL,
        selectedDate TEXT NOT NULL,
        selectedTime TEXT NOT NULL,
        staffName TEXT,
        contactNumber TEXT NOT NULL,
        address TEXT,
        specialInstructions TEXT,
        totalAmount REAL NOT NULL,
        status TEXT NOT NULL,
        paymentMethod TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Reviews table
    await db.execute('''
      CREATE TABLE reviews(
        id TEXT PRIMARY KEY,
        bookingId TEXT NOT NULL,
        customerId TEXT NOT NULL,
        customerName TEXT NOT NULL,
        providerId TEXT NOT NULL,
        providerName TEXT NOT NULL,
        rating REAL NOT NULL,
        comment TEXT NOT NULL,
        photoUrls TEXT,
        helpfulCount INTEGER DEFAULT 0,
        providerResponse TEXT,
        servicesTaken TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Chat conversations table
    await db.execute('''
      CREATE TABLE chat_conversations(
        id TEXT PRIMARY KEY,
        customerId TEXT NOT NULL,
        customerName TEXT NOT NULL,
        providerId TEXT NOT NULL,
        providerName TEXT NOT NULL,
        bookingId TEXT,
        unreadCount INTEGER DEFAULT 0,
        lastActivity TEXT NOT NULL
      )
    ''');

    // Chat messages table
    await db.execute('''
      CREATE TABLE chat_messages(
        id TEXT PRIMARY KEY,
        conversationId TEXT NOT NULL,
        senderId TEXT NOT NULL,
        senderName TEXT NOT NULL,
        senderType TEXT NOT NULL,
        message TEXT NOT NULL,
        messageType TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        isRead INTEGER DEFAULT 0,
        FOREIGN KEY (conversationId) REFERENCES chat_conversations (id)
      )
    ''');

    // Payments table
    await db.execute('''
      CREATE TABLE payments(
        id TEXT PRIMARY KEY,
        bookingId TEXT NOT NULL,
        amount REAL NOT NULL,
        method TEXT NOT NULL,
        status TEXT NOT NULL,
        transactionId TEXT,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (bookingId) REFERENCES bookings (id)
      )
    ''');

    // Wallet transactions table
    await db.execute('''
      CREATE TABLE wallet_transactions(
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        type TEXT NOT NULL,
        amount REAL NOT NULL,
        description TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        relatedBookingId TEXT
      )
    ''');
  }

  // ==================== BOOKINGS ====================

  Future<String> createBooking(Map<String, dynamic> booking) async {
    final db = await database;
    await db.insert('bookings', booking);
    return booking['id'];
  }

  Future<List<Map<String, dynamic>>> getBookings({String? userId, String? status}) async {
    final db = await database;
    String query = 'SELECT * FROM bookings';
    List<String> conditions = [];
    
    if (userId != null) {
      conditions.add('(customerId = ? OR providerId = ?)');
    }
    if (status != null) {
      conditions.add('status = ?');
    }
    
    if (conditions.isNotEmpty) {
      query += ' WHERE ${conditions.join(' AND ')}';
    }
    query += ' ORDER BY createdAt DESC';
    
    List<dynamic> args = [];
    if (userId != null) {
      args.addAll([userId, userId]);
    }
    if (status != null) {
      args.add(status);
    }
    
    return await db.rawQuery(query, args.isEmpty ? null : args);
  }

  Future<int> updateBookingStatus(String id, String status) async {
    final db = await database;
    return await db.update(
      'bookings',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== REVIEWS ====================

  Future<String> createReview(Map<String, dynamic> review) async {
    final db = await database;
    await db.insert('reviews', review);
    return review['id'];
  }

  Future<List<Map<String, dynamic>>> getReviews({String? providerId}) async {
    final db = await database;
    if (providerId != null) {
      return await db.query(
        'reviews',
        where: 'providerId = ?',
        whereArgs: [providerId],
        orderBy: 'createdAt DESC',
      );
    }
    return await db.query('reviews', orderBy: 'createdAt DESC');
  }

  Future<int> updateReviewHelpful(String id, int count) async {
    final db = await database;
    return await db.update(
      'reviews',
      {'helpfulCount': count},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== CHAT ====================

  Future<String> createConversation(Map<String, dynamic> conversation) async {
    final db = await database;
    await db.insert('chat_conversations', conversation);
    return conversation['id'];
  }

  Future<List<Map<String, dynamic>>> getConversations(String userId) async {
    final db = await database;
    return await db.query(
      'chat_conversations',
      where: 'customerId = ? OR providerId = ?',
      whereArgs: [userId, userId],
      orderBy: 'lastActivity DESC',
    );
  }

  Future<String> createMessage(Map<String, dynamic> message) async {
    final db = await database;
    await db.insert('chat_messages', message);
    
    // Update conversation's last activity
    await db.update(
      'chat_conversations',
      {'lastActivity': message['timestamp']},
      where: 'id = ?',
      whereArgs: [message['conversationId']],
    );
    
    return message['id'];
  }

  Future<List<Map<String, dynamic>>> getMessages(String conversationId) async {
    final db = await database;
    return await db.query(
      'chat_messages',
      where: 'conversationId = ?',
      whereArgs: [conversationId],
      orderBy: 'timestamp ASC',
    );
  }

  Future<int> markMessagesAsRead(String conversationId, String userId) async {
    final db = await database;
    return await db.update(
      'chat_messages',
      {'isRead': 1},
      where: 'conversationId = ? AND senderId != ? AND isRead = 0',
      whereArgs: [conversationId, userId],
    );
  }

  // ==================== PAYMENTS ====================

  Future<String> createPayment(Map<String, dynamic> payment) async {
    final db = await database;
    await db.insert('payments', payment);
    return payment['id'];
  }

  Future<List<Map<String, dynamic>>> getPayments({String? bookingId}) async {
    final db = await database;
    if (bookingId != null) {
      return await db.query(
        'payments',
        where: 'bookingId = ?',
        whereArgs: [bookingId],
        orderBy: 'createdAt DESC',
      );
    }
    return await db.query('payments', orderBy: 'createdAt DESC');
  }

  // ==================== WALLET ====================

  Future<String> createWalletTransaction(Map<String, dynamic> transaction) async {
    final db = await database;
    await db.insert('wallet_transactions', transaction);
    return transaction['id'];
  }

  Future<List<Map<String, dynamic>>> getWalletTransactions(String userId) async {
    final db = await database;
    return await db.query(
      'wallet_transactions',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
    );
  }

  Future<double> getWalletBalance(String userId) async {
    await database; // Ensure database is initialized
    final transactions = await getWalletTransactions(userId);
    
    double balance = 0.0;
    for (var transaction in transactions) {
      if (transaction['type'] == 'credit') {
        balance += transaction['amount'] as double;
      } else {
        balance -= transaction['amount'] as double;
      }
    }
    
    return balance;
  }

  // ==================== UTILITY ====================

  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  Future<void> deleteAllData() async {
    final db = await database;
    await db.delete('bookings');
    await db.delete('reviews');
    await db.delete('chat_conversations');
    await db.delete('chat_messages');
    await db.delete('payments');
    await db.delete('wallet_transactions');
  }
}
