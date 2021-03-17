import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<String> readCachedData({String name: '', String uri: '', String path: ''}) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = new File("${dir.path}/$name");

  try {
    var httpClient = http.Client();
    var response = await httpClient.read(Uri.https(uri, path));

    file.writeAsString(response, flush: true, mode: FileMode.write);
    print("File from Web loaded");
    return response;
  } on SocketException catch (ex) {
    var response = await file.readAsString();
    print("Excepion: $ex");
    return response;
  }
}
