import 'package:flutter/material.dart';
import 'package:swipee/swipee.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swipee Package Demo',
      builder: EasyLoading.init(),
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Swipee demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('SWIPEE:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            // basic usage
            Swipee(
                label: "Swipe Me",
                onSwipe: () {
                  EasyLoading.showSuccess('Swiped!');
                }),
            const SizedBox(height: 20),
            // customize track and button
            Swipee(
              trackWidth: 250,
              trackHeight: 30,
              buttonWidth: 80,
              buttonHeight: 50,
              color: Colors.red,
              trackColor: Colors.amber,
              onSwipe: () {
                EasyLoading.showSuccess('Swiped!');
              },
              trackChild: const Text('> > > > >', style: TextStyle(fontSize: 20)),
              child: const Icon(Icons.arrow_forward),
            ),
            const SizedBox(height: 20),
            // vertical swipe
            Swipee(
              axis: Axis.vertical,
              width: 50,
              height: 100,
              trackWidth: 30,
              trackHeight: 60,
              buttonWidth: 40,
              buttonHeight: 40,
              radius: 0,
              label: "GO!",
              color: Colors.blue,
              trackColor: Colors.indigo[100],
              onSwipe: () {
                EasyLoading.showSuccess('Swiped!');
              },
            )
          ],
        ),
      ),
    );
  }
}
