import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'detail_produk.dart';
import 'home.dart';

class Toko extends StatefulWidget {
  const Toko({super.key});

  @override
  State<Toko> createState() => _TokoState();
}

class _TokoState extends State<Toko> {
  final produkRef = FirebaseFirestore.instance.collection('produk');

  final namaCtrl = TextEditingController();
  final hargaCtrl = TextEditingController();
  final deskripsiCtrl = TextEditingController();

  File? _selectedImage;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      setState(() => _isUploading = true);
      final ref = FirebaseStorage.instance
          .ref()
          .child('produk/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint('Upload error: $e');
      return null;
    } finally {
      setState(() => _isUploading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 80,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00C9FF), Color(0xFF92FE9D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                );
              },
            ),
            Text(
              "Toko Produk",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_shopping_cart_rounded, color: Colors.white, size: 28),
              onPressed: _showAddBottomSheet,
            ),
          ],
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: produkRef.orderBy('nama').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: Colors.cyan));
          }

          final data = snapshot.data!.docs;

          if (data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.storefront_rounded, size: 100, color: Colors.grey.shade400),
                  const SizedBox(height: 10),
                  Text("Belum ada produk dijual",
                      style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 16)),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final doc = data[index];
              final produk = doc.data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailProdukPage(
                      nama: produk['nama'],
                      harga: produk['harga'],
                      gambar: produk['gambar'],
                      deskripsi: produk['deskripsi'],
                    ),
                  ),
                ),
                onLongPress: () => _showOptionsMenu(doc.id, produk),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Hero(
                        tag: produk['gambar'] ?? 'noimg$index',
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                          child: produk['gambar'] != null && produk['gambar'] != ""
                              ? Image.network(produk['gambar'],
                                  height: 130, width: double.infinity, fit: BoxFit.cover)
                              : Container(
                                  height: 130,
                                  color: Colors.grey.shade200,
                                  child: const Icon(Icons.image_not_supported, size: 50),
                                ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          produk['nama'] ?? '',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Rp ${produk['harga'].toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')} ",
                        style: GoogleFonts.poppins(
                            color: Colors.teal.shade700, fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            produk['deskripsi'] ?? '',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: GoogleFonts.poppins(
                                fontSize: 11, color: Colors.grey.shade600, height: 1.3),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.cyan.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.cyan),
                              onPressed: () =>
                                  _showAddBottomSheet(edit: true, id: doc.id, data: produk),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () => _hapusProduk(doc.id),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddBottomSheet({bool edit = false, String? id, Map<String, dynamic>? data}) {
    if (edit && data != null) {
      namaCtrl.text = data['nama'];
      hargaCtrl.text = data['harga'].toString();
      deskripsiCtrl.text = data['deskripsi'];
    } else {
      namaCtrl.clear();
      hargaCtrl.clear();
      deskripsiCtrl.clear();
      _selectedImage = null;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 25,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(edit ? "Edit Produk" : "Tambah Produk",
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
                const SizedBox(height: 16),
                TextField(
                  controller: namaCtrl,
                  decoration: const InputDecoration(
                    labelText: "Nama Produk",
                    prefixIcon: Icon(Icons.shopping_bag_outlined),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: hargaCtrl,
                  decoration: const InputDecoration(
                    labelText: "Harga (Rp)",
                    prefixIcon: Icon(Icons.attach_money_rounded),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(_selectedImage!, fit: BoxFit.cover, width: double.infinity),
                          )
                        : const Center(child: Text("Pilih Gambar Produk")),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: deskripsiCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Deskripsi Produk",
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () async {
                      final nama = namaCtrl.text.trim();
                      final harga = int.tryParse(hargaCtrl.text) ?? 0;
                      final deskripsi = deskripsiCtrl.text.trim();

                      if (nama.isEmpty || harga <= 0) return;

                      String? imageUrl;
                      if (_selectedImage != null) {
                        imageUrl = await _uploadImage(_selectedImage!);
                      }

                      if (edit && id != null) {
                        await produkRef.doc(id).update({
                          'nama': nama,
                          'harga': harga,
                          'gambar': imageUrl ?? data?['gambar'],
                          'deskripsi': deskripsi,
                        });
                      } else {
                        await produkRef.add({
                          'nama': nama,
                          'harga': harga,
                          'gambar': imageUrl ?? '',
                          'deskripsi': deskripsi,
                        });
                      }

                      Navigator.pop(context);
                    },
                    child: _isUploading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : Text(edit ? "Simpan Perubahan" : "Tambah Produk",
                            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
               SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _hapusProduk(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Produk"),
        content: const Text("Yakin ingin menghapus produk ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          TextButton(
            onPressed: () async {
              await produkRef.doc(id).delete();
              Navigator.pop(context);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu(String id, Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.cyan),
            title: const Text("Edit Produk"),
            onTap: () {
              Navigator.pop(context);
              _showAddBottomSheet(edit: true, id: id, data: data);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
            title: const Text("Hapus Produk"),
            onTap: () {
              Navigator.pop(context);
              _hapusProduk(id);
            },
          ),
        ],
      ),
    );
  }
}
