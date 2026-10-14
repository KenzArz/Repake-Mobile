import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/BannerModel.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/wireframe_overlay.dart';

/// Tab "Banner": admin mengatur banner slider di beranda.
///   - Tambah banner  : tombol "+ Tambah"
///   - Ubah banner    : tekan kartu banner
///   - Aktif/nonaktif : switch di kartu
///   - Hapus banner   : ikon tempat sampah
///   - Ubah urutan    : tahan ikon ⠿ di kiri lalu geser
///
/// Data masih disimpan di memori (hilang saat aplikasi ditutup).
class BannerManageScreen extends StatefulWidget {
  const BannerManageScreen({super.key});

  @override
  State<BannerManageScreen> createState() => _BannerManageScreenState();
}

class _BannerManageScreenState extends State<BannerManageScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // jangan dibuang saat pindah tab

  // TODO: ganti dengan data dari database / controller.
  // Nanti BannerSlider di beranda juga harus membaca daftar ini
  // (hanya yang isActive == true, sesuai urutan).
  final List<BannerModel> _banners = [
    const BannerModel(id: 'b1', title: 'Promo awal semester'),
    const BannerModel(id: 'b2', title: 'Cara jual barang'),
    const BannerModel(id: 'b3', title: 'Banner lama', isActive: false),
  ];

  /// Buka form tambah (initial == null) atau ubah (initial berisi banner).
  Future<void> _openForm({BannerModel? initial}) async {
    final result = await showModalBottomSheet<BannerModel>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.surfacePage,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _BannerFormSheet(initial: initial),
    );

    // result == null artinya admin menekan "Batal" / menutup form.
    if (result == null || !mounted) return;

    setState(() {
      final i = _banners.indexWhere((b) => b.id == result.id);
      if (i == -1) {
        _banners.add(result); // banner baru -> taruh paling bawah
      } else {
        _banners[i] = result; // banner lama -> ganti isinya
      }
    });
    // TODO: simpan ke database.
  }

  Future<void> _confirmDelete(BannerModel banner) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const WText('Hapus banner?'),
        content: WText('Banner "${banner.title}" akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const WText('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.errorBase),
            child: const WText('Hapus'),
          ),
        ],
      ),
    );

    if (ok == true && mounted) {
      setState(() => _banners.removeWhere((b) => b.id == banner.id));
      // TODO: hapus di database.
    }
  }

  void _setActive(BannerModel banner, bool value) {
    setState(() {
      final i = _banners.indexWhere((b) => b.id == banner.id);
      _banners[i] = banner.copyWith(isActive: value);
    });
    // TODO: simpan ke database.
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1; // aturan bawaan Flutter
      final item = _banners.removeAt(oldIndex);
      _banners.insert(newIndex, item);
    });
    // TODO: simpan urutan baru ke database.
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // wajib karena memakai KeepAlive

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul + tombol tambah
          Row(
            children: [
              Expanded(child: WText('Atur Banner', style: AppTextStyles.h5())),
              FilledButton.icon(
                onPressed: () => _openForm(),
                icon: const WIcon(Icons.add, size: 20),
                label: const WText('Tambah'),
                style: FilledButton.styleFrom(
                  backgroundColor: Color(0xFFE0E0E0),
                  foregroundColor: AppColors.charcoal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          WText(
            'Banner tampil di beranda sesuai urutan di sini. '
            'Tahan ikon di kiri lalu geser untuk mengubah urutan.',
            style: AppTextStyles.label()
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),

          // Daftar banner
          Expanded(
            child: _banners.isEmpty
                ? Center(
                    child: WText(
                      'Belum ada banner.',
                      style: AppTextStyles.body()
                          .copyWith(color: AppColors.textMuted),
                    ),
                  )
                : ReorderableListView.builder(
                    // Pakai ikon sendiri (ReorderableDragStartListener) sebagai
                    // pegangan geser, jadi matikan pegangan bawaan.
                    buildDefaultDragHandles: false,
                    itemCount: _banners.length,
                    onReorder: _onReorder,
                    itemBuilder: (context, i) {
                      final banner = _banners[i];
                      return _BannerCard(
                        key: ValueKey(banner.id), // wajib unik per item
                        index: i,
                        banner: banner,
                        onTap: () => _openForm(initial: banner),
                        onToggle: (v) => _setActive(banner, v),
                        onDelete: () => _confirmDelete(banner),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Satu kartu banner di daftar.
class _BannerCard extends StatelessWidget {
  const _BannerCard({
    super.key,
    required this.index,
    required this.banner,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  final int index; // dipakai pegangan geser
  final BannerModel banner;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: AppColors.surfaceElevated,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.borderDefault),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                // Pegangan geser
                ReorderableDragStartListener(
                  index: index,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    child: WIcon(Icons.drag_indicator,
                        color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(width: 4),

                // Gambar kecil (rasio 2:1, redup kalau nonaktif)
                Opacity(
                  opacity: banner.isActive ? 1 : 0.5,
                  child: SizedBox(
                    width: 96,
                    height: 48,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _BannerImage(path: banner.imagePath),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Judul + status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WText(
                        banner.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.label()
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      WText(
                        banner.isActive ? 'Aktif' : 'Nonaktif',
                        style: AppTextStyles.caption().copyWith(
                          color: banner.isActive
                              ? AppColors.successShade
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),

                // Aktif / nonaktif
                Switch(
                  value: banner.isActive,
                  onChanged: onToggle,
                  activeTrackColor: Color(0xFFE0E0E0),
                ),

                // Hapus
                IconButton(
                  onPressed: onDelete,
                  icon: const WIcon(Icons.delete_outline),
                  color: AppColors.errorBase,
                  tooltip: 'Hapus',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Menampilkan gambar banner dari file lokal, URL, atau kotak abu-abu
/// kalau belum ada gambar.
class _BannerImage extends StatelessWidget {
  const _BannerImage({this.path});

  final String? path;

  Widget _placeholder() => Container(
        color: AppColors.neutral300,
        child: const Center(
          child: WIcon(Icons.image_outlined, color: AppColors.neutral500),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final p = path;
    if (p == null) return _placeholder();

    if (p.startsWith('http')) {
      return WImage.network(
        p,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    return Image.file(
      File(p),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }
}

// =============================================================================
// FORM TAMBAH / UBAH BANNER (bottom sheet)
// =============================================================================

class _BannerFormSheet extends StatefulWidget {
  const _BannerFormSheet({this.initial});

  /// null = tambah banner baru, berisi = ubah banner yang ada.
  final BannerModel? initial;

  @override
  State<_BannerFormSheet> createState() => _BannerFormSheetState();
}

class _BannerFormSheetState extends State<_BannerFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  late final TextEditingController _titleController =
      TextEditingController(text: widget.initial?.title ?? '');

  String? _imagePath; // gambar terpilih
  bool _showImageError = false; // tampilkan pesan "gambar wajib dipilih"

  bool get _isEdit => widget.initial != null;

  @override
  void initState() {
    super.initState();
    _imagePath = widget.initial?.imagePath;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null || !mounted) return; // batal memilih
    setState(() {
      _imagePath = file.path;
      _showImageError = false;
    });
  }

  void _save() {
    final formValid = _formKey.currentState!.validate();

    // Banner baru wajib punya gambar. Saat ubah, boleh tidak ganti gambar.
    if (!_isEdit && _imagePath == null) {
      setState(() => _showImageError = true);
      return;
    }
    if (!formValid) return;

    // Kirim hasilnya kembali ke BannerManageScreen lewat Navigator.pop.
    Navigator.of(context).pop(
      BannerModel(
        id: widget.initial?.id ??
            DateTime.now().microsecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        imagePath: _imagePath,
        isActive: widget.initial?.isActive ?? true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Dorong isi ke atas saat keyboard muncul.
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WText(
                _isEdit ? 'Ubah Banner' : 'Tambah Banner',
                style: AppTextStyles.h4(),
              ),
              const SizedBox(height: 16),

              // Kotak pilih gambar (rasio 2:1 sama seperti banner di beranda)
              AspectRatio(
                aspectRatio: 2,
                child: Material(
                  color: Color(0xFFEEEEEE),
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: _showImageError
                          ? AppColors.errorBase
                          : AppColors.neutral200,
                      width: 1.5,
                    ),
                  ),
                  child: InkWell(
                    onTap: _pickImage,
                    child: _imagePath == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const WIcon(Icons.add_photo_alternate_outlined,
                                  size: 32),
                              const SizedBox(height: 8),
                              WText('Pilih gambar banner',
                                  style: AppTextStyles.label()
                                      .copyWith(fontWeight: FontWeight.w600)),
                            ],
                          )
                        : Stack(
                            fit: StackFit.expand,
                            children: [
                              _BannerImage(path: _imagePath),
                              // Label kecil "Ganti gambar" di pojok kanan bawah
                              Positioned(
                                right: 8,
                                bottom: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.charcoal.withValues(
                                      alpha: 0.6,
                                    ),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: WText(
                                    'Ganti gambar',
                                    style: AppTextStyles.caption()
                                        .copyWith(
                                          color: AppColors.textOnDark,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              WText(
                _showImageError
                    ? 'Gambar banner wajib dipilih.'
                    : 'Disarankan rasio 2:1 (contoh 1200 x 600 px).',
                style: AppTextStyles.caption().copyWith(
                  color: _showImageError
                      ? AppColors.errorBase
                      : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),

              // Judul banner (penanda untuk admin)
              WText('Judul Banner',
                  style: AppTextStyles.h5().copyWith(fontSize: 16)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.done,
                style: AppTextStyles.body(),
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: AppColors.surfaceElevated,
                  hintText: 'Contoh: Promo awal semester',
                  hintStyle: AppTextStyles.body()
                      .copyWith(color: AppColors.textMuted),
                  helperText: 'Hanya terlihat oleh admin.',
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: AppColors.borderDefault),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.charcoal),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.errorBase),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.errorBase),
                  ),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Judul banner wajib diisi'
                    : null,
              ),
              const SizedBox(height: 20),

              // Tombol
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        foregroundColor: AppColors.charcoal,
                        side: const BorderSide(color: AppColors.charcoal),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const WText('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _save,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        backgroundColor: Color(0xFFE0E0E0),
                        foregroundColor: AppColors.charcoal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const WText('Simpan'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}