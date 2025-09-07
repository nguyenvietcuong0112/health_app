
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../l10n/app_localizations.dart';
import '../../services/ai_api_service.dart';
import '../../services/notification_service.dart';
import '../../viewmodels/health_viewmodel.dart';

import 'health_card.dart';
import 'sleep_chart.dart';

class WellnessDashboardScreen extends StatefulWidget {
  const WellnessDashboardScreen({super.key});

  @override
  State<WellnessDashboardScreen> createState() => _WellnessDashboardScreenState();
}

class _WellnessDashboardScreenState extends State<WellnessDashboardScreen> {
  late Future<String> _aiHealthTip;

  @override
  void initState() {
    super.initState();
    final aiService = Provider.of<AiApiService>(context, listen: false);
    _aiHealthTip = aiService.generateHealthTip();
    Provider.of<NotificationService>(context, listen: false)
        .scheduleMockNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final healthViewModel = Provider.of<HealthViewModel>(context);
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
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
                        localizations.aiSuggestion,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      FutureBuilder<String>(
                        future: _aiHealthTip,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(color: theme.colorScheme.error),
                            );
                          } else {
                            return Text(snapshot.data ?? 'No tip available.', style: theme.textTheme.bodyMedium);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == 0) {
                    return HealthCard(
                      title: localizations.steps,
                      value: healthViewModel.healthData.steps.toString(),
                      icon: Icons.directions_walk,
                      color: Colors.blue.shade300,
                    );
                  }
                  if (index == 1) {
                    return HealthCard(
                      title: localizations.calories,
                      value: '${healthViewModel.healthData.calories} kcal',
                      icon: Icons.local_fire_department,
                      color: Colors.orange.shade300,
                    );
                  }
                  return null;
                },
                childCount: 2,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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
                      SleepChart(sleepData: healthViewModel.sleepData),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/chat'),
        tooltip: localizations.aiChat,
        child: const Icon(Icons.chat_bubble_outline),
      ),
    );
  }
}
