import 'package:flutter/material.dart';

/// Replace [HiddenAppPlaceholder] with your hidden experience.
///
/// The widget should be self-contained and avoid relying on the calculator
/// state. You can safely import services or other packages required by your
/// hidden application here.
class HiddenAppPlaceholder extends StatelessWidget {
  const HiddenAppPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hidden Application'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Icon(Icons.lock_open, size: 72),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'This is a placeholder hidden app. Replace the contents of '\
                'HiddenAppPlaceholder with your own widgets to build a secure '\
                'experience.',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
