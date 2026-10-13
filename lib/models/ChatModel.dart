import 'ProductModel.dart';

/// Jenis percakapan berdasarkan peran current user.
/// Digunakan untuk filter "Membeli" dan "Menjual".
enum ConversationType {
  buying,  // Current user = pembeli
  selling, // Current user = penjual
}

/// Satu percakapan chat antara 2 user tentang 1 produk.
class ChatModel {
  const ChatModel({
    required this.id,
    required this.product,
    required this.sellerId,
    required this.sellerName,
    required this.buyerId,
    required this.buyerName,
    this.sellerAvatarUrl,
    this.buyerAvatarUrl,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
  });

  final String id;

  /// Produk yang dibicarakan dalam chat ini.
  final ProductModel product;

  /// ID penjual (pemilik produk).
  final String sellerId;
  final String sellerName;
  final String? sellerAvatarUrl;

  /// ID pembeli (yang tertarik beli).
  final String buyerId;
  final String buyerName;
  final String? buyerAvatarUrl;

  /// Preview pesan terakhir untuk chat list.
  final String? lastMessage;
  final DateTime? lastMessageTime;

  /// Jumlah pesan belum dibaca oleh current user.
  final int unreadCount;

  /// Tentukan jenis conversation berdasarkan current user ID.
  ConversationType getConversationType(String currentUserId) {
    return currentUserId == buyerId
        ? ConversationType.buying
        : ConversationType.selling;
  }

  /// Dapatkan nama lawan bicara berdasarkan current user ID.
  String getOtherUserName(String currentUserId) {
    return currentUserId == buyerId ? sellerName : buyerName;
  }

  /// Dapatkan avatar lawan bicara berdasarkan current user ID.
  String? getOtherUserAvatar(String currentUserId) {
    return currentUserId == buyerId ? sellerAvatarUrl : buyerAvatarUrl;
  }

  /// Dapatkan ID lawan bicara berdasarkan current user ID.
  String getOtherUserId(String currentUserId) {
    return currentUserId == buyerId ? sellerId : buyerId;
  }

  /// Apakah current user adalah penjual?
  bool isSeller(String currentUserId) {
    return currentUserId == sellerId;
  }

  /// Format waktu terakhir untuk chat list "18.20".
  String get lastTimeLabel {
    if (lastMessageTime == null) return '';
    final hour = lastMessageTime!.hour.toString().padLeft(2, '0');
    final minute = lastMessageTime!.minute.toString().padLeft(2, '0');
    return '$hour.$minute';
  }

  ChatModel copyWith({
    String? id,
    ProductModel? product,
    String? sellerId,
    String? sellerName,
    String? buyerId,
    String? buyerName,
    String? sellerAvatarUrl,
    String? buyerAvatarUrl,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
  }) {
    return ChatModel(
      id: id ?? this.id,
      product: product ?? this.product,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      buyerId: buyerId ?? this.buyerId,
      buyerName: buyerName ?? this.buyerName,
      sellerAvatarUrl: sellerAvatarUrl ?? this.sellerAvatarUrl,
      buyerAvatarUrl: buyerAvatarUrl ?? this.buyerAvatarUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
