import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Data extends StatefulWidget {
  const Data({super.key});

  @override
  State<Data> createState() => _DataState();
}

class _DataState extends State<Data> {
  String? selectedProvider;
  int? selectedIndex;
  final TextEditingController _nomorController = TextEditingController();

  final List<Map<String, dynamic>> providers = [
    {'name': 'Telkomsel', 'logo': '../asset/telkomsel.png', 'color': Colors.red},
    {'name': 'XL', 'logo': '../asset/xl.png', 'color': Colors.blue},
    {'name': 'Indosat', 'logo': '../asset/indosat.png', 'color': Colors.amber},
    {'name': 'Axis', 'logo': '../asset/axis.png', 'color': Colors.purple},
    {'name': 'Tri', 'logo': '../asset/tri.png', 'color': Colors.pink},
  ];

  final paketTelkomsel = [
    {'paket': '1 GB', 'harga': 15000},
    {'paket': '3 GB', 'harga': 35000},
    {'paket': '5 GB', 'harga': 55000},
    {'paket': '10 GB', 'harga': 90000},
    {'paket': '20 GB', 'harga': 160000},
  ];
  final paketXl = [
    {'paket': '1 GB', 'harga': 12000},
    {'paket': '3 GB', 'harga': 28000},
    {'paket': '5 GB', 'harga': 40000},
    {'paket': '10 GB', 'harga': 70000},
    {'paket': '20 GB', 'harga': 130000},
  ];
  final paketIndosat = [
    {'paket': '1 GB', 'harga': 10000},
    {'paket': '3 GB', 'harga': 25000},
    {'paket': '5 GB', 'harga': 38000},
    {'paket': '10 GB', 'harga': 65000},
    {'paket': '20 GB', 'harga': 120000},
  ];
  final paketAxis = [
    {'paket': '1 GB', 'harga': 9000},
    {'paket': '3 GB', 'harga': 22000},
    {'paket': '5 GB', 'harga': 35000},
    {'paket': '10 GB', 'harga': 60000},
    {'paket': '20 GB', 'harga': 110000},
  ];
  final paketTri = [
    {'paket': '1 GB', 'harga': 8000},
    {'paket': '3 GB', 'harga': 20000},
    {'paket': '5 GB', 'harga': 32000},
    {'paket': '10 GB', 'harga': 58000},
    {'paket': '20 GB', 'harga': 105000},
  ];

  List<Map<String, dynamic>> getPaketList() {
    switch (selectedProvider) {
      case 'Telkomsel':
        return paketTelkomsel;
      case 'XL':
        return paketXl;
      case 'Indosat':
        return paketIndosat;
      case 'Axis':
        return paketAxis;
      case 'Tri':
        return paketTri;
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final paketList = getPaketList();
    final selectedHarga = selectedIndex != null && paketList.isNotEmpty
        ? paketList[selectedIndex!]['harga'] as int
        : 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
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
              "Top Up Kuota",
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
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nomor Telepon
            Text("Nomor Telepon",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            TextField(
              controller: _nomorController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "Masukkan nomor telepon",
                prefixIcon:
                    const Icon(Icons.phone_android_rounded, color: Colors.cyan),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.cyan),
                ),
              ),
            ),

            const SizedBox(height: 25),
            Text("Pilih Provider",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),

            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: providers.length,
                itemBuilder: (context, index) {
                  final provider = providers[index];
                  final isSelected = provider['name'] == selectedProvider;

                  return GestureDetector(
                    onTap: () => setState(() {
                      selectedProvider = provider['name'];
                      selectedIndex = null;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.only(right: 14),
                      width: 90,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (provider['color'] as Color).withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: isSelected
                              ? provider['color'] as Color
                              : Colors.grey.shade300,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 4,
                              offset: const Offset(0, 2))
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(provider['logo'], height: 40),
                          const SizedBox(height: 6),
                          Text(provider['name'],
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? provider['color']
                                      : Colors.black87)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            if (selectedProvider != null) ...[
              Text("Pilih Paket ${selectedProvider!}",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: paketList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.25,
                ),
                itemBuilder: (context, index) {
                  final item = paketList[index];
                  final isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () => setState(() => selectedIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [Colors.cyanAccent, Colors.cyan],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: isSelected ? null : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : Colors.grey.shade300,
                            width: 1.5),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 5,
                              offset: const Offset(0, 3)),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(item['paket'],
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black)),
                            const SizedBox(height: 4),
                            Text(
                              "Rp${item['harga'].toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: isSelected
                                    ? Colors.white70
                                    : Colors.cyan.shade800,
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
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.cyanAccent, Colors.cyan],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 6,
                            offset: const Offset(0, 3))
                      ],
                    ),
                    child: Text(
                      "Total Harga: Rp${selectedHarga.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}",
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

              const SizedBox(height: 25),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 16),
                    backgroundColor:
                        selectedIndex != null ? Colors.cyan : Colors.grey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 5,
                  ),
                  onPressed: selectedIndex != null
                      ? () async {
                          final nomor = _nomorController.text.trim();
                          if (nomor.isEmpty) {
                            _showError(context, "Masukkan nomor telepon!");
                            return;
                          }
                          if (nomor.length < 11) {
                            _showError(context, "Nomor harus 11 angka!");
                            return;
                          }
                          if (!nomor.startsWith('08')) {
                            _showError(context, "Nomor harus diawali 08!");
                            return;
                          }

                          final paket = paketList[selectedIndex!];
                          try {
                            final user = FirebaseAuth.instance.currentUser;
                            await FirebaseFirestore.instance
                                .collection('riwayat')
                                .add({
                              'jenis': 'Data',
                              'provider': selectedProvider,
                              'nomor': nomor,
                              'nominal': paket['paket'],
                              'harga': paket['harga'],
                              'tanggal': FieldValue.serverTimestamp(),
                              'userId': user?.uid,
                            });

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(
                                "Berhasil membeli paket ${paket['paket']}!",
                                style:
                                    GoogleFonts.poppins(color: Colors.white),
                              ),
                              behavior: SnackBarBehavior.floating,
                            ));
                          } catch (e) {
                            _showError(context, "Transaksi gagal: $e");
                          }
                        }
                      : null,
                  child: Text("Beli Sekarang",
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
    ));
  }
}
