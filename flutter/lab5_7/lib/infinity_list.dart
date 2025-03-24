import 'package:flutter/material.dart';

class InfinityList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Бесконечный список'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: null,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item $index'),
          );
        },
      ),
    );
  }
}