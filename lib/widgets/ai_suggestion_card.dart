import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../viewmodels/health_viewmodel.dart';

class AiSuggestionCard extends StatelessWidget {
  final String suggestion;

  const AiSuggestionCard({super.key, required this.suggestion});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    final healthViewModel = Provider.of<HealthViewModel>(context);

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.aiSuggestion,
              style: GoogleFonts.lato(
                textStyle: theme.textTheme.titleLarge,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (healthViewModel.isLoading)
              const Center(child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ))
            else
              Text(
                suggestion,
                style: GoogleFonts.lato(textStyle: theme.textTheme.bodyMedium, fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}

