import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Home.dart';

class Laporan extends StatelessWidget {
  const Laporan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pushReplacement(context, 
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ));
        }, 
        icon: Icon( Icons.arrow_back)),
        title: Text(
          'Laporan',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(0xFFFF512F),
      ),
      body: Center(
        child: Text(
          'Laporan Page',
          style: GoogleFonts.poppins(fontSize: 24),
        ),
      ),
    );
  }
}