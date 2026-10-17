import 'package:flutter/material.dart';

import '../../models/ChatModel.dart';
import '../../models/DummyData.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/navigation_helper.dart';
import '../navigation/top_appBar.dart';
import 'chat_room_screen.dart';

/// Filter untuk daftar chat.
enum ChatFilter {
  all('Semua Pesan'),
  buying('Membeli'),
  selling('Menjual'),
  unread('Belum Terbaca');

  const ChatFilter(this.label);
  final String label;
}

/// Halaman daftar percakapan chat.
/// Menggantikan placeholder "Chat" di UserNavbar dan AdminNavbar.
class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  ChatFilter _selectedFilter = ChatFilter.all;
  final _scrollController = ScrollController();

  // TODO: ganti dengan data dari ChatController.
  // Dummy current user ID (untuk menentukan role dalam chat).
  final String _currentUserId = 'user123';

  late final List<ChatModel> _allChats = _dummyChats();

  /// Generate dummy chat conversations sesuai wireframe.
  /// Menggunakan produk dari DummyData untuk konsistensi.
  List<ChatModel> _dummyChats() {
    final now = DateTime.now();
    final products = DummyData.products;

    // Pastikan ada minimal 5 produk di DummyData
    if (products.length < 5) {
      throw StateError(
          'DummyData.products harus memiliki minimal 5 produk untuk chat list');
    }

    return [
      // Chat 1: Keyboard (pembeli = current user, ada offer pending)
      ChatModel(
        id: 'chat1',
        product: products[0], // Keyboard Mechanical
        sellerId: 'seller_midou',
        sellerName: 'Midou_kun',
        buyerId: _currentUserId, // Current user adalah pembeli
        buyerName: 'Anda',
        lastMessage: 'Barangnya masih readi bang?',
        lastMessageTime: now.subtract(const Duration(minutes: 15)),
        unreadCount: 0,
      ),

      // Chat 2: Sepatu (current user = pembeli, offer rejected)
      ChatModel(
        id: 'chat2',
        product: products[1], // Sepatu Sneakers Nike
        sellerId: 'seller_midou',
        sellerName: 'Midou_kun',
        buyerId: _currentUserId,
        buyerName: 'Anda',
        lastMessage: 'nawar yang ngotak mas',
        lastMessageTime: now.subtract(const Duration(hours: 2)),
        unreadCount: 1,
      ),

      // Chat 3: Jaket (current user = pembeli, offer accepted)
      ChatModel(
        id: 'chat3',
        product: products[2], // Jaket Denim Vintage
        sellerId: 'seller_midou',
        sellerName: 'Midou_kun',
        buyerId: _currentUserId,
        buyerName: 'Anda',
        lastMessage: 'Selamat menikmati',
        lastMessageTime: now.subtract(const Duration(hours: 5)),
        unreadCount: 0,
      ),

      // Chat 4: Kamera (current user = penjual, ada offer masuk)
      ChatModel(
        id: 'chat4',
        product: products[3], // Kamera DSLR Canon
        sellerId: _currentUserId, // Current user adalah penjual
        sellerName: 'Anda',
        buyerId: 'buyer_reza',
        buyerName: 'Reza Auditore',
        lastMessage: 'Boleh nego lagi gak kak?',
        lastMessageTime: now.subtract(const Duration(hours: 1)),
        unreadCount: 2,
      ),

      // Chat 5: Headphone (current user = penjual, belum ada offer)
      ChatModel(
        id: 'chat5',
        product: products[4], // Headphone Sony WH-1000XM4
        sellerId: _currentUserId,
        sellerName: 'Anda',
        buyerId: 'buyer_aldi',
        buyerName: 'Aldi',
        lastMessage: 'Masih garansi resmi gak?',
        lastMessageTime: now.subtract(const Duration(minutes: 30)),
        unreadCount: 0,
      ),
    ];
  }

  /// Filter chat berdasarkan pilihan user.
  List<ChatModel> get _filteredChats {
    switch (_selectedFilter) {
      case ChatFilter.all:
        return _allChats;

      case ChatFilter.buying:
        // Tampilkan chat dimana current user = pembeli
        return _allChats.where((c) => c.buyerId == _currentUserId).toList();

      case ChatFilter.selling:
        // Tampilkan chat dimana current user = penjual
        return _allChats.where((c) => c.sellerId == _currentUserId).toList();

      case ChatFilter.unread:
        // Tampilkan chat dengan unread count > 0
        return _allChats.where((c) => c.unreadCount > 0).toList();
    }
  }

  void _openChatRoom(ChatModel chat) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatRoomScreen(
          chat: chat,
          currentUserId: _currentUserId,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top AppBar tanpa search (hanya logo + profile)
            TopAppBar(
              scrollController: _scrollController,
              showSearch: false, // Nonaktifkan search di chat list
              onProfileTap: () => NavigationHelper.toProfile(context),
            ),

            // Filter dropdown
            _FilterDropdown(
              selectedFilter: _selectedFilter,
              onChanged: (filter) => setState(() => _selectedFilter = filter),
            ),

            // Chat list
            Expanded(
              child: _filteredChats.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.chat_bubble_outline,
                              size: 48, color: AppColors.neutral400),
                          const SizedBox(height: 12),
                          Text(
                            'Belum ada chat',
                            style: AppTextStyles.h5()
                                .copyWith(color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: _filteredChats.length,
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        indent: 76,
                        color: AppColors.borderDefault,
                      ),
                      itemBuilder: (context, i) {
                        final chat = _filteredChats[i];
                        return _ChatListTile(
                          chat: chat,
                          currentUserId: _currentUserId,
                          onTap: () => _openChatRoom(chat),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dropdown filter chat.
class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({
    required this.selectedFilter,
    required this.onChanged,
  });

  final ChatFilter selectedFilter;
  final ValueChanged<ChatFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          PopupMenuButton<ChatFilter>(
            initialValue: selectedFilter,
            onSelected: onChanged,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            offset: const Offset(0, 4),
            itemBuilder: (_) => [
              for (final filter in ChatFilter.values)
                PopupMenuItem(
                  value: filter,
                  child: Text(filter.label, style: AppTextStyles.body()),
                ),
            ],
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(selectedFilter.label, style: AppTextStyles.h5()),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down,
                    size: 24, color: AppColors.textPrimary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Satu item chat di list.
class _ChatListTile extends StatelessWidget {
  const _ChatListTile({
    required this.chat,
    required this.currentUserId,
    required this.onTap,
  });

  final ChatModel chat;
  final String currentUserId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final otherUserName = chat.getOtherUserName(currentUserId);
    final hasUnread = chat.unreadCount > 0;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar lawan bicara dengan unread badge
            SizedBox(
              width: 44,
              height: 44,
              child: Stack(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.neutral300,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.borderDefault),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 24,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  // Unread badge di kanan atas avatar
                  if (hasUnread)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.errorBase,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.surfacePage,
                            width: 2,
                          ),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Center(
                          child: Text(
                            '${chat.unreadCount}',
                            style: AppTextStyles.caption().copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textOnDark,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Info chat
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama + waktu
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          otherUserName,
                          style: AppTextStyles.label().copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        chat.lastTimeLabel,
                        style: AppTextStyles.caption()
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Nama produk
                  Text(
                    chat.product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption().copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Preview pesan terakhir
                  Row(
                    children: [
                      if (chat.lastMessage != null) ...[
                        Expanded(
                          child: Text(
                            chat.isSeller(currentUserId)
                                ? chat.lastMessage!
                                : 'Anda: ${chat.lastMessage}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption().copyWith(
                              color: hasUnread
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                              fontWeight:
                                  hasUnread ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Product thumbnail dengan gambar dari DummyData
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 48,
                height: 48,
                color: AppColors.neutral200,
                child: (chat.product.primaryImage?.isNotEmpty ?? false)
                    ? Image.network(
                        chat.product.primaryImage!,
                        fit: BoxFit.cover,
                        loadingBuilder: (_, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.image_outlined,
                          size: 24,
                          color: AppColors.neutral400,
                        ),
                      )
                    : const Icon(
                        Icons.image_outlined,
                        size: 24,
                        color: AppColors.neutral400,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
