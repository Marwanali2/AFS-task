import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle titleLarge(BuildContext context) => Theme.of(context).textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.bold,
        fontFamily: GoogleFonts.outfit().fontFamily,
      );

  static TextStyle titleMedium(BuildContext context) => Theme.of(context).textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w600,
        fontFamily: GoogleFonts.outfit().fontFamily,
      );

  static TextStyle titleSmall(BuildContext context) => Theme.of(context).textTheme.titleSmall!.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontFamily: GoogleFonts.outfit().fontFamily,
      );

  static TextStyle bodyMedium(BuildContext context) => Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontFamily: GoogleFonts.inter().fontFamily,
      );

  static TextStyle bodySmall(BuildContext context) => Theme.of(context).textTheme.bodySmall!.copyWith(
        color: Theme.of(context).colorScheme.outline,
        fontFamily: GoogleFonts.inter().fontFamily,
      );
      
  static TextStyle errorStyle(BuildContext context) => Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: Theme.of(context).colorScheme.onErrorContainer,
        fontFamily: GoogleFonts.inter().fontFamily,
      );

  static TextStyle successStyle(BuildContext context) => Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        fontFamily: GoogleFonts.inter().fontFamily,
      );
}
