import 'package:flutter/material.dart';

void main() {
  runApp(AreaCalculatorApp());
}

class AreaCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Калькулятор площади',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AreaCalculatorScreen(),
    );
  }
}

class AreaCalculatorScreen extends StatefulWidget {
  @override
  _AreaCalculatorScreenState createState() => _AreaCalculatorScreenState();
}

class _AreaCalculatorScreenState extends State<AreaCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  String _result = '';
  bool _parametersSet = false;

  void _calculateArea() {
    if (_formKey.currentState!.validate()) {
      double width = double.parse(_widthController.text);
      double height = double.parse(_heightController.text);
      double area = width * height;
      setState(() {
        _result = 'S = $width * $height = ${area.toStringAsFixed(2)} мм²';
        _parametersSet = true;
      });
    } else {
      setState(() {
        _parametersSet = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Калькулятор площади',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _widthController,
                decoration: InputDecoration(
                  labelText: 'Ширина (мм)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите ширину';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Пожалуйста, введите корректное число';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(
                  labelText: 'Высота (мм)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Задайте ширину';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Задайте высоту';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculateArea,
                child: Text('Вычислить',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.all(16.0),
                ),
              ),
              SizedBox(height: 10),
              if (!_parametersSet)
                Text(
                  'Задайте параметры',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              if (_parametersSet && _result.isNotEmpty)
                Text(
                  _result,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}