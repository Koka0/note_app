import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageImageView extends StatelessWidget {
  final Reference image;
  const StorageImageView({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: image.getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.done:
            if (snapshot.hasData) {
              final data = snapshot.data!;
              return Image.memory(
                data,
                fit: BoxFit.cover,
              );
            } else if (snapshot.hasError) {
              return AlertDialog(
                title: const Text('Basic dialog title'),
                content: const Text(
                  'A dialog is a type of modal window that\n'
                  'appears in front of app content to\n'
                  'provide critical information, or prompt\n'
                  'for a decision to be made.',
                ),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Disable'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
        }
      },
    );
  }
}
