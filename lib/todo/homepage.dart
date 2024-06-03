import 'package:flutter/material.dart';
import 'package:intern_assessment/backend/controller.dart';
import 'package:intern_assessment/backend/todo_dao.dart';
import 'package:intern_assessment/component.dart';
import 'package:intern_assessment/todo/update_todo.dart';

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
  List<dynamic>? filteredStatus;
  List<dynamic>? filteredSearch;
  bool isUpdating = false;

  String dropDownValue = "All";
  List<String> filterCategories = ['All', 'To-Do', 'Urgent', 'Done'];

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
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: Component().textfield(
                      context, _searchController, false,
                      decoration: const InputDecoration(hintText: 'Search'),
                      onChanged: (value) {
                    setState(() {
                      filteredSearch =
                          Filter().filterBySearch(value, todoList!);

                      if (filteredStatus == null || filteredStatus == []) {
                        filteredList = filteredSearch;
                        return;
                      }

                      filteredList = Filter()
                          .filterSearchStatus(filteredStatus!, filteredSearch!);
                    });
                  }),
                ),
                DropdownButton(
                    value: dropDownValue,
                    items: filterCategories.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      filteredStatus = Filter()
                          .filterByStatus(value!, filteredSearch!, todoList!);

                      filteredList = Filter()
                          .filterSearchStatus(filteredStatus!, filteredSearch!);

                      setState(() {
                        dropDownValue = value;
                      });
                    })
              ],
            ),
            Expanded(
              child: FutureBuilder(
                  future: data,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const CircularProgressIndicator();
                    } else {
                      todoList = snapshot.data as List<dynamic>;
                      filteredList ??= todoList;
                      filteredSearch ??=
                          filteredList; //filtered search get refresh with new to do
                      Filter().sortByDate(filteredList!);

                      if (filteredList!.isEmpty) {
                        return const Center(
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

                          return GestureDetector(
                            onTap: () {
                              print('tap');
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => UpdateTodo(
                                      title: todoData['title'],
                                      date: todoData['due'],
                                      time: todoData['due_time'],
                                      status: todoData['status'],
                                      id: todoData['id'])));
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  border: Border.all(style: BorderStyle.solid),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
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
                                            await TodoDAO().updateTodoStatus(
                                                value.toString(),
                                                todoData['id']);

                                            setState(() {
                                              todoData['status'] = value!;

                                              //refresh page after updating status

                                              filteredSearch = Filter()
                                                  .filterBySearch(
                                                      _searchController.text,
                                                      todoList!);

                                              filteredStatus = Filter()
                                                  .filterByStatus(
                                                      dropDownValue,
                                                      filteredSearch!,
                                                      todoList!);

                                              filteredList = Filter()
                                                  .filterSearchStatus(
                                                      filteredSearch!,
                                                      filteredStatus!);

                                              isUpdating = false;
                                            });
                                          },
                                  ),
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
