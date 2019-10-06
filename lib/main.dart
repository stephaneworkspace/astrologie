
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './asc/calc_asc.dart';
import './asc/s_asc_return.dart';
import './zodiac/calc_zodiac.dart';
import './zodiac/s_zodiac_degre_return.dart';
import './zodiac/s_zodiac_degre.dart';
import './zodiac/s_zodiac_svg_return.dart';
import './draw/calc_draw.dart';
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
  CalcZodiac _calcZodiac;
  List<ZodiacSvgReturn> _zodiacSvg;
  AscReturn _ascReturn;
  ZodiacDegreReturn _zodiacDegreReturn;
  int _counter = 0;
  CalcDraw _calcDraw;
  List<Offset> _xyZodiacSizeLine; // size between 2 circle by point on 0° for the size of zodiac
  double _whZodiacSize; // size zodiac by the line between 2 circle

  bool _swLoaded = false;

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
  void initState() {
    super.initState();
    loadNatal(new DateTime.utc(1986, 3, 4, 4, 54)).whenComplete(() {
      setState(() {
        _swLoaded = true;
      });
    });
  }

  loadNatal(DateTime natal) async {
    CalcAsc calcAsc = new CalcAsc(new DateTime.utc(1986, 3, 4, 4, 54));
    await calcAsc.setJson();
    setState(() {
      _ascReturn = calcAsc.getAsc();
    });
    _calcZodiac = new CalcZodiac(_ascReturn.degre, _ascReturn.sign.index + 1);
    await _calcZodiac.setJson();
    setState(() {
      _zodiacDegreReturn = _calcZodiac.getDegre();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_swLoaded) {
      _calcDraw = new CalcDraw(MediaQuery.of(context).size.width , MediaQuery.of(context).size.height);
      // At °0, no importance, ist juste for have the size of zodiac container care
      _xyZodiacSizeLine = _calcDraw.lineTrigo(0, _calcDraw.getRadiusCircle(1), _calcDraw.getRadiusCircle(0));
      _whZodiacSize = _calcDraw.sizeZodiac(_xyZodiacSizeLine[0], _xyZodiacSizeLine[1]);
      _whZodiacSize = (_whZodiacSize * 48) / 100;
      _zodiacSvg = _calcZodiac.getZodiacSvg(_calcDraw, _whZodiacSize);
    }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    if (_swLoaded) {
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
                    size: Size(_calcDraw.getSizeWH(), _calcDraw.getSizeWH()), // 375, 736 max iphone6s
                    painter: new DrawAstro(_zodiacDegreReturn),
                  ),
                )
              ),
              /*
              Positioned(
                child: Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: new CustomPaint(
                    size: Size(_calcDraw.getSizeWH(), _calcDraw.getSizeWH()), // 375, 736 max iphone6s
                    painter: new DrawSquare(),
                  ),
                )
              ),*/
              /*
              for (var z in _zodiacSvg)
                Positioned( //.fill not identic
                  left: z.xyZodiac.dx,
                  top: z.xyZodiac.dy,
                  child: new Container(
                    width: _whZodiacSize,
                    height: _whZodiacSize,
                    decoration: new BoxDecoration(color: Colors.grey),
                  )
                ),*/
              for (var z in _zodiacSvg)
                Positioned( //.fill not identic
                  left: z.xyZodiac.dx,
                  top: z.xyZodiac.dy,
                  child: new GestureDetector(
                    onTap: () {
                      print("onTap called. " + z.zodiac.name);
                    },
                    child: new Container(
                      width: _whZodiacSize,
                      height: _whZodiacSize,
                      margin: const EdgeInsets.only(left: 0.0, right: 0.0),
                      padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                      child: SvgPicture.asset(z.zodiac.svg,
                        width: _whZodiacSize,
                        height: _whZodiacSize,
                        fit: BoxFit.scaleDown,
                        allowDrawingOutsideViewBox: true,
                        alignment: Alignment.center,
                        color: z.zodiac.element.color, 
                        semanticsLabel: z.zodiac.name
                      ),
                    )
                  ),
              ),
            ],
          ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        )
      );
    }
  }
}
