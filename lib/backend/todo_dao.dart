import 'package:supabase_flutter/supabase_flutter.dart';

class TodoDAO {
  final supabase = Supabase.instance.client;

  Future addTodo(String title, String status, String date, String time) async {
    try {
      if (date != "" && time != "") {
        await supabase.from("todo_item").insert({
          "title": title,
          "due": date,
          "due_time": time,
          "status": status,
          "user": supabase.auth.currentUser!.id
        });
      } else {
        await supabase.from("todo_item").insert({
          "title": title,
          "status": status,
          "user": supabase.auth.currentUser!.id
        });
      }

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<dynamic> getTodo() async {
    final data = await supabase
        .from('todo_item')
        .select()
        .eq("user", supabase.auth.currentSession!.user.id);

    return data;
  }

  Future<void> updateTodoStatus(String status, int id) async {
    await supabase
        .from('todo_item')
        .update({'status': status})
        .eq('user', supabase.auth.currentUser!.id)
        .eq('id', id);
  }

  Future<void> updateTodo(
      String title, String status, String date, String time, int id) async {
    await supabase
        .from('todo_item')
        .update(
            {'title': title, 'status': status, 'due': date, 'due_time': time})
        .eq('user', supabase.auth.currentUser!.id)
        .eq('id', id);
  }

  Future<void> deleteTodo(int id) async {
    await supabase
        .from('todo_item')
        .delete()
        .eq('user', supabase.auth.currentUser!.id)
        .eq('id', id);
  }
}
