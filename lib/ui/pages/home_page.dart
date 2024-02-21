import 'package:extumany/db/sql_helper.dart';
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
        children: const [
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
              icon: const Icon(
                Icons.play_circle_filled_rounded,
                size: 28,
              ),
              tooltip: 'Start workout',
              onPressed: () => Navigator.pushNamed(context, '/play'),
            ),
            IconButton(
              icon: const Icon(
                Icons.list_alt_rounded,
                size: 28,
              ),
              tooltip: 'Workouts',
              onPressed: () => Navigator.pushNamed(context, '/workouts'),
            ),
            IconButton(
              icon: const Icon(
                Icons.fitness_center_rounded,
                size: 28,
              ),
              tooltip: 'View exercises',
              onPressed: () => Navigator.pushNamed(context, '/exercises'),
            ),
            IconButton(
              icon: const Icon(
                Icons.auto_graph_rounded,
                size: 28,
              ),
              tooltip: 'View analytics',
              onPressed: () => Navigator.pushNamed(context, '/analytics'),
            ),
            IconButton(
                onPressed: () => SQLHelper.deleteDb(),
                icon: const Icon(
                  Icons.delete_forever_rounded,
                  size: 28,
                  color: Colors.red,
                )),
            IconButton(
                onPressed: () => SQLHelper.seedDb(),
                icon: const Icon(
                  Icons.cloud_download_rounded,
                  size: 28,
                  color: Colors.green,
                )),
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
