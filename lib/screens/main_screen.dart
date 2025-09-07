import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/theme_provider.dart';
import '../viewmodels/chat_viewmodel.dart';
import '../services/ai_api_service.dart';

class MainScreen extends StatefulWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final themeProvider = Provider.of<ThemeProvider>(context);
    return Builder(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(localizations.aiAssistant),
          actions: [
            Container(
              child: _selectedIndex == 1
                  ? FloatingActionButton(
                      onPressed: () => _showClearChatDialog(context),
                      tooltip: AppLocalizations.of(context)!.clearChat,
                      child: const Icon(Icons.delete_sweep_outlined),
                    )
                  : null,
            )
          ],
        ),
        body: widget.child,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            switch (index) {
              case 0:
                context.go('/');
                break;
              case 1:
                context.go('/chat');
                break;
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard_outlined),
              activeIcon: const Icon(Icons.dashboard),
              label: AppLocalizations.of(context)!.dailySummary,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.chat_bubble_outline),
              activeIcon: const Icon(Icons.chat_bubble),
              label: AppLocalizations.of(context)!.aiChat,
            ),
          ],
        ),
        // floatingActionButton: _selectedIndex == 1
        //     ? FloatingActionButton(
        //         onPressed: () => _showClearChatDialog(context),
        //         tooltip: AppLocalizations.of(context)!.clearChat,
        //         child: const Icon(Icons.delete_sweep_outlined),
        //       )
        //     : null,
      );
    });
  }

  void _showClearChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.clearChatTitle),
          content: Text(AppLocalizations.of(context)!.clearChatContent),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.clear),
              onPressed: () {
                Provider.of<ChatViewModel>(context, listen: false).clearChat();
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
