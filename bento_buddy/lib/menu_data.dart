import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Pastikan intl ada di pubspec.yaml

class MenuData {
  final String id; // Document ID dari Firestore
  final String menuName;
  final String description;
  final String imageUrl; // URL gambar dari Firebase Storage
  final String cateringId; // UID catering yang mengunggah
  final String cateringName; // Nama catering yang mengunggah
  final String uploadedByUid; // UID user yang mengunggah (catering itu sendiri)
  final Timestamp timestamp; // Timestamp unggahan

  MenuData({
    required this.id,
    required this.menuName,
    required this.description,
    required this.imageUrl,
    required this.cateringId,
    required this.cateringName,
    required this.uploadedByUid,
    required this.timestamp,
  });

  // Factory constructor untuk membuat objek MenuData dari Firestore DocumentSnapshot
  factory MenuData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MenuData(
      id: doc.id,
      menuName: data['menuName'] ?? 'Nama Menu Tidak Tersedia',
      description: data['description'] ?? 'Deskripsi Tidak Tersedia',
      imageUrl: data['imageUrl'] ??
          'https://via.placeholder.com/150', // URL placeholder jika tidak ada gambar
      cateringId: data['cateringId'] ?? '',
      cateringName: data['cateringName'] ?? 'Catering Tidak Ditemukan',
      uploadedByUid: data['uploadedByUid'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  // Getter untuk mendapatkan tanggal yang diformat
  String get formattedDate {
    return DateFormat('dd MMMM yyyy').format(timestamp.toDate());
  }
}
