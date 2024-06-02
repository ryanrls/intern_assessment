import 'package:flutter/material.dart';
import 'package:intern_assessment/component.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Stack(
          children: [
            Positioned(
                bottom: 20,
                right: 0,
                child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                    child: TextButton(
                        onPressed: () {},
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 36,
                        )
                        // Text('+', style: TextStyle(color: Colors.white, fontSize: 30)),
                        ))),
            Column(
              children: [
                Component().textfield(context, _searchController, false,
                    decoration: const InputDecoration(hintText: 'Search'))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
