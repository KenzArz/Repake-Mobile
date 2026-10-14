import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;

import '../../controllers/AuthController.dart';
import '../../controllers/ProfileController.dart';
import '../../models/UserRole.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Appbar Repake dengan 2 kondisi:
/// - Expanded : logo + avatar, search bar di bawahnya (saat di paling atas)
/// - Collapsed: logo + ikon search + avatar (saat di-scroll ke bawah)
/// - Simple: logo + avatar saja (tanpa search) jika showSearch = false
///
/// Perilaku:
/// - Scroll ke bawah -> collapse (walau sedang mengetik; keyboard ditutup).
/// - Tap ikon search -> expanded + langsung fokus.
/// - Tap di luar search bar -> keyboard ditutup. Kalau halaman sedang
///   di-scroll (tidak di paling atas), appbar ikut collapse.
class TopAppBar extends StatefulWidget {
  const TopAppBar({
    super.key,
    required this.scrollController,
    this.searchController,
    this.onSearchSubmitted,
    this.onProfileTap,
    this.collapseOffset = 24,
    this.showSearch = true, // Parameter baru: default true
  });

  /// Controller dari ListView/ScrollView di bawah appbar.
  final ScrollController scrollController;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onProfileTap;

  /// Seberapa jauh scroll (px) sebelum appbar mengecil.
  final double collapseOffset;
  
  /// Tampilkan search bar atau tidak. Jika false, hanya logo + profile.
  final bool showSearch;

  @override
  State<TopAppBar> createState() => _TopAppBarState();
}

class _TopAppBarState extends State<TopAppBar> {
  final _focusNode = FocusNode();
  bool _expanded = true;

  bool get _isScrolledDown =>
      widget.scrollController.hasClients &&
      widget.scrollController.offset > widget.collapseOffset;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant TopAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController.removeListener(_onScroll);
      widget.scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    final c = widget.scrollController;
    if (!c.hasClients) return;

    // Di paling atas -> selalu tampil penuh.
    if (c.offset <= 0) {
      _setExpanded(true);
      return;
    }

    // Scroll ke bawah melewati batas -> kecilkan (dan tutup keyboard).
    if (c.offset > widget.collapseOffset &&
        c.position.userScrollDirection == ScrollDirection.reverse) {
      _collapse();
    }
  }

  // Dipanggil saat search bar kehilangan / mendapat fokus.
  void _onFocusChange() {
    // Fokus hilang (tap di luar, keyboard ditutup) saat halaman sudah
    // di-scroll -> kecilkan lagi.
    if (!_focusNode.hasFocus && _isScrolledDown) {
      _setExpanded(false);
    }
  }

  void _collapse() {
    if (_focusNode.hasFocus) _focusNode.unfocus();
    _setExpanded(false);
  }

  void _setExpanded(bool value) {
    if (!mounted || _expanded == value) return;
    setState(() => _expanded = value);
  }

  void _openSearch() {
    setState(() => _expanded = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfacePage,
        border: Border(bottom: BorderSide(color: AppColors.borderDefault)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                  child: Text('Repake', style: AppTextStyles.h3()),
                ),
                // Tampilkan search icon hanya jika showSearch = true
                if (widget.showSearch)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _expanded
                        ? const SizedBox(key: ValueKey('no-search'))
                        : IconButton(
                            key: const ValueKey('search-icon'),
                            onPressed: _openSearch,
                            icon: const Icon(Icons.search),
                            color: AppColors.textPrimary,
                            tooltip: 'Cari',
                          ),
                  ),
                const SizedBox(width: 4),
                _ProfileButton(onTap: widget.onProfileTap),
              ],
            ),
          ),
          // Search field hanya ditampilkan jika showSearch = true
          if (widget.showSearch)
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              alignment: Alignment.topCenter,
              child: _expanded
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: _SearchField(
                        controller: widget.searchController,
                        focusNode: _focusNode,
                        onSubmitted: widget.onSearchSubmitted,
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    this.controller,
    required this.focusNode,
    this.onSubmitted,
  });

  final TextEditingController? controller;
  final FocusNode focusNode;
  final ValueChanged<String>? onSubmitted;

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: color),
      );

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: TextInputAction.search,
      onSubmitted: onSubmitted,
      // Tap di luar search bar -> batal mengetik (tutup keyboard).
      onTapOutside: (_) => focusNode.unfocus(),
      style: AppTextStyles.body(),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: AppColors.surfacePage,
        hintText: 'Cari sepeda, laptop, sofa...',
        hintStyle:
            AppTextStyles.body().copyWith(color: AppColors.textSecondary),
        prefixIcon:
            const Icon(Icons.search, size: 20, color: AppColors.textPrimary),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        enabledBorder: _border(AppColors.neutral300),
        focusedBorder: _border(AppColors.charcoal),
      ),
    );
  }
}

class _ProfileButton extends StatelessWidget {
  const _ProfileButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserRole>(
      valueListenable: AuthController.instance.role,
      builder: (context, role, _) {
        if (role == UserRole.guest) {
          return Material(
            color: AppColors.lime,
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              splashColor: AppColors.charcoal.withAlpha(55),
              highlightColor: AppColors.charcoal.withAlpha(50),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.login_rounded,
                        size: 16, color: AppColors.charcoal),
                    const SizedBox(width: 5),
                    Text(
                      'Masuk',
                      style: AppTextStyles.label().copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.charcoal,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return ListenableBuilder(
          listenable: ProfileController.instance,
          builder: (context, _) {
            final avatarFile = ProfileController.instance.avatarFile;
            final avatarUrl = ProfileController.instance.currentUser.avatarUrl;

            ImageProvider? avatarImage;
            if (avatarFile != null) {
              if (kIsWeb) {
                avatarImage = NetworkImage(avatarFile.path);
              } else {
                avatarImage = FileImage(avatarFile);
              }
            } else if (avatarUrl != null && avatarUrl.isNotEmpty) {
              if (kIsWeb ||
                  avatarUrl.startsWith('http') ||
                  avatarUrl.startsWith('blob:')) {
                avatarImage = NetworkImage(avatarUrl);
              } else {
                final f = File(avatarUrl);
                if (f.existsSync()) {
                  avatarImage = FileImage(f);
                }
              }
            }

            return Tooltip(
              message: 'Profil',
              child: Material(
                color: AppColors.lime200,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: onTap,
                  splashColor: AppColors.charcoal.withAlpha(55),
                  highlightColor: AppColors.charcoal.withAlpha(50),
                  hoverColor: AppColors.charcoal.withAlpha(25),
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: avatarImage != null
                        ? Ink.image(
                            image: avatarImage,
                            fit: BoxFit.cover,
                            width: 36,
                            height: 36,
                          )
                        : const Center(
                            child: Icon(
                              Icons.person,
                              size: 20,
                              color: AppColors.textPrimary,
                            ),
                          ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
