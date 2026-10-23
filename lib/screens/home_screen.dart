import 'package:flutter/material.dart';

import '../widgets/app_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lockin')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppButton(
              text: 'Open Login',
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
            const SizedBox(height: 15),
            AppButton(
              text: 'Open Report Form',
              onPressed: () {
                Navigator.pushNamed(context, '/report');
              },
            ),
          ],
        ),
      ),
    );
  }
}
