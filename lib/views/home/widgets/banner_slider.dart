import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';

/// Slider banner dengan slide kiri/kanan yang mengintip.
/// Kalau [imageUrls] kosong, ditampilkan 3 placeholder abu-abu.
class BannerSlider extends StatefulWidget {
  const BannerSlider({
    super.key,
    this.imageUrls = const [],
    this.height = 160,
    this.autoPlay = true,
  });

  final List<String> imageUrls;
  final double height;
  final bool autoPlay;

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final _controller = PageController(viewportFraction: 0.92);
  Timer? _timer;

  int get _count => widget.imageUrls.isEmpty ? 3 : widget.imageUrls.length;

  @override
  void initState() {
    super.initState();
    if (widget.autoPlay && _count > 1) {
      _timer = Timer.periodic(const Duration(seconds: 4), (_) => _next());
    }
  }

  void _next() {
    if (!_controller.hasClients) return;
    final current = _controller.page?.round() ?? 0;
    final next = current + 1 >= _count ? 0 : current + 1;
    _controller.animateToPage(
      next,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: _controller,
        itemCount: _count,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: widget.imageUrls.isEmpty
                  ? Container(
                      color: AppColors.neutral300,
                      child: Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 48,
                          color: AppColors.neutral500,
                        ),
                      ),
                    )
                  : Image.network(
                      widget.imageUrls[i],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: AppColors.neutral200,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.neutral400),
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.neutral300,
                        child: Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: 48,
                            color: AppColors.neutral500,
                          ),
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
