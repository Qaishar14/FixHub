import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konterhp/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Pulsa extends StatefulWidget {
  const Pulsa({super.key});

  @override
  State<Pulsa> createState() => _PulsaState();
}

class _PulsaState extends State<Pulsa> {
  final TextEditingController _nomorController = TextEditingController();
  int? selectedNominalIndex;
  String? selectedProvider;

  final List<Map<String, dynamic>> providers = [
    {'name': 'Telkomsel', 'logo': '../asset/telkomsel.png', 'color': Colors.red},
    {'name': 'XL', 'logo': '../asset/xl.png', 'color': Colors.blue},
    {'name': 'Indosat', 'logo': '../asset/indosat.png', 'color': Colors.amber},
    {'name': 'Axis', 'logo': '../asset/axis.png', 'color': Colors.purple},
    {'name': 'Tri', 'logo': '../asset/tri.png', 'color': Colors.pink},
  ];

  final List<Map<String, dynamic>> nominalList = [
    {'nominal': 2000, 'harga': 2300, 'diskon': 6},
    {'nominal': 5000, 'harga': 7000},
    {'nominal': 10000, 'harga': 12250},
    {'nominal': 20000, 'harga': 20500},
    {'nominal': 50000, 'harga': 51000, 'diskon': 2},
    {'nominal': 100000, 'harga': 101495, 'diskon': 1},
  ];

  @override
  Widget build(BuildContext context) {
    final selectedHarga = selectedNominalIndex != null
        ? nominalList[selectedNominalIndex!]['harga']
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FA),
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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
              },
            ),
            Text(
              "Top Up Pulsa",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input Nomor
            Text(
              "Nomor Telepon",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _nomorController,
              keyboardType: TextInputType.phone,
              style: GoogleFonts.poppins(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Masukkan nomor telepon",
                prefixIcon: const Icon(Icons.phone_android_rounded, color: Colors.blueAccent),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Provider
            Text(
              "Pilih Provider",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: providers.length,
                itemBuilder: (context, index) {
                  final provider = providers[index];
                  final isSelected = selectedProvider == provider['name'];
                  return GestureDetector(
                    onTap: () => setState(() => selectedProvider = provider['name']),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.only(right: 12),
                      width: 90,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (provider['color'] as Color).withOpacity(0.15)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? provider['color'] as Color : Colors.grey.shade300,
                          width: 1.6,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(provider['logo'], height: 35),
                          const SizedBox(height: 6),
                          Text(
                            provider['name'],
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? provider['color']
                                  : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            // Nominal Section
            if (selectedProvider != null) ...[
              Text(
                "Pilih Nominal Pulsa",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: nominalList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.25,
                ),
                itemBuilder: (context, index) {
                  final item = nominalList[index];
                  final isSelected = selectedNominalIndex == index;

                  return GestureDetector(
                    onTap: () => setState(() => selectedNominalIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [Color(0xFF00C9FF), Color(0xFF92FE9D)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: isSelected ? null : Colors.white,
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          if (item['diskon'] != null)
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                decoration: const BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "${item['diskon']}% OFF",
                                  style: GoogleFonts.poppins(
                                      fontSize: 10, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Rp${item['nominal'].toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: isSelected ? Colors.white : Colors.black87,
                                  ),
                                ),
                                Text(
                                  "Bayar: Rp${item['harga'].toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: isSelected ? Colors.white70 : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 25),

              if (selectedHarga != null)
                Center(
                  child: Text(
                    "Total Harga: Rp${selectedHarga.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      color: Colors.black87,
                    ),
                  ),
                ),

              const SizedBox(height: 25),

              // Tombol Beli
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedNominalIndex != null
                        ? const Color(0xFF00C9FF)
                        : Colors.grey,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 4,
                  ),
                  onPressed: selectedNominalIndex != null
                      ? () => _prosesTransaksi(context)
                      : null,
                  child: Text(
                    "Beli Sekarang",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _prosesTransaksi(BuildContext context) async {
    final nomor = _nomorController.text.trim();
    if (nomor.isEmpty) return _showError(context, "Masukkan nomor telepon!");
    if (nomor.length < 11) return _showError(context, "Nomor harus 11 angka!");
    if (!nomor.startsWith('08')) return _showError(context, "Nomor harus diawali 08!");

    final item = nominalList[selectedNominalIndex!];
    try {
      final user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('riwayat').add({
        'jenis': 'Pulsa',
        'provider': selectedProvider,
        'nomor': nomor,
        'nominal': item['nominal'],
        'harga': item['harga'],
        'tanggal': FieldValue.serverTimestamp(),
        'userId': user?.uid,
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Berhasil membeli pulsa Rp${item['nominal']}!",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      _showError(context, "Transaksi gagal: ${e.toString()}");
    }
  }

  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
