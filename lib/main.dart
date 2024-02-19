import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  // Gemini.init(apiKey: const String.fromEnvironment('API_KEY'), enableDebugging: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Gemini',
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class SectionItem {
  final int index;
  final String title;
  final Widget widget;

  SectionItem(this.index, this.title, this.widget);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final model = GenerativeModel(
      model: 'gemini-pro', apiKey: 'API_KEY');
  var res = '';
  bool check = false;
  TextEditingController questionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  getRes(ques) async {
    setState(() {
      check = true;
    });
    final response = await model.generateContent([Content.text('$ques')]);
    res = "${response.text}";
    setState(() {
      check = false;
    });
    print("\n\n\n\n\n Res data: ${response.text} \n\n\n\n\n\n");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter Gemini'),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20.0),
          color: Colors.white,
          child: Stack(
            children: [
              Container(
                child: SingleChildScrollView(
                  child:Column(
                    children: [
                      check
                          ? const SpinKitWave(
                        color: Colors.blue,
                        size: 20.0,
                      )
                          : Text(
                        res,
                        style: const TextStyle(
                            color: Colors.black, fontSize: 20.0),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Positioned(
                right: 0,
                left: 0,
                bottom: 0,
                child: TextFormField(
                  controller: questionController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      hintText: 'Enter your question',
                      filled: true,
                      fillColor: Colors.black,
                      // Set your desired background color here
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          getRes(questionController.text);
                        },
                        icon: Icon(
                          Icons.skip_next_outlined,
                          color: Colors.white,
                        ),
                      )),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
