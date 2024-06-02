import 'package:flutter/material.dart';
import 'package:intern_assessment/backend/todo_dao.dart';
import 'package:intern_assessment/component.dart';

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  String dropdownValue = Component().taskStatus.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add To-do'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Component().subheader('To-Do: '),
              Component().textfield(context, _titleController, false,
                  decoration: const InputDecoration(hintText: 'Add To-Do')),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Component().subheader('Task Status: '),
                  DropdownButton(
                    value: dropdownValue,
                    items: Component().taskStatus.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                  ),
                ],
              ),
              Component().subheader("Due Date: "),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _dateController,
                decoration: Component().dateTimeTextFieldStyle(context, "Date",
                    prefixIcon: const Icon(Icons.calendar_today)),
                readOnly: true,
                onTap: () async {
                  DateTime? date = await Component().showDate(context);
                  if (date == null || date.toString() == "") {
                    _dateController.clear();
                  } else {
                    _dateController.text = date.toString().split(" ")[0];
                  }
                },
              ),
              TextField(
                controller: _timeController,
                decoration: Component().dateTimeTextFieldStyle(context, "Time",
                    prefixIcon: const Icon(Icons.timer)),
                readOnly: true,
                onTap: () async {
                  TimeOfDay? time = await Component().showTime(context);
                  if (time == null || time.toString() == "") {
                    _timeController.clear();
                  } else {
                    _timeController.text = "${time.hour}:${time.minute}";
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Component().loginButton(
                  context,
                  "Add To-Do",
                  isLoading
                      ? null
                      : () async {
                          try {
                            setState(() {
                              isLoading = true;
                            });

                            await TodoDAO().addTodo(
                                _titleController.text,
                                dropdownValue,
                                _dateController.text,
                                _timeController.text);

                            // if (success == true && context.mounted) {
                            //   _dateController.clear();
                            //   _titleController.clear();
                            //   _timeController.clear();
                            //   dropdownValue = Component().taskStatus.first;
                            // }
                            if (context.mounted) {
                              Component().scaffold(
                                  context, "To-Do Successfully Added", false);
                            }

                            setState(() {
                              isLoading = false;
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/homepage', (route) => false);
                            });
                          } catch (e) {
                            if (context.mounted) {
                              Component().scaffold(context, e.toString(), true);
                            }
                          }
                        }),
            ],
          ),
        ),
      ),
    );
  }
}
