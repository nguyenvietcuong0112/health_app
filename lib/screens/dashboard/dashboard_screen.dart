import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/notification_service.dart';
import '../../viewmodels/health_viewmodel.dart';

import 'health_card.dart';
import 'sleep_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final String _staticSuggestion = 'Remember to drink at least 8 glasses of water today!';

  @override
  void initState() {
    super.initState();
    // Schedule notifications from the provided service
    Provider.of<NotificationService>(context, listen: false)
        .scheduleMockNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final healthViewModel = Provider.of<HealthViewModel>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wellness Dashboard'),
        // Chat button removed
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Static Health Suggestion Card
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Health Tip',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(_staticSuggestion, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Health Data Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                HealthCard(
                  title: 'Steps',
                  value: healthViewModel.healthData.steps.toString(),
                  icon: Icons.directions_walk,
                  color: Colors.blue.shade300,
                ),
                HealthCard(
                  title: 'Calories',
                  value: '${healthViewModel.healthData.calories} kcal',
                  icon: Icons.local_fire_department,
                  color: Colors.orange.shade300,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Sleep Chart Card
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sleep Analysis (Last 7 Days)',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    SleepChart(sleepData: healthViewModel.sleepData),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
