import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './asc/calc_asc.dart';
import './asc/s_asc_return.dart';
import './zodiac/calc_zodiac.dart';
import './zodiac/s_zodiac_degre_return.dart';
import './draw_astro.dart';
import './draw_square.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // main();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  AscReturn _ascReturn;
  ZodiacDegreReturn _zodiacDegreReturn;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    CalcAsc calcAsc = new CalcAsc(new DateTime.utc(1986, 3, 4, 4 , 54));
    _ascReturn = calcAsc.getAsc();
    if (_ascReturn != null) {
      CalcZodiac calcZodiac = new CalcZodiac(_ascReturn.degre, _ascReturn.sign.index + 1);
      _zodiacDegreReturn = calcZodiac.getDegre();
    }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      //body: Center(
        body: Stack(
          children: <Widget>[
            Positioned(
              child: Align(
                alignment: AlignmentDirectional.topCenter,
                child: new CustomPaint(
                  size: Size(375.0, 375.0), // 375, 736 max iphone6s
                  painter: new DrawAstro(_zodiacDegreReturn),
                ),
              )
            ),
            Positioned(
              child: Align(
                alignment: AlignmentDirectional.topCenter,
                child: new CustomPaint(
                  size: Size(375.0, 375.0), // 375, 736 max iphone6s
                  painter: new DrawSquare(),
                ),
              )
            ),
            Positioned( //.fill not identic
              top: 375.0 / 2.0,
              left: MediaQuery.of(context).size.width / 2.0,
              child: new Container(
                width: 30.0,
                height: 30.0,
                decoration: new BoxDecoration(color: Colors.blue),
              )
            ),
            Positioned( //.fill not identic
              top: 375.0 / 2.0,
              left: MediaQuery.of(context).size.width / 2.0,
              child: IconButton(
                icon: SvgPicture.asset('assets/svg/zodiac/belier.svg',
                    height: 30.0,
                    width: 30.0,
                    alignment: Alignment.topLeft,
                    color: Colors.red, 
                    semanticsLabel: 'Belier'
                  ),
                onPressed: () {},
              )
            ),
            /*Container(
              /// width, left = - 375
              /// width, center = MediaQuery.of(context).size.width
              /// 
              ///
              width: MediaQuery.of(context).size.width, // 375 on iPhone 6s
              height: 375.0, // This is static for now, latter for ipad and tablet
              child: IconButton(
                icon: SvgPicture.asset('assets/svg/zodiac/belier.svg',
                    height: 30,
                    width: 30,
                    //alignment: Alignment(100.00, 100.00),
                    color: Colors.red, 
                    semanticsLabel: 'Belier'
                  ),
                onPressed: () {},
              )
            )*/
            /*
            Positioned(
              left: -375.0,
              right: -375.0,
              child: IconButton(
                icon: SvgPicture.asset('assets/svg/zodiac/belier.svg',
                    height: 30,
                    width: 30,
                    //alignment: Alignment(100.00, 100.00),
                    color: Colors.red, 
                    semanticsLabel: 'Belier'
                  ),
                onPressed: () {},
              )
            )*/

          ],
        ),
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        /*child: Column(
          children: <Widget>[
          Align(
            alignment: FractionalOffset.center,
            child: new CustomPaint(
              size: Size(375, 375), // 375, 736 max iphone6s
              painter: new DrawAstro(_zodiacDegreReturn),
            ),
          ),
          Align(
            child: new Text(_ascReturn.sign.toString())
          ),
          Align(
            child: new Text(_ascReturn.degre.toString())
          )
          ]
        )*/
      //),
        // child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          // mainAxisAlignment: MainAxisAlignment.center,
          /*children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],*/
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
