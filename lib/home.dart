import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Isolates Practice"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Lottie.asset("assets/animations/loading.json", width: 290),
              ElevatedButton(
                onPressed: () {
                  double output = complexTask1();
                  print("task1: $output");
                },
                child: const Text("Execute Main thread task1"),
              ),
              ElevatedButton(
                onPressed: () async {
                  double output = await complexFutureTask2();
                  print("task2: $output");
                },
                child: const Text(" // Future Async/Await task2"),
              ),
              //
              // Isolate Task
              ElevatedButton(
                onPressed: () async {
                  final receivePort = ReceivePort();
                  // this await is not for getting the response
                  // it's for creating an isolate because it requires some time
                  await Isolate.spawn(
                      complexTaskWithIsolates, receivePort.sendPort);
                  receivePort.listen((number) {
                    print("task3 with isolates: $number");
                  });
                },
                child: const Text(" Execute Isolate task"),
              ),
              //
              //
            ],
          ),
        ),
      ),
    );
  }

  double complexTask1() {
    double number = 0.0;
    for (var i = 0; i < 100000000; i++) {
      number += i;
    }
    return number;
  }

  // with future Async/Await
  Future<double> complexFutureTask2() async {
    double number = 0.0;
    for (var i = 0; i < 100000000; i++) {
      number += i;
    }
    return number;
  }
  //
}
// end of class

// Isolates Task
// should be outside of any class
complexTaskWithIsolates(SendPort sendPort) {
  double number = 0.0;
  for (var i = 0; i < 100000000; i++) {
    number += i;
  }
  sendPort.send(number);
}
