import 'dart:io';
import 'dart:async';

Socket socket;

void socketconnect() {
  Socket.connect("localhost", 4567).then((Socket sock) {
    socket = sock;
    socket.listen(dataHandler,
        onError: errorHandler,
        onDone: doneHandler,
        cancelOnError: false);
  }).catchError((AsyncError e) {
    print("Unable to connect: $e");
  });
  //Connect standard in to the socket
  //stdin.listen((data) => socket.write(new String.fromCharCodes(data).trim() + '\n'));
}

void dataHandler(data){
  print(new String.fromCharCodes(data).trim());
}

void errorHandler(error, StackTrace trace){
  print(error);
}

void doneHandler(){
  socket.destroy();
}