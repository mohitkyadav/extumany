import 'package:flutter/material.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  static const routeName = '/analytics';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Your analytics'),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: const [
          AnalyticsBoxItem(),
          AnalyticsBoxItem(),
          AnalyticsBoxItem(),
        ],
      ),
    );
  }
}

class AnalyticsBoxItem extends StatelessWidget {
  const AnalyticsBoxItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 300,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Text(
          'Box Item',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
