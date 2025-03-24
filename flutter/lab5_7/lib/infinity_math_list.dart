import 'package:flutter/material.dart';
import 'dart:math';

class InfinityMathList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Бесконечный мат список'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: null,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('2^$index = ${pow(2, index)}'),
          );
        },
      ),
    );
  }
}