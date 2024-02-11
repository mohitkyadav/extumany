import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Extumany'),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          BoxItem(),
          BoxItem(),
          BoxItem(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                // Handle home button press
              },
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Handle search button press
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BoxItem extends StatelessWidget {
  const BoxItem({super.key});

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