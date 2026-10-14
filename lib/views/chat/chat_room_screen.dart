import 'package:flutter/material.dart';

import '../../models/ChatModel.dart';
import '../../models/MessageModel.dart';
import '../../models/OfferModel.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/offer_action_sheet.dart';
import 'widgets/offer_bubble.dart';
import 'widgets/product_card_chat.dart';
import '../../widgets/wireframe_overlay.dart';

/// Halaman chat room 1-on-1 dengan product card dan offer system.
class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({
    super.key,
    required this.chat,
    required this.currentUserId,
  });

  final ChatModel chat;
  final String currentUserId;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _showAttachMenu = false;

  late final List<MessageModel> _messages = _dummyMessages();

  /// Generate dummy messages sesuai wireframe.
  List<MessageModel> _dummyMessages() {
    final now = DateTime.now();

    // Berbeda untuk setiap chat ID
    if (widget.chat.id == 'chat1') {
      // Chat dengan keyboard, ada offer pending
      return [
        MessageModel(
          id: 'm1',
          chatId: widget.chat.id,
          senderId: widget.currentUserId,
          message: 'Halo bang',
          timestamp: now.subtract(const Duration(minutes: 20)),
        ),
        MessageModel(
          id: 'm2',
          chatId: widget.chat.id,
          senderId: widget.currentUserId,
          message: 'Barangnya redi gak?',
          timestamp: now.subtract(const Duration(minutes: 19)),
        ),
        MessageModel(
          id: 'm3',
          chatId: widget.chat.id,
          senderId: widget.chat.sellerId,
          message: 'redi stok bang',
          timestamp: now.subtract(const Duration(minutes: 18)),
        ),
        MessageModel(
          id: 'm4',
          chatId: widget.chat.id,
          senderId: widget.chat.sellerId,
          message: 'nego bisa?',
          timestamp: now.subtract(const Duration(minutes: 17)),
        ),
        MessageModel(
          id: 'm5',
          chatId: widget.chat.id,
          senderId: widget.currentUserId,
          message: 'sok atuh',
          timestamp: now.subtract(const Duration(minutes: 16)),
        ),
        MessageModel(
          id: 'm6',
          chatId: widget.chat.id,
          senderId: widget.chat.sellerId,
          message: 'klik icon uang di bawah',
          timestamp: now.subtract(const Duration(minutes: 15)),
        ),
        // Offer message (pending)
        MessageModel(
          id: 'm7',
          chatId: widget.chat.id,
          senderId: widget.currentUserId,
          messageType: MessageType.offer,
          offerData: const OfferModel(
            offeredPrice: 600000,
            status: OfferStatus.pending,
          ),
          timestamp: now.subtract(const Duration(minutes: 14)),
        ),
      ];
    } else if (widget.chat.id == 'chat2') {
      // Chat sepatu, offer ditolak
      return [
        MessageModel(
          id: 'm1',
          chatId: widget.chat.id,
          senderId: widget.currentUserId,
          message: 'Bang ini sepatu masih ori kan?',
          timestamp: now.subtract(const Duration(hours: 3)),
        ),
        MessageModel(
          id: 'm2',
          chatId: widget.chat.id,
          senderId: widget.chat.sellerId,
          message: 'ori dong mas, ada box lengkap',
          timestamp: now.subtract(const Duration(hours: 2, minutes: 55)),
        ),
        // Offer rejected
        MessageModel(
          id: 'm3',
          chatId: widget.chat.id,
          senderId: widget.currentUserId,
          messageType: MessageType.offer,
          offerData: const OfferModel(
            offeredPrice: 400000,
            status: OfferStatus.rejected,
          ),
          timestamp: now.subtract(const Duration(hours: 2, minutes: 50)),
        ),
        MessageModel(
          id: 'm4',
          chatId: widget.chat.id,
          senderId: widget.chat.sellerId,
          message: 'nawar yang ngotak mas',
          timestamp: now.subtract(const Duration(hours: 2)),
        ),
      ];
    } else if (widget.chat.id == 'chat3') {
      // Chat kemeja, offer accepted
      return [
        MessageModel(
          id: 'm1',
          chatId: widget.chat.id,
          senderId: widget.currentUserId,
          message: 'Masih ada gak bang?',
          timestamp: now.subtract(const Duration(hours: 6)),
        ),
        MessageModel(
          id: 'm2',
          chatId: widget.chat.id,
          senderId: widget.chat.sellerId,
          message: 'masih dong',
          timestamp: now.subtract(const Duration(hours: 5, minutes: 55)),
        ),
        // Offer accepted
        MessageModel(
          id: 'm3',
          chatId: widget.chat.id,
          senderId: widget.currentUserId,
          messageType: MessageType.offer,
          offerData: const OfferModel(
            offeredPrice: 130000,
            status: OfferStatus.accepted,
          ),
          timestamp: now.subtract(const Duration(hours: 5, minutes: 30)),
        ),
        MessageModel(
          id: 'm4',
          chatId: widget.chat.id,
          senderId: widget.chat.sellerId,
          message: 'Selamat menikmati',
          timestamp: now.subtract(const Duration(hours: 5)),
        ),
      ];
    } else if (widget.chat.id == 'chat4') {
      // Chat laptop (current user = seller, ada offer masuk)
      return [
        MessageModel(
          id: 'm1',
          chatId: widget.chat.id,
          senderId: widget.chat.buyerId,
          message: 'Kak ini laptop masih garansi?',
          timestamp: now.subtract(const Duration(hours: 2)),
        ),
        MessageModel(
          id: 'm2',
          chatId: widget.chat.id,
          senderId: widget.currentUserId,
          message: 'masih dong, garansi resmi 2 tahun',
          timestamp: now.subtract(const Duration(hours: 1, minutes: 55)),
        ),
        // Offer dari buyer (pending)
        MessageModel(
          id: 'm3',
          chatId: widget.chat.id,
          senderId: widget.chat.buyerId,
          messageType: MessageType.offer,
          offerData: const OfferModel(
            offeredPrice: 11000000,
            status: OfferStatus.pending,
          ),
          timestamp: now.subtract(const Duration(hours: 1, minutes: 30)),
        ),
        MessageModel(
          id: 'm4',
          chatId: widget.chat.id,
          senderId: widget.chat.buyerId,
          message: 'Boleh nego lagi gak kak?',
          timestamp: now.subtract(const Duration(hours: 1)),
        ),
      ];
    }

    // Default chat kosong
    return [];
  }

  /// Cek apakah ada offer dengan status pending atau accepted.
  OfferModel? get _activeOffer {
    final offerMessages = _messages.where(
      (m) =>
          m.messageType == MessageType.offer &&
          (m.offerData?.status == OfferStatus.pending ||
              m.offerData?.status == OfferStatus.accepted),
    );
    return offerMessages.isNotEmpty
        ? offerMessages.last.offerData
        : null;
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showOfferSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OfferActionSheet(
        chat: widget.chat,
        currentUserId: widget.currentUserId,
        onOfferSubmit: (price) {
          // TODO: kirim offer ke backend
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showAttachOptions() {
    setState(() => _showAttachMenu = !_showAttachMenu);
  }

  void _onAttachImage() {
    setState(() => _showAttachMenu = false);
    // TODO: implement image picker
  }

  void _onAttachOffer() {
    setState(() => _showAttachMenu = false);
    _showOfferSheet();
  }

  @override
  Widget build(BuildContext context) {
    final otherUserName = widget.chat.getOtherUserName(widget.currentUserId);
    final isSeller = widget.chat.isSeller(widget.currentUserId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surfaceElevated,
        elevation: 0,
        leading: IconButton(
          icon: const WIcon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            // Avatar
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.neutral300,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: const WIcon(
                Icons.person,
                size: 20,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 12),
            // Name + online status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WText(
                    otherUserName,
                    style: AppTextStyles.label().copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  WText(
                    'Online 2 jam lalu',
                    style: AppTextStyles.caption().copyWith(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const WIcon(Icons.more_vert, color: AppColors.textPrimary),
            onPressed: () {
              // TODO: menu chat options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Product card (sticky di atas jika ada offer)
          if (_activeOffer != null)
            ProductCardChat(
              chat: widget.chat,
              offer: _activeOffer,
              currentUserId: widget.currentUserId,
              onTap: () {
                // TODO: buka product detail
              },
              onAccept: isSeller
                  ? () {
                      // TODO: accept offer
                    }
                  : null,
              onReject: isSeller
                  ? () {
                      // TODO: reject offer
                    }
                  : null,
            ),

          // Chat messages
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: WText(
                      'Mulai percakapan',
                      style: AppTextStyles.body()
                          .copyWith(color: AppColors.textMuted),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    reverse: false,
                    itemCount: _messages.length,
                    itemBuilder: (context, i) {
                      final message = _messages[i];
                      final isMe = message.senderId == widget.currentUserId;

                      if (message.messageType == MessageType.offer) {
                        return OfferBubble(
                          message: message,
                          isMe: isMe,
                          isSeller: isSeller,
                          onEdit: isMe && !isSeller
                              ? () {
                                  // TODO: edit offer
                                }
                              : null,
                          onCancel: isMe && !isSeller
                              ? () {
                                  // TODO: cancel offer
                                }
                              : null,
                        );
                      }

                      return ChatBubble(
                        message: message.message ?? '',
                        isMe: isMe,
                        timestamp: message.timestamp,
                      );
                    },
                  ),
          ),

          // Input area
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Input bar container
        Container(
          decoration: const BoxDecoration(
            color: AppColors.surfaceElevated,
            border: Border(top: BorderSide(color: AppColors.borderDefault)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Attach button
                  IconButton(
                    onPressed: _showAttachOptions,
                    icon: WIcon(
                      _showAttachMenu
                          ? Icons.close
                          : Icons.attach_file_rounded,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  // Text input (enabled untuk ketik, tapi tidak bisa kirim)
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      enabled: true, // ENABLED untuk ketik
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      style: AppTextStyles.body(),
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: AppColors.surfaceElevated,
                        hintText: 'Ketik di sini...',
                        hintStyle: AppTextStyles.body()
                            .copyWith(color: AppColors.textMuted),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(
                            color: AppColors.borderDefault,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(
                            color: AppColors.charcoal,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Send button (disabled - tidak bisa kirim)
                  IconButton(
                    onPressed: null, // DISABLED - tidak bisa kirim
                    icon: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.neutral300,
                        shape: BoxShape.circle,
                      ),
                      child: const WIcon(
                        Icons.send_rounded,
                        size: 20,
                        color: AppColors.neutral500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Attach menu popup - positioned above attach button (vertical)
        if (_showAttachMenu)
          Positioned(
            left: 16,
            bottom: 70, // Di atas input bar
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated, // Background putih untuk semua item
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neutral900.withValues(alpha: 0.15),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: AppColors.neutral900.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kirim gambar
                  _AttachOption(
                    icon: Icons.image_outlined,
                    label: 'Gambar',
                    color: Color(0xFF757575),
                    onTap: _onAttachImage,
                  ),
                  const SizedBox(height: 4),
                  // Tawar harga
                  _AttachOption(
                    icon: Icons.attach_money,
                    label: 'Tawar',
                    color: AppColors.warningBase,
                    onTap: _onAttachOffer,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Opsi attach (gambar atau tawar) - design simpel seperti referensi.
class _AttachOption extends StatelessWidget {
  const _AttachOption({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon dalam circle solid - ukuran sangat kecil
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: color ?? Color(0xFF757575),
                shape: BoxShape.circle,
              ),
              child: WIcon(
                icon,
                size: 16,
                color: AppColors.textOnDark,
              ),
            ),
            const SizedBox(width: 10),
            // Label di samping
            WText(
              label,
              style: AppTextStyles.body().copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
