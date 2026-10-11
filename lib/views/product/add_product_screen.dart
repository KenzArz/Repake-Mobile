import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Halaman "Jual Produk" (versi mobile).
///
/// Dipakai sebagai salah satu tab di UserNavbar, jadi tidak ada tombol back.
///
/// Urutan isi halaman (sama seperti wireframe):
///   1. Kotak "Pilih Sampai 3 Gambar Produk"
///   2. Daftar gambar terpilih (bisa digeser untuk mengubah urutan, gambar
///      pertama = cover)
///   3. Kartu form: nama, kategori, kondisi, harga, deskripsi, lokasi,
///      patokan lokasi, lalu tombol "Pasang Barang"
class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  // ---------------------------------------------------------------------------
  // DATA & STATE
  // ---------------------------------------------------------------------------

  /// Maksimal gambar yang boleh dipilih.
  static const _maxImages = 3;

  /// TODO: ganti dengan nama kondisi yang asli (contoh: "Baru",
  /// "Seperti baru", "Bekas layak pakai", "Perlu perbaikan").
  static const _conditions = ['Kondisi 1', 'Kondisi 2', 'Kondisi 3', 'Kondisi 4'];

  /// TODO: ganti dengan kategori dari database (category_controller).
  static const _categories = [
    'Elektronik',
    'Pakaian',
    'Perabot',
    'Olahraga',
    'Buku',
    'Lainnya',
  ];

  // Kunci untuk mengecek semua kolom form sekaligus (validate()).
  final _formKey = GlobalKey<FormState>();

  // Alat untuk membuka galeri.
  final _picker = ImagePicker();

  // Controller = "pegangan" untuk membaca / mengosongkan isi kolom teks.
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  final _landmarkController = TextEditingController();

  // Gambar yang dipilih. Urutan list = urutan tampil. Index 0 = cover.
  final List<XFile> _images = [];

  // Kategori terpilih (null = belum memilih).
  String? _category;

  // Index kondisi terpilih. Default 0 (Kondisi 1) seperti di wireframe.
  int _conditionIndex = 0;

  @override
  void dispose() {
    // Controller wajib dibuang supaya tidak bocor memori.
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // AKSI
  // ---------------------------------------------------------------------------

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Buka galeri lalu tambahkan gambar (sampai total 3).
  Future<void> _pickImages() async {
    final remaining = _maxImages - _images.length;
    if (remaining <= 0) {
      _showSnack('Maksimal $_maxImages gambar. Hapus salah satu dulu.');
      return;
    }

    final picked = await _picker.pickMultiImage();
    if (picked.isEmpty || !mounted) return; // batal memilih

    setState(() {
      for (final file in picked) {
        if (_images.length >= _maxImages) break;
        // Lewati gambar yang sama (path sama) supaya tidak dobel.
        if (_images.any((e) => e.path == file.path)) continue;
        _images.add(file);
      }
    });

    if (picked.length > remaining) {
      _showSnack('Hanya $_maxImages gambar pertama yang dipakai.');
    }
  }

  void _removeImage(int index) {
    setState(() => _images.removeAt(index));
  }

  /// Dipanggil saat gambar digeser. Memindahkan gambar ke posisi baru.
  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      // Aturan bawaan Flutter: kalau digeser ke kanan, newIndex harus -1.
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _images.removeAt(oldIndex);
      _images.insert(newIndex, item);
    });
  }

  /// Dipanggil saat tombol "Pasang Barang" ditekan.
  void _submit() {
    FocusScope.of(context).unfocus(); // tutup keyboard

    // validate() menjalankan semua `validator` di form dan menampilkan
    // pesan merah di kolom yang salah. Hasilnya true kalau semua valid.
    final formValid = _formKey.currentState!.validate();

    if (_images.isEmpty) {
      _showSnack('Pilih minimal 1 gambar produk.');
      return;
    }
    if (!formValid) return;

    // TODO: kirim ke ProductController, contoh:
    //   await context.read<ProductController>().addProduct(
    //     imagePaths: _images.map((e) => e.path).toList(),
    //     name: _nameController.text.trim(),
    //     category: _category!,
    //     condition: _conditions[_conditionIndex],
    //     price: int.parse(_priceController.text),
    //     description: _descController.text.trim(),
    //     location: _locationController.text.trim(),
    //     landmark: _landmarkController.text.trim(),
    //   );

    _showSnack('Barang berhasil dipasang (dummy).');
    _resetForm();
  }

  /// Kosongkan form setelah berhasil. Layar ini tetap hidup di IndexedStack,
  /// jadi tanpa reset isinya masih tersisa saat kembali ke tab ini.
  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _priceController.clear();
    _descController.clear();
    _locationController.clear();
    _landmarkController.clear();
    setState(() {
      _images.clear();
      _category = null;
      _conditionIndex = 0;
    });
  }

  // ---------------------------------------------------------------------------
  // TAMPILAN
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false, // bagian bawah sudah diurus navbar
        child: GestureDetector(
          // Tap area kosong -> keyboard tertutup.
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            // Menggeser layar juga menutup keyboard.
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Jual Produk', style: AppTextStyles.h3()),
                const SizedBox(height: 16),

                // 1. Kotak pilih gambar
                _ImagePickerBox(onTap: _pickImages),

                // 2. Daftar gambar terpilih (hanya muncul kalau sudah ada)
                if (_images.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildReorderHint(),
                  const SizedBox(height: 8),
                  _buildImageList(),
                ],

                const SizedBox(height: 16),

                // 3. Kartu form
                _buildFormCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Teks petunjuk "geser untuk mengatur urutan".
  Widget _buildReorderHint() {
    return Row(
      children: [
        const Icon(Icons.drag_indicator, size: 18, color: AppColors.textPrimary),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            'Tahan lalu geser gambar untuk mengatur urutan tampilan.',
            style: AppTextStyles.label(),
          ),
        ),
      ],
    );
  }

  /// Baris gambar terpilih yang bisa diurutkan dengan tahan-lalu-geser.
  Widget _buildImageList() {
    // LayoutBuilder dipakai supaya ukuran tiap gambar menyesuaikan lebar layar:
    // 3 gambar + 2 jarak (8px) = lebar penuh.
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 8.0;
        final tileSize =
            (constraints.maxWidth - gap * (_maxImages - 1)) / _maxImages;

        return SizedBox(
          // Tinggi = ukuran gambar + ruang label "Cover" (22px).
          height: tileSize + 22,
          child: ReorderableListView.builder(
            scrollDirection: Axis.horizontal,
            // Matikan ikon drag bawaan; kita pakai tahan-lama (long press).
            buildDefaultDragHandles: false,
            itemCount: _images.length,
            onReorder: _onReorder,
            itemBuilder: (context, i) {
              final file = _images[i];
              return ReorderableDelayedDragStartListener(
                // key wajib unik per item supaya animasi geser benar.
                key: ValueKey(file.path),
                index: i,
                child: Padding(
                  // Jarak antar gambar (kecuali yang terakhir).
                  padding: EdgeInsets.only(
                    right: i == _images.length - 1 ? 0 : gap,
                  ),
                  child: _ImageTile(
                    file: file,
                    size: tileSize,
                    isCover: i == 0, // urutan pertama = cover
                    onRemove: () => _removeImage(i),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Kartu putih berisi semua kolom form.
  Widget _buildFormCard() {
    const gap = SizedBox(height: 16); // jarak antar bagian

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Nama Produk ---
            const _FieldLabel('Nama Produk'),
            TextFormField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.sentences,
              style: AppTextStyles.body(),
              decoration: _decoration(hint: 'Masukkan nama barang...'),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Nama produk wajib diisi'
                  : null,
            ),
            gap,

            // --- Kategori Produk ---
            const _FieldLabel('Kategori Produk'),
            DropdownButtonFormField<String>(
              value: _category,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              borderRadius: BorderRadius.circular(8),
              style: AppTextStyles.body(),
              decoration: _decoration(hint: 'Pilih kategori...'),
              items: [
                for (final c in _categories)
                  DropdownMenuItem(value: c, child: Text(c)),
              ],
              onChanged: (v) => setState(() => _category = v),
              validator: (v) => v == null ? 'Pilih salah satu kategori' : null,
            ),
            gap,

            // --- Kondisi Produk (pilih salah satu) ---
            const _FieldLabel('Kondisi Produk'),
            Wrap(
              spacing: 8, // jarak horizontal antar pil
              runSpacing: 8, // jarak vertikal kalau turun baris
              children: [
                for (var i = 0; i < _conditions.length; i++)
                  _ChoicePill(
                    label: _conditions[i],
                    selected: i == _conditionIndex,
                    onTap: () => setState(() => _conditionIndex = i),
                  ),
              ],
            ),
            gap,

            // --- Harga (hanya angka) ---
            const _FieldLabel('Harga'),
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              // Hanya boleh angka 0-9.
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: AppTextStyles.body(),
              decoration: _decoration(
                hint: 'Masukkan harga...',
                prefix: Text(
                  'Rp.',
                  style: AppTextStyles.label()
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              validator: (v) {
                final price = int.tryParse(v ?? '');
                if (price == null || price <= 0) return 'Harga wajib diisi';
                return null;
              },
            ),
            gap,

            // --- Deskripsi (boleh kosong) ---
            const _FieldLabel('Deskripsi'),
            TextFormField(
              controller: _descController,
              keyboardType: TextInputType.multiline,
              minLines: 3,
              maxLines: 6,
              textCapitalization: TextCapitalization.sentences,
              style: AppTextStyles.body(),
              decoration: _decoration(
                hint: 'Jelaskan kondisi, ukuran, kelengkapan, kekurangan, '
                    'atau hal lain yang perlu diketahui pembeli...',
              ),
            ),
            gap,

            // --- Lokasi Barang ---
            const _FieldLabel('Lokasi Barang'),
            TextFormField(
              controller: _locationController,
              textInputAction: TextInputAction.next,
              style: AppTextStyles.body(),
              // TODO: sambungkan ke pencarian lokasi / peta (autocomplete).
              decoration: _decoration(
                hint: 'Cari lokasi atau area...',
                prefix: const Icon(Icons.search,
                    size: 20, color: AppColors.textSecondary),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Lokasi barang wajib diisi'
                  : null,
            ),
            gap,

            // --- Patokan Lokasi (boleh kosong) ---
            const _FieldLabel('Patokan Lokasi'),
            Text(
              'Tambahkan patokan agar pembeli lebih mudah menemukan lokasi.',
              style: AppTextStyles.label(),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _landmarkController,
              textInputAction: TextInputAction.done,
              style: AppTextStyles.body(),
              decoration: _decoration(hint: 'Contoh: dekat gerbang...'),
            ),
            const SizedBox(height: 20),

            // --- Tombol kirim ---
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.lime,
                  foregroundColor: AppColors.charcoal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: AppTextStyles.h5().copyWith(fontSize: 16),
                ),
                child: const Text('Pasang Barang'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Tampilan kolom input yang dipakai semua TextField di halaman ini,
  /// supaya konsisten. [prefix] = ikon/teks kecil di sisi kiri (opsional).
  InputDecoration _decoration({required String hint, Widget? prefix}) {
    OutlineInputBorder border(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: color),
        );

    return InputDecoration(
      isDense: true,
      filled: true,
      fillColor: AppColors.surfaceElevated,
      hintText: hint,
      hintStyle: AppTextStyles.body().copyWith(color: AppColors.textMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      // Prefix diberi jarak kiri 12 dan kanan 8 supaya rapi.
      prefixIcon: prefix == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: prefix,
            ),
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      enabledBorder: border(AppColors.borderDefault),
      focusedBorder: border(AppColors.charcoal),
      errorBorder: border(AppColors.errorBase),
      focusedErrorBorder: border(AppColors.errorBase),
      errorStyle: AppTextStyles.caption().copyWith(color: AppColors.errorBase),
    );
  }
}

// =============================================================================
// KOMPONEN KECIL (private: hanya dipakai di file ini)
// =============================================================================

/// Judul di atas tiap kolom ("Nama Produk", "Harga", dst).
class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: AppTextStyles.h5().copyWith(fontSize: 16),
      ),
    );
  }
}

/// Kotak hijau muda besar "Pilih Sampai 3 Gambar Produk". Ditekan = buka galeri.
class _ImagePickerBox extends StatelessWidget {
  const _ImagePickerBox({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // penuh selebar layar
      child: Material(
        color: AppColors.lime100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.neutral200, width: 1.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Kotak hitam berisi ikon gambar.
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.charcoal,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.image_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Pilih Sampai 3 Gambar Produk',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h5(),
                ),
                const SizedBox(height: 4),
                Text(
                  'Gambar pertama akan digunakan sebagai cover produk.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption()
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Satu gambar terpilih. Kalau [isCover], dibungkus kotak hijau + label "Cover".
class _ImageTile extends StatelessWidget {
  const _ImageTile({
    required this.file,
    required this.size,
    required this.isCover,
    required this.onRemove,
  });

  final XFile file;
  final double size; // lebar total tile (termasuk padding 4 di tiap sisi)
  final bool isCover;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    // Ukuran gambar sebenarnya = ukuran tile dikurangi padding kiri-kanan.
    final imageSize = size - 8;

    return Container(
      width: size,
      padding: const EdgeInsets.all(4),
      decoration: isCover
          ? BoxDecoration(
              color: AppColors.lime200,
              borderRadius: BorderRadius.circular(16),
            )
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: imageSize,
            height: imageSize,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(file.path),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.neutral200,
                      child: const Icon(Icons.broken_image_outlined),
                    ),
                  ),
                ),
                // Tombol hapus (bulat merah, pojok kanan atas).
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: AppColors.errorBase,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close,
                          size: 14, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Ruang label setinggi 22px. Kosong untuk yang bukan cover, supaya
          // tinggi semua tile sama.
          SizedBox(
            height: 22,
            child: isCover
                ? Center(
                    child: Text(
                      'Cover',
                      style: AppTextStyles.label()
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

/// Pil pilihan untuk "Kondisi Produk". Terpilih = diisi hijau lime.
class _ChoicePill extends StatelessWidget {
  const _ChoicePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.lime : Colors.transparent,
      shape: StadiumBorder(
        side: BorderSide(
          color: selected ? AppColors.lime : AppColors.textPrimary,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(), // efek tekan mengikuti bentuk pil
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            label,
            style: AppTextStyles.label().copyWith(
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}