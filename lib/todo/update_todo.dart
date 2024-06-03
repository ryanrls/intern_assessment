import 'package:flutter/material.dart';
import 'package:intern_assessment/backend/todo_dao.dart';
import 'package:intern_assessment/component.dart';

class UpdateTodo extends StatefulWidget {
  final String title;
  final String? date;
  final String? time;
  final String status;
  final int id;

  const UpdateTodo({
    required this.title,
    required this.date,
    required this.time,
    required this.status,
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  State<UpdateTodo> createState() => _UpdateTodoState();
}

class _UpdateTodoState extends State<UpdateTodo> {
  late TextEditingController _titleController = TextEditingController();
  late TextEditingController _dateController = TextEditingController();
  late TextEditingController _timeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  String? dropdownValue;
  int? id;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _dateController = TextEditingController(text: widget.date);
    _timeController = TextEditingController(text: widget.time);
    dropdownValue = widget.status;
    id = widget.id;

    print(_dateController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Component().appBar(context, title: const Text('Update To-Do')),
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
              TextFormField(
                validator: (value) {
                  if (_dateController.text.isEmpty &&
                      _timeController.text.isNotEmpty) {
                    return "Please Select Date";
                  }
                  return null;
                },
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
              TextFormField(
                validator: (value) {
                  if (_timeController.text == "" ||
                      _timeController.text.isEmpty &&
                          _dateController.text.isNotEmpty) {
                    return "Please Select Time";
                  }
                  return null;
                },
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
              Component().submitButton(
                  context,
                  "Update To-Do",
                  isLoading
                      ? null
                      : () async {
                          try {
                            if (_formKey.currentState!.validate()) {
                              await TodoDAO().updateTodo(
                                  _titleController.text,
                                  dropdownValue!,
                                  _dateController.text,
                                  _timeController.text,
                                  id!);

                              if (context.mounted) {
                                Component().snackBar(context,
                                    "To-Do Updated Successfully", false);
                              }

                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/homepage', (route) => false);
                            }
                          } catch (e) {
                            if (context.mounted) {
                              Component().snackBar(context, e.toString(), true);
                            }
                          }
                        }),
              Component().submitButton(
                  context,
                  "Delete To-Do",
                  isLoading
                      ? null
                      : () async {
                          try {
                            setState(() {
                              isLoading = true;
                            });

                            await TodoDAO().deleteTodo(id!);

                            if (context.mounted) {
                              Component().snackBar(
                                  context, "To-Do Deleted Successfully", false);
                            }

                            setState(() {
                              isLoading = false;
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/homepage', (route) => false);
                            });
                          } catch (e) {
                            if (context.mounted) {
                              Component().snackBar(context, e.toString(), true);
                            }
                          }
                        },
                  backgroundColor:
                      Theme.of(context).colorScheme.onErrorContainer,
                  textColor: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
