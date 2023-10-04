import 'package:flutter/material.dart';

class ErrorIndicator extends StatelessWidget {
  final VoidCallback onRetry;
  final String message;

  const ErrorIndicator({
    Key? key,
    required this.onRetry,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(message),
        TextButton(
          onPressed: onRetry,
          child: const Text(
            'Retry',
          ),
        ),
      ],
    );
  }
}
