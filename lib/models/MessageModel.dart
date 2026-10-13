import 'OfferModel.dart';

/// Jenis pesan dalam chat.
enum MessageType {
  text,  // Pesan teks biasa
  offer, // Penawaran harga
  image, // Gambar (belum diimplementasi)
}

/// Satu pesan dalam percakapan chat.
class MessageModel {
  const MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.timestamp,
    this.message,
    this.messageType = MessageType.text,
    this.offerData,
  });

  final String id;
  final String chatId; // ID conversation yang memiliki pesan ini
  final String senderId; // ID pengirim pesan

  /// Isi pesan teks (null jika messageType != text).
  final String? message;

  final MessageType messageType;

  /// Data penawaran (hanya ada jika messageType == offer).
  final OfferModel? offerData;

  final DateTime timestamp;

  /// Format waktu relatif "2 jam lalu", "5 menit lalu".
  String get timeAgo {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return '${(diff.inDays / 7).floor()} minggu lalu';
  }

  /// Format waktu untuk chat list "18.20".
  String get timeLabel {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour.$minute';
  }

  MessageModel copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? message,
    MessageType? messageType,
    OfferModel? offerData,
    DateTime? timestamp,
  }) {
    return MessageModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      messageType: messageType ?? this.messageType,
      offerData: offerData ?? this.offerData,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
