// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart'; // Untuk StackTrace atau ScaffoldMessenger jika diperlukan

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi untuk mendaftarkan pengguna baru dengan email dan password
  Future<String?> registerWithEmailPassword({
    required String email,
    required String password,
    required String fullName,
    required String nik,
    required String role,
    String? institutionName,
    String? institutionAddress,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        // Simpan data pengguna tambahan ke Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'name': fullName,
          'nik': nik,
          'role': _mapStatusToRole(
            role,
          ), // Mengonversi status dropdown ke role yang sesuai
          'institutionName': institutionName,
          'institutionAddress': institutionAddress,
          'createdAt': Timestamp.now(),
        });

        // Jika role adalah 'school', buat dokumen di koleksi schools
        if (_mapStatusToRole(role) == 'school') {
          await _firestore.collection('schools').doc().set({
            'schoolName':
                institutionName, // Gunakan nama instansi sebagai nama sekolah
            'location':
                institutionAddress, // Gunakan alamat instansi sebagai lokasi sekolah
            'status': 'pending', // Status awal pengajuan sekolah
            'lastAidDate': null,
            'totalAidReceived': 0,
            'assignedCateringId': null,
            'isApproved': false, // Belum disetujui
            'requestedBy': user.uid, // UID pengguna yang mengajukan
            'createdAt': Timestamp.now(),
          });
        }
        // Jika role adalah 'catering', buat dokumen di koleksi caterings
        else if (_mapStatusToRole(role) == 'catering') {
          await _firestore.collection('caterings').doc().set({
            'cateringName':
                institutionName, // Gunakan nama instansi sebagai nama katering
            'contactPerson': fullName, // Nama lengkap sebagai kontak person
            'phoneNumber': null, // Bisa ditambahkan nanti
            'address':
                institutionAddress, // Alamat instansi sebagai alamat katering
            'schoolsServed':
                [], // Daftar sekolah yang dilayani, bisa diisi nanti
            'status': 'pending', // Status awal katering
            'createdAt': Timestamp.now(),
          });
        }

        return null; // Registrasi berhasil, tidak ada error
      }
    } on FirebaseAuthException catch (e) {
      // Tangani error spesifik dari Firebase Authentication
      if (e.code == 'weak-password') {
        return 'Password yang diberikan terlalu lemah.';
      } else if (e.code == 'email-already-in-use') {
        return 'Akun sudah ada untuk email tersebut.';
      } else if (e.code == 'invalid-email') {
        return 'Format email tidak valid.';
      }
      return e.message; // Kembalikan pesan error lainnya
    } catch (e) {
      // Tangani error umum
      return e.toString();
    }
    return 'Terjadi kesalahan tidak diketahui.'; // Fallback jika tidak ada return di atas
  }

  // Fungsi untuk login pengguna
  Future<String?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Login berhasil
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'Tidak ada pengguna yang ditemukan untuk email tersebut.';
      } else if (e.code == 'wrong-password') {
        return 'Password salah untuk email tersebut.';
      } else if (e.code == 'invalid-email') {
        return 'Format email tidak valid.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // Fungsi untuk logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Helper untuk memetakan status dari dropdown ke role yang digunakan di backend
  String _mapStatusToRole(String status) {
    switch (status) {
      case 'Admin Sekolah':
        return 'school';
      case 'Admin Catering':
        return 'catering';
      case 'Admin Pemerintah':
        return 'funder';
      case 'Umum':
        return 'general'; // Atau sesuaikan dengan role default jika "Umum" tidak memiliki akses ke fitur utama
      default:
        return 'unknown';
    }
  }

  // Stream untuk memantau perubahan status autentikasi pengguna
  Stream<User?> get user => _auth.authStateChanges();
}
