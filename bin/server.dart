import 'dart:convert';
import 'dart:io';

import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

MySqlConnection? conn;

// Configure routes.
final _router = Router()
  ..get('/get_notes', getNote)
  // ..get('/stream', streamTest)
  ..post('/add_note', addNote)
  // ..post('/add_note', addChat)
  ..patch('/edit_note', editNote)
  ..delete('/remove_note', removeNote);

Future<Response> removeNote(Request req) async {
  final message = jsonDecode(await req.readAsString());
  int id = message['id'];
  // String content = message['content'];
  Results res = await conn!.query("delete from test where id='$id'");
  return Response.ok(jsonEncode({'message': 'deleted'}));
}

Future<Response> editNote(Request req) async {
  final message = jsonDecode(await req.readAsString());
  int id = message['id'];
  String title = message['title'];
  String content = message['content'];
  // String content = message['content'];
  Results res = await conn!.query(
      "UPDATE test set title= '$title', content='$content' where id='$id'");
  return Response.ok(jsonEncode({'message': 'updated'}));
}

Future<Response> addNote(Request req) async {
  final message = jsonDecode(await req.readAsString());
  String title = message['title'];
  String content = message['content'];
  if (title == null || content == null) {
    return Response.notFound(jsonEncode('title or content not found'));
  } else {
    Results res = await conn!
        .query("insert into test(title, content) values('$title', '$content')");
    return Response.ok(jsonEncode({'message': 'inserted'}));
  }
}

Future<Response> addChat(Request req) async {
  final data = jsonDecode(await req.readAsString());
  String sender = data['sender'];
  String reciever = data['reciever'];
  String message = data['message'];

  // if(title==null||content==null){
  //   return Response.notFound(jsonEncode('title or content not found'));
  // }else{
  Results res = await conn!.query(
      "insert into chats_table(senderId, recieverId, message) values('$sender', '$reciever', '$message')");
  return Response.ok(jsonEncode({'message': 'inserted'}));
}

Future<Response> getNote(Request req) async {
  // final message = jsonDecode(await req.readAsString());
  // String title = message['title'];
  // String content = message['content'];
  Results res = await conn!.query("select * from test");

  return Response.ok(
      jsonEncode({'message': res.map((element) => element.fields).toList()}));
}

Future<void> startDB() async {
  conn = await MySqlConnection.connect(ConnectionSettings(
    host: '127.0.0.1',
    port: 3306,
    user: 'root',
    // password: '',
    db: 'test',
  ));
  print('connection $conn');
  print('connection done');
}

void main(List<String> args) async {
  await startDB();
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
