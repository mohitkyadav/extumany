import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.onConfirm,
    this.title = 'Are you sure?',
    this.content = const Text('This action cannot be undone.'),
    this.confirmText = 'Yes',
    this.cancelText = 'Cancel',
    this.onCancel,
  });

  final String title;
  final Widget content;
  final String confirmText;
  final String cancelText;
  final Function onConfirm;
  final Function? onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: content,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();

            if (onCancel != null) {
              onCancel!();
            }
          },
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: Text(confirmText),
        ),
      ],
    );
  }
}
