
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/l10n/app_localizations.dart';

import '../../viewmodels/health_viewmodel.dart';
import 'health_card.dart';
import 'sleep_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.dailySummary),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditDialog(context),
          ),
        ],
      ),
      body: Consumer<HealthViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.aiSuggestion,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(viewModel.aiSuggestion),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: HealthCard(
                        title: localizations.steps,
                        value: viewModel.healthData.steps.toString(),
                        icon: Icons.directions_walk,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: HealthCard(
                        title: localizations.calories,
                        value: viewModel.healthData.calories.toString(),
                        icon: Icons.local_fire_department,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                HealthCard(
                  title: localizations.sleep,
                  value: '${viewModel.healthData.sleepHours} hrs',
                  icon: Icons.bedtime,
                  color: Colors.blue,
                ),
                const SizedBox(height: 24),
                Text(
                  localizations.sleepChart,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: SleepChart(sleepData: viewModel.sleepData),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final viewModel = Provider.of<HealthViewModel>(context, listen: false);
    final stepsController = TextEditingController(text: viewModel.healthData.steps.toString());
    final caloriesController = TextEditingController(text: viewModel.healthData.calories.toString());
    final sleepController = TextEditingController(text: viewModel.healthData.sleepHours.toString());
    final localizations = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.updateYourData),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: stepsController,
              decoration: InputDecoration(labelText: localizations.steps),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: caloriesController,
              decoration: InputDecoration(labelText: localizations.caloriesKcal),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: sleepController,
              decoration: InputDecoration(labelText: localizations.sleepHours),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () {
              viewModel.updateHealthData(
                steps: int.tryParse(stepsController.text) ?? viewModel.healthData.steps,
                calories: int.tryParse(caloriesController.text) ?? viewModel.healthData.calories,
                sleepHours: double.tryParse(sleepController.text) ?? viewModel.healthData.sleepHours,
              );
              Navigator.pop(context);
            },
            child: Text(localizations.save),
          ),
        ],
      ),
    );
  }
}
