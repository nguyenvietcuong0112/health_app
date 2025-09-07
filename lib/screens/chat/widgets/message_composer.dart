
import 'package:flutter/material.dart';
import 'package:myapp/l10n/app_localizations.dart';

class MessageComposer extends StatefulWidget {
  final Function(String) onSendMessage;
  final bool isLoading;

  const MessageComposer({super.key, required this.onSendMessage, required this.isLoading});

  @override
  State<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  final TextEditingController _controller = TextEditingController();

  void _handleSend() {
    if (_controller.text.trim().isNotEmpty) {
      widget.onSendMessage(_controller.text.trim());
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: localizations.chatHint,
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6)),
                        ),
                        onSubmitted: widget.isLoading ? null : (_) => _handleSend(),
                        enabled: !widget.isLoading,
                        maxLines: null, // Allows multiline input
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            widget.isLoading
                ? const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: CircularProgressIndicator(),
                  )
                : Material(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(30.0),
                    child: InkWell(
                      onTap: _handleSend,
                      borderRadius: BorderRadius.circular(30.0),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(
                          Icons.send,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
