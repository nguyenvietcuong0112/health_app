import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Data model for the HealthCard
class HealthCardData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  HealthCardData({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class HealthCard extends StatelessWidget {
  final HealthCardData data;

  const HealthCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: data.color.withAlpha((255 * 0.8).round()),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(data.icon, size: 32, color: Colors.white),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.value,
                  style: GoogleFonts.lato(
                    textStyle: theme.textTheme.headlineSmall,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  data.title,
                  style: GoogleFonts.lato(
                    textStyle: theme.textTheme.titleMedium,
                    color: Colors.white.withAlpha((255 * 0.9).round()),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
