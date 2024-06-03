import 'package:supabase_flutter/supabase_flutter.dart';

class UserDAO {
  final supabase = Supabase.instance.client;

  Future<dynamic> getUserInfo(String id) async {
    final data = await supabase.from('user').select().eq('id', id);

    return data;
  }
}
