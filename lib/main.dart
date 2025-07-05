import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:service_stack/screens/BottomNavPage.dart';
import 'dart:convert';

import 'package:service_stack/screens/user/LoginPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Navigation Demo',
      theme: ThemeData(useMaterial3: true),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String _response = '';
  bool _loading = false;
  bool _error = false;


  Future<void> fetchData() async {
    setState(() {
      _loading = true;
      _error = false;
    });

    var url = Uri.parse('http://192.168.1.2:5000/');

    try{
      var response = await http.get(url);

      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        setState(() {
          _response = "Title : ${data['title']}\nBody: ${data['message']}";
          _loading = false;
        });
      }else{
        setState(() {
          _response = 'Error : Status ${response.statusCode}';
          _loading = false;
          _error = true;
        });
      }
    }catch(e){
      setState(() {
        _response = 'Error : $e';
        _loading = false;
        _error = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Activity Example'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: fetchData,
              child: Text('Fetch Data from API'),
            ),
            SizedBox(height: 20),
            if (_loading) CircularProgressIndicator(),
            if (!_loading)
              Text(
                _response,
                style: TextStyle(
                  color: _error ? Colors.red : Colors.black,
                  fontSize: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
