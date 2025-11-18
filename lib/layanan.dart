import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Home.dart';

class Layanan extends StatelessWidget {
  const Layanan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
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
                    context, MaterialPageRoute(builder: (_) => const HomePage()));
              },
            ),
            Text(
              'Layanan',
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('riwayat')
            .orderBy('tanggal', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_outlined,
                      size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 10),
                  Text(
                    'Belum ada transaksi',
                    style: GoogleFonts.poppins(
                      color: Colors.grey.shade600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            );
          }

          final transaksiList = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(18),
            itemCount: transaksiList.length,
            itemBuilder: (context, index) {
              final data =
                  transaksiList[index].data() as Map<String, dynamic>? ?? {};
              final idDoc = transaksiList[index].id;

              final jenis = data['jenis'] ?? '-';
              final provider = data['provider'] ?? '-';
              final nomor = data['nomor'] ?? data['id_game'] ?? '-';
              final nominal = data['nominal'] ?? '-';
              final harga = data['harga'] ?? 0;
              final status = data['status'] ?? 'Pending';
              final tanggal = (data['tanggal'] as Timestamp?)?.toDate();

              Color warnaStatus;
              Color bgStatus;
              if (status == 'Selesai') {
                warnaStatus = Colors.green.shade700;
                bgStatus = Colors.green.shade50;
              } else if (status == 'Diproses') {
                warnaStatus = Colors.orange.shade700;
                bgStatus = Colors.orange.shade50;
              } else {
                warnaStatus = Colors.grey.shade600;
                bgStatus = Colors.grey.shade200;
              }

              return AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOut,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "$jenis - $provider",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 15.5,
                              color: Colors.black87,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: bgStatus,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              status,
                              style: GoogleFonts.poppins(
                                color: warnaStatus,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Detail info
                      Text(
                        '${jenis == "Game" ? "ID Game" : "Nomor"}: $nomor\n'
                        'Nominal: $nominal\n'
                        'Harga: Rp${harga.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}\n'
                        'Tanggal: ${tanggal != null ? "${tanggal.day}/${tanggal.month}/${tanggal.year}  ${tanggal.hour}:${tanggal.minute.toString().padLeft(2, '0')}" : "-"}',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Align(
                        alignment: Alignment.centerRight,
                        child: PopupMenuButton<String>(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 3,
                          icon: const Icon(Icons.more_vert_rounded,
                              color: Colors.black54),
                          onSelected: (value) async {
                            if (value == 'Selesai') {
                              await FirebaseFirestore.instance
                                  .collection('riwayat')
                                  .doc(idDoc)
                                  .delete();

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Transaksi selesai',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white),
                                  ),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            } else {
                              await FirebaseFirestore.instance
                                  .collection('riwayat')
                                  .doc(idDoc)
                                  .update({'status': value});

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Status diubah menjadi $value',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white),
                                  ),
                                  backgroundColor: Colors.blueAccent,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'Pending',
                              child: Text('Tandai Pending'),
                            ),
                            const PopupMenuItem(
                              value: 'Diproses',
                              child: Text('Tandai Diproses'),
                            ),
                            const PopupMenuItem(
                              value: 'Selesai',
                              child: Text('Tandai Selesai'),
                            ),
                          ],
                        ),
                      ),
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
}
