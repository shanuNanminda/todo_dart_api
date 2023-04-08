import 'dart:convert';
import 'dart:io';

import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

MySqlConnection? conn;

// Configure routes.
final _router = Router()
  ..post('/login', login)
  ..post('/user_data', login) 
  ..post('/user_register', userRegister);

Future<Response> login(Request req) async {
  
  final message = jsonDecode(await req.readAsString());
  
  String username = message['username'];
  String password = message['password'];
  if (username == null || password == null) {
    return Response.notFound(jsonEncode('username or password not found'));
  } else {
    Results res = await conn!.query(
        "insert into login_table(username, password) values('$username', '$password')");
    return Response.ok(jsonEncode({'message': 'inserted'}));
  }
}

Future<Response> userData(Request req) async {
  final message = jsonDecode(await req.readAsString());
  String username = message['login_id'];
  String password = message['password'];
  if (username == null || password == null) {
    return Response.notFound(jsonEncode('username or password not found'));
  } else {
    Results res = await conn!.query(
        "insert into login_table(username, password) values('$username', '$password')");
    return Response.ok(jsonEncode({'message': 'inserted'}));
  }
}

Future<Response> userRegister(Request req) async {
  final message = jsonDecode(await req.readAsString());
  String name = message['name'];
  String phone = message['phone'];
  String username = message['username'];
  String password = message['password'];
  String email = message['email'];
  if (name == null || phone == null||username==null||password==null) {
    return Response.notFound(jsonEncode('name or phone not found'));
  } else {
    Results res = await conn!.query(
        "insert into login_table(username, password) values('$email', '$password')");
    Results registerResponse = await conn!
        .query("insert into user_table(name, phone, email) values('$name', '$phone', '$email')");
    return Response.ok(jsonEncode({'message': 'inserted'}));
  }
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
  final port = int.parse( '8000');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
