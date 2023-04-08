import 'dart:convert';

import 'package:http/http.dart';

Future<void> main() async {
  // Response res = await post(Uri.parse('http://127.0.0.1:8080/add_note'),
  //     body: jsonEncode({
  //       'title': 'sample note',
  //       'content': 'this is a sample content for testing',
  //     }));
  Response res=await get(Uri.parse('http://127.0.0.1:8080/get_notes'));
  // delete(Uri.parse('http://127.0.0.1:8080/remove_note'),body: jsonEncode({'id':2}));
  print(res.body);
  // print('${DateTime.now()}');
  // print('hi');
  // print('${DateTime.now()}');
  // print('hi');
  // print('${DateTime.now()}');
  // print('hi');
  // print('${DateTime.now()}');
  // print('hi');
  // print('${DateTime.now()}');
  // print('hi');
  // print('${DateTime.now()}');
  // print('hi');
  // print('${DateTime.now()}');
  // print('hi');
  // print('${DateTime.now()}');
  // print('hi');
}
