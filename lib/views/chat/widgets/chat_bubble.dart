import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

/// Bubble chat text biasa (bukan offer).
class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.timestamp,
  });

  final String message;
  final bool isMe; // true = pesan dari current user
  final DateTime timestamp;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar lawan bicara (hanya untuk pesan mereka)
          if (!isMe) ...[
            Container(
              width: 28,
              height: 28,
              margin: const EdgeInsets.only(right: 8, top: 4),
              decoration: BoxDecoration(
                color: AppColors.neutral300,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderDefault, width: 0.5),
              ),
              child: const Icon(
                Icons.person,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],

          // Bubble
          LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isMe ? AppColors.lime500 : AppColors.neutral200,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isMe ? 16 : 4),
                    bottomRight: Radius.circular(isMe ? 4 : 16),
                  ),
                ),
                child: Text(
                  message,
                  style: AppTextStyles.body().copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isMe ? AppColors.charcoal : AppColors.textPrimary,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
