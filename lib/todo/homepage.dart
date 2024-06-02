import 'package:flutter/material.dart';
import 'package:intern_assessment/backend/controller.dart';
import 'package:intern_assessment/backend/todo_dao.dart';
import 'package:intern_assessment/component.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _searchController = TextEditingController();
  var data;
  List<dynamic>? todoList;
  List<dynamic>? filteredList;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    data = TodoDAO().getTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child:
            // Stack(
            // children: [
            // Positioned(
            //     bottom: 20,
            //     right: 0,
            //     child: Container(
            //         width: 60,
            //         height: 60,
            //         decoration: BoxDecoration(
            //             shape: BoxShape.circle,
            //             color:
            //                 Theme.of(context).colorScheme.onPrimaryContainer),
            //         child: TextButton(
            //             onPressed: () {
            //               Navigator.of(context).pushNamed('/todo');
            //             },
            //             child: const Icon(
            //               Icons.add,
            //               color: Colors.white,
            //               size: 36,
            //             )))),
            Column(
          children: [
            Component().textfield(context, _searchController, false,
                decoration: const InputDecoration(hintText: 'Search'),
                onChanged: (value) {
              setState(() {
                print(value);
                filteredList = filterBySearch(value, todoList!);
              });
            }),
            Expanded(
              child: FutureBuilder(
                  future: data,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const CircularProgressIndicator();
                    } else {
                      todoList = snapshot.data as List<dynamic>;
                      filteredList ??= todoList;

                      if (filteredList!.isEmpty) {
                        return Center(
                          child: Text(
                            'No items found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: filteredList!.length,
                        itemBuilder: (context, index) {
                          final Map<String, dynamic> todoData =
                              filteredList![index] as Map<String, dynamic>;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                border: Border.all(style: BorderStyle.solid),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              child: ListTile(
                                title: Text(todoData['title']),
                                subtitle: todoData['due'] != null
                                    ? Text('Due: ' +
                                        todoData['due'] +
                                        ", " +
                                        todoData['due_time'])
                                    : null,
                                trailing: DropdownButton(
                                  value: todoData['status'],
                                  items: Component()
                                      .taskStatus
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: isUpdating
                                      ? null
                                      : (value) async {
                                          setState(() {
                                            isUpdating = true;
                                          });
                                          await TodoDAO().updateTodo(
                                              value.toString(), todoData['id']);
                                          setState(() {
                                            todoData['status'] = value!;
                                            isUpdating = false;
                                          });
                                        },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/todo');
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 36,
                      ))),
            )
          ],
        ),
        //   ],
        // ),
      ),
    );
  }
}
