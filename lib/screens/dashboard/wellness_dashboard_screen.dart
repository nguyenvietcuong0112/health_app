import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../l10n/app_localizations.dart';
import '../../viewmodels/health_viewmodel.dart';
import '../../widgets/health_card.dart';
import '../../widgets/sleep_chart.dart';
import '../../widgets/ai_suggestion_card.dart';

class WellnessDashboardScreen extends StatelessWidget {
  const WellnessDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final healthViewModel = Provider.of<HealthViewModel>(context);
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => healthViewModel.fetchHealthData(),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.sync),
                  tooltip: localizations.sync,
                  onPressed: () => healthViewModel.fetchHealthData(),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(localizations.appTitle, style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [theme.primaryColor, theme.colorScheme.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: AiSuggestionCard(suggestion: healthViewModel.aiSuggestion),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5, // Adjust aspect ratio for better look
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final data = [
                      HealthCardData(
                        title: localizations.steps,
                        value: healthViewModel.healthData.steps.toString(),
                        icon: Icons.directions_walk,
                        color: Colors.blue.shade300,
                      ),
                      HealthCardData(
                        title: localizations.calories,
                        value: '${healthViewModel.healthData.calories} kcal',
                        icon: Icons.local_fire_department,
                        color: Colors.orange.shade300,
                      ),
                    ];
                    return HealthCard(data: data[index]);
                  },
                  childCount: 2,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0), // Add padding for FAB
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.sleepChart,
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200, // Give chart a fixed height
                          child: healthViewModel.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : SleepChart(sleepData: healthViewModel.sleepData),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/chat'),
        tooltip: localizations.aiChat,
        child: const Icon(Icons.chat_bubble_outline),
      ),
    );
  }
}
