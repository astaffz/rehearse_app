import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Colors

const Color accent = Color(0xFFD6AD60); // Gold
const Color accentLight = Color(0xFFF4EBD0); //
const Color heading = Color(0xFFD6AD60); // Cream
const Color text = Color(0xFFbfded6); // Edgewater
const Color icon = Color(0xFF046523); // Fun Green (dark)
const Color background = Color(0xFF122620); // Charcoal
const Color white = Color(0xFFFFFFFF);
const Color black = Color(0xFF000000);

// TextStyles

TextStyle heading1 = GoogleFonts.poppins(
    fontWeight: FontWeight.w700, color: white, fontSize: 30);
TextStyle heading2 = GoogleFonts.poppins(
    fontWeight: FontWeight.w600, color: heading, fontSize: 27);
TextStyle heading3 = GoogleFonts.poppins(
    fontWeight: FontWeight.w600, color: heading, fontSize: 24);
TextStyle heading4 = GoogleFonts.poppins(
    fontWeight: FontWeight.w600, color: heading, fontSize: 22);

TextStyle pBold = GoogleFonts.poppins(
    fontSize: 20, fontWeight: FontWeight.w700, color: white);
TextStyle p1 = GoogleFonts.poppins(color: black, fontSize: 18);
TextStyle p2 = GoogleFonts.poppins(color: black, fontSize: 16);
TextStyle p3 = GoogleFonts.poppins(color: black, fontSize: 14);

TextStyle dialogText =
    heading2.copyWith(color: black, fontWeight: FontWeight.w800);
// Gap
double large = 50.0;
double medium = 30.0;
double smaller = 16.0;
double small = 10.0;

// Divider
const Divider dividerAccent = Divider(
  color: accent,
  indent: 15,
  endIndent: 15,
);
