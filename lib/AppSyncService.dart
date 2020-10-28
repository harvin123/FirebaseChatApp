import 'package:ChatApp/rx_command.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' as convert;
import './message.dart';
class AppSyncService{

  RxCommand<String,Message> subscribedMessageCommand;
  AppSyncService() {
    subscribedMessageCommand =
        RxCommand.createAsync<String,Message>(
            subscribeNewMessage);
   // subscribedMessageCommand.listen((value) { print(value); });
  }

  final StreamController<Message> messageBroadcast =
  new StreamController<Message>.broadcast();

  Future<Message> sendMessage(String content, String doctorId,String patientId,String type,String author) async {
    try {
      var response =
      await http.post("http://192.168.1.26:3000/newMessage",
          body: {
            "content": content,
            "patientId": patientId,
            "doctorId": doctorId,
            "type": type,
            "author": author
          },
          headers: {
        "Accept": "application/json",
        "content-type": "application/x-www-form-urlencoded",
      });
      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 201) {
        return Message.fromJson(body);
        }
      else {
        throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
  Future<Message> subscribeNewMessage(String patientId) async {
    try {
      var response =
      await http.post("http://192.168.1.26:3000/subscribetomymessage/pat01/doct01",
          body: null,
          headers: {
        "Accept": "application/json",
        "content-type": "application/x-www-form-urlencoded",
      });
      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 201) {
        Message message = Message.fromJson(body);
        //_save(message);
        messageBroadcast.add(message);
        return message;
      }
      else {
       // return {"body": response.body};
       throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Message>> getAllMessages(String patientId,String doctorId) async {
    try {
      var response =
      await http.get("http://192.168.1.26:3000/Getallmessages/$patientId/$doctorId",
          headers: {
        "Accept": "application/json",
        "content-type": "application/x-www-form-urlencoded",
      });
      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
       return  body.map((value) => Message.fromJson(value)).toList();
        //return body;
      } else {
        throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}