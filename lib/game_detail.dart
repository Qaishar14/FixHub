import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konterhp/game.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GameDetailPage extends StatefulWidget {
  final String gameName;
  const GameDetailPage({super.key, required this.gameName});

  @override
  State<GameDetailPage> createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage>
    with SingleTickerProviderStateMixin {
  int? selectedIndex;
  final _idController = TextEditingController();

  final Map<String, List<Map<String, dynamic>>> voucherList = {
    'Free Fire': [
      {'paket': '30 Diamond', 'harga': 20000},
      {'paket': '120 Diamond', 'harga': 40000},
      {'paket': '720 Diamond', 'harga': 90000},
    ],
    'Mobile Legends': [
      {'paket': '60 Diamond', 'harga': 15000},
      {'paket': '300 Diamond', 'harga': 75000},
      {'paket': '980 Diamond', 'harga': 230000},
    ],
    'PUBG Mobile': [
      {'paket': '80 UC', 'harga': 15000},
      {'paket': '420 UC', 'harga': 75000},
      {'paket': '880 UC', 'harga': 150000},
    ],
    'Genshin Impact': [
      {'paket': '60 Genesis Crystals', 'harga': 55000},
      {'paket': '240 Genesis Crystals', 'harga': 90000},
      {'paket': '500 Genesis Crystals', 'harga': 160000},
    ],
    'Call of Duty Mobile': [
      {'paket': '60 CP', 'harga': 12000},
      {'paket': '310 CP', 'harga': 55000},
      {'paket': '640 CP', 'harga': 105000},
    ],
    'Valorant': [
      {'paket': '125 VP', 'harga': 15000},
      {'paket': '420 VP', 'harga': 50000},
      {'paket': '700 VP', 'harga': 80000},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final list = voucherList[widget.gameName] ?? [];
    final selectedHarga = selectedIndex != null
        ? list[selectedIndex!]['harga'] as int
        : 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F7FF),
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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const GamePage()));
              },
            ),
            Text(
              widget.gameName,
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Masukkan ID Game",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _idController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Masukkan ID akun game kamu",
                      hintStyle: GoogleFonts.poppins(color: Colors.grey),
                      prefixIcon:
                          const Icon(Icons.person_outline, color: Colors.blue),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Colors.blueAccent, width: 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // --- PILIH NOMINAL ---
            Text(
              "Pilih Nominal",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.2,
              ),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];
                final isSelected = selectedIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => selectedIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : const LinearGradient(
                              colors: [Colors.white, Colors.white],
                            ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? Colors.blueAccent.withOpacity(0.3)
                              : Colors.black12,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item['paket'],
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Rp${item['harga'].toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}",
                            style: GoogleFonts.poppins(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.blueAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            if (selectedHarga > 0)
              Center(
                child: AnimatedOpacity(
                  opacity: 1,
                  duration: const Duration(milliseconds: 400),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0072FF), Color(0xFF00C6FF)],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "Total: Rp${selectedHarga.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 30),

            // --- BUTTON BELI SEKARANG ---
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  shadowColor: Colors.blueAccent,
                  backgroundColor: selectedIndex != null
                      ? const Color(0xFF0072FF)
                      : Colors.grey,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: selectedIndex != null
                    ? () async {
                        final id = _idController.text.trim();

                        if (id.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Masukkan ID game terlebih dahulu!"),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }

                        final paket = list[selectedIndex!];
                        try {
                          final user = FirebaseAuth.instance.currentUser;
                          await FirebaseFirestore.instance
                              .collection('riwayat')
                              .add({
                            'jenis': 'Game',
                            'id_game': id,
                            'provider': widget.gameName,
                            'nominal': paket['paket'],
                            'harga': paket['harga'],
                            'tanggal': FieldValue.serverTimestamp(),
                            'userId': user?.uid,
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Berhasil membeli ${paket['paket']} untuk ${widget.gameName}!",
                              ),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Transaksi gagal: ${e.toString()}"),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }
                    : null,
                child: Text(
                  "Beli Sekarang",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
