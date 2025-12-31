import 'package:flutter/material.dart';

void main() => runApp(const AlertDialogExampleApp());

class AlertDialogExampleApp extends StatelessWidget {
  const AlertDialogExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('AlertDialog ')),
        body: const Center(child: DialogExample()),
      ),
    );
  }
}
class Mytext extends StatelessWidget {
  const Mytext({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(),
    );
  }

}
class DialogExample extends StatelessWidget {
  const DialogExample({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text('the title should not be empty'),
          actions: <Widget>[
            
            TextButton(onPressed: () => Navigator.pop(context, 'OK'), child: const Text('OK')),
          ],
        ),
      ),
      child: const Text('click me'),
    );
  }
}