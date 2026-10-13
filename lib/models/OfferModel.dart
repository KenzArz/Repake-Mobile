/// Status penawaran harga dalam chat.
enum OfferStatus {
  pending,  // Menunggu respon penjual
  accepted, // Penjual menerima tawaran
  rejected; // Penjual menolak tawaran
}

/// Data penawaran harga yang dikirim pembeli ke penjual.
class OfferModel {
  const OfferModel({
    required this.offeredPrice,
    this.status = OfferStatus.pending,
  });

  /// Harga yang ditawarkan pembeli (dalam Rupiah).
  final int offeredPrice;

  /// Status tawaran: pending, accepted, rejected.
  final OfferStatus status;

  /// Format harga ke "Rp 600.000".
  String get priceLabel {
    final digits = offeredPrice.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (_) => '.',
        );
    return 'Rp $digits';
  }

  /// Label status untuk UI.
  String get statusLabel {
    switch (status) {
      case OfferStatus.pending:
        return 'Ditawar';
      case OfferStatus.accepted:
        return 'Disetujui';
      case OfferStatus.rejected:
        return 'Ditolak';
    }
  }

  OfferModel copyWith({int? offeredPrice, OfferStatus? status}) {
    return OfferModel(
      offeredPrice: offeredPrice ?? this.offeredPrice,
      status: status ?? this.status,
    );
  }
}
