import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:starflut/starflut.dart';
import './zodiac/calc_zodiac.dart';
import './draw/calc_draw.dart';
import './draw_astro.dart';
import './draw_square.dart';
import 'angle/calc_angle.dart';
import 'angle/s_angle.dart';
import 'component/hex_color.dart';
import 'house/s_house.dart';
import 'planet/calc_planet.dart';
import 'planet/s_planet.dart';
import 'zodiac/s_zodiac.dart';
import 'content/s_content.dart';
import 'content/e_type_content.dart';
import 'zodiac_text/s_zodiac_text.dart';
import 'house/calc_house.dart';
import 'zodiac_text/calc_zodiac_text.dart';

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

/// Test call python with starcore - starflut
Future<void> testCallPython() async {
    var _outputString = '';
    StarCoreFactory starcore = await Starflut.getFactory();
    StarServiceClass service = await starcore.initSimple("test", "123", 0, 0, []);
    await starcore.regMsgCallBackP(
        (int serviceGroupID, int uMsg, Object wParam, Object lParam) async {
          if( uMsg == Starflut.MSG_DISPMSG || uMsg == Starflut.MSG_DISPLUAMSG ) {
              print('wParam:' + _outputString + wParam);
          }
      print("$serviceGroupID  $uMsg   $wParam   $lParam");
      return null;
    });
    StarSrvGroupClass srvGroup = await service["_ServiceGroup"];

    /*---script python--*/
    bool isAndroid = await Starflut.isAndroid();
    if( isAndroid == true ){
      await Starflut.copyFileFromAssets("testpy.py", "flutter_assets/starfiles","flutter_assets/starfiles");
      await Starflut.copyFileFromAssets("python3.6.zip", "flutter_assets/starfiles",null);  //desRelatePath must be null 
      await Starflut.copyFileFromAssets("zlib.cpython-36m.so", null,null);
      await Starflut.copyFileFromAssets("unicodedata.cpython-36m.so", null,null);
      await Starflut.loadLibrary("libpython3.6m.so");
    }

    String docPath = await Starflut.getDocumentPath();
    print("docPath = $docPath");

    String resPath = await Starflut.getResourcePath();
    print("resPath = $resPath");

    if( await srvGroup.initRaw("python36", service) == true ){
      _outputString = "init starcore and python 3.6 successfully";
      //_isButtonDisabled = false;
    }else{
      _outputString = "init starcore and python 3.6 failed";
    }

    print("initRaw = $_outputString");

    await srvGroup.runScript('python','print("This line will be printed.")', null);
    await srvGroup.runScript('python', resPath + '/flutter_assets/starfiles/astro_py/flatlib/setup.py install', null);
    await srvGroup.runScript('python', resPath + '/flutter_assets/starfiles/astro_py/setup.py install', null);
		var result = await srvGroup.loadRawModule('python', '', resPath + '/flutter_assets/starfiles/astro_py/' + 'astro_py.py', false);
    print('loadRawModule = $result');
    StarObjectClass cAstroPy = await service.importRawContext('python', 'astro_py', true, '');
    StarObjectClass cAstroPyInstance = await cAstroPy.newObject(['2019/10/12', '23:00', '+02:00', '46n12', '6e9']);
    print(await cAstroPyInstance.getString());
    print(await cAstroPyInstance.call("helloworld", ['Stéphane', 'Bressani']));
    await srvGroup.clearService();
		await starcore.moduleExit();
  }

  CalcZodiac _calcZodiac;
  List<Zodiac> _zodiac;
  CalcHouse _calcHouse;
  List<House> _house;
  CalcAngle _calcAngle;
  List<Angle> _angle;
  CalcPlanet _calcPlanet;
  List<Planet> _planet;
  int _counter = 0;
  List<Offset> _xyZodiacSizeLine; // size between 2 circle by point on 0° for the size of zodiac
  List<Offset> _xyHouseSizeLine;
  List<Offset> _xyAngleSizeLine;
  List<Offset> _xyAngleDegSizeLine;
  List<Offset> _xyAngleMinSizeLine;
  List<Offset> _xyPlanetSizeLine;
  List<Offset> _xyPlanetDegSizeLine;
  List<Offset> _xyPlanetMinSizeLine;

  bool _swFullScreen = false;

  bool _swLoaded = false;
  bool _swZodiacText = false; // to do a switch
  CalcZodiacText _calcZodiacText;
  List<ZodiacText> _zodiacText;
  ZodiacText _zodiacTextSelect = new ZodiacText('', null);

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      if (_swFullScreen)
        _swFullScreen = false;
      else
        _swFullScreen = true;
    });
  }

  void _zodiacClick(int id) {
    setState(() {
      _swZodiacText = true;
      Map<int, ZodiacText> map = _zodiacText.asMap();
      _zodiacTextSelect = map[id - 1];
    });
  }

  @override
  void initState() {
    super.initState();
    loadNatal().whenComplete(() {
      setState(() {
        _swLoaded = true;
      });
    });
  }

  loadNatal() async {
    _calcZodiac = new CalcZodiac();
    _zodiac = new List<Zodiac>();
    _calcHouse = new CalcHouse();
    _house = new List<House>();
    _calcAngle = new CalcAngle();
    _angle = new List<Angle>();
    _calcPlanet = new CalcPlanet();
    _planet = new List<Planet>();
    await _calcZodiac.parseJson();
    await _calcHouse.parseJson();
    await _calcAngle.parseJson();
    await _calcPlanet.parseJson();
    // text
    _zodiacText = new List<ZodiacText>();
    _calcZodiacText = new CalcZodiacText();
    _zodiacText = await _calcZodiacText.parseJson();
  }

  @override
  Widget build(BuildContext context) {
    CalcDraw calcDraw;
    double whZodiacSize; // size zodiac by the line between 2 circle
    double whHouseSize;
    double whAngleSymbolSize;
    double whAngleDegSymbolSize;
    double whAngleMinSymbolSize;
    double whPlanetSymbolSize;
    double whPlanetDegSymbolSize;
    double whPlanetMinSymbolSize;
    if (_swLoaded) {
      calcDraw = new CalcDraw(MediaQuery.of(context).size.width , MediaQuery.of(context).size.height);
      // At °0, no importance, ist juste for have the size of zodiac container care
      _xyZodiacSizeLine = calcDraw.lineTrigo(0, calcDraw.getRadiusCircleZodiacCIRCLE1WithoutLine(), calcDraw.getRadiusCircle(0));
      whZodiacSize = calcDraw.sizeZodiac(_xyZodiacSizeLine[0], _xyZodiacSizeLine[1]); 
      whZodiacSize = (whZodiacSize * 50) / 100;
      _zodiac = _calcZodiac.calcDrawZodiac(calcDraw, whZodiacSize);
      
      _xyHouseSizeLine = calcDraw.lineTrigo(0, calcDraw.getRadiusCircleHouseCIRCLE2WithoutLine(), calcDraw.getRadiusCircle(0));
      whHouseSize = calcDraw.sizeHouse(_xyHouseSizeLine[0], _xyHouseSizeLine[1]); 
      whHouseSize = (whHouseSize * 70) / 100;
      _house = _calcHouse.calcDrawHouse(calcDraw, whHouseSize);
      
      _xyAngleSizeLine = calcDraw.lineTrigo(0, calcDraw.getRadiusCirclePlanetCIRCLE4INVISIBLEWithoutLine(), calcDraw.getRadiusCircle(0));
      whAngleSymbolSize = calcDraw.sizePlanet(_xyAngleSizeLine[0], _xyAngleSizeLine[1]);
      whAngleSymbolSize = (whAngleSymbolSize * 150) / 100;
      _xyAngleDegSizeLine = calcDraw.lineTrigo(0, calcDraw.getRadiusCirclePlanetCIRCLE5INVISIBLEWithoutLine(), calcDraw.getRadiusCircle(0));
      whAngleDegSymbolSize = calcDraw.sizeAngle(_xyAngleDegSizeLine[0], _xyAngleDegSizeLine[1]);
      whAngleDegSymbolSize = (whAngleDegSymbolSize * 110) / 100;
      _xyAngleMinSizeLine = calcDraw.lineTrigo(0, calcDraw.getRadiusCirclePlanetCIRCLE6INVISIBLEWithoutLine(), calcDraw.getRadiusCircle(0));
      whAngleMinSymbolSize = calcDraw.sizeAngle(_xyAngleMinSizeLine[0], _xyAngleMinSizeLine[1]);
      whAngleMinSymbolSize = (whAngleMinSymbolSize * 80) / 100;
      _angle = _calcAngle.calcDrawAngle(calcDraw, whAngleSymbolSize, whAngleDegSymbolSize, whAngleMinSymbolSize); // todo angle size for outside circle

      _xyPlanetSizeLine = calcDraw.lineTrigo(0, calcDraw.getRadiusCirclePlanetCIRCLE4INVISIBLEWithoutLine(), calcDraw.getRadiusCircle(0));
      whPlanetSymbolSize = calcDraw.sizePlanet(_xyPlanetSizeLine[0], _xyPlanetSizeLine[1]);
      whPlanetSymbolSize = (whPlanetSymbolSize * 150) / 100;
      _xyPlanetDegSizeLine = calcDraw.lineTrigo(0, calcDraw.getRadiusCirclePlanetCIRCLE5INVISIBLEWithoutLine(), calcDraw.getRadiusCircle(0));
      whPlanetDegSymbolSize = calcDraw.sizePlanet(_xyPlanetDegSizeLine[0], _xyPlanetDegSizeLine[1]);
      whPlanetDegSymbolSize = (whPlanetDegSymbolSize * 110) / 100;
      _xyPlanetMinSizeLine = calcDraw.lineTrigo(0, calcDraw.getRadiusCirclePlanetCIRCLE6INVISIBLEWithoutLine(), calcDraw.getRadiusCircle(0));
      whPlanetMinSymbolSize = calcDraw.sizeAngle(_xyPlanetMinSizeLine[0], _xyPlanetMinSizeLine[1]);
      whPlanetMinSymbolSize = (whPlanetMinSymbolSize * 80) / 100;
      _planet = _calcPlanet.calcDrawPlanet(calcDraw, whPlanetSymbolSize, whPlanetDegSymbolSize, whPlanetMinSymbolSize);
    }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    if (_swLoaded) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(APPBARHEIGHT),
          child: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(widget.title),
          )
        ),
        //body: Center(
          body: Stack(
            children: <Widget>[
              if (!_swFullScreen)
                new Positioned(
                  child: Align(
                    alignment: AlignmentDirectional.topCenter,
                      child: new CustomPaint(
                        size: Size(calcDraw.getSizeWH(), calcDraw.getSizeWH()), // 375, 736 max iphone6s
                        painter: new DrawAstro(_zodiac, _house, _angle, _planet),
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
              if (!_swFullScreen)
              for (var z in _zodiac)
                new Positioned( //.fill not identic
                  left: z.xyZodiac.dx,
                  top: z.xyZodiac.dy,
                  child: new GestureDetector(
                    onTap: () {
                      _zodiacClick(z.idByAsc);
                      print("onTap called. " + z.sign);
                    },
                    child: new Container(
                      width: whZodiacSize,
                      height: whZodiacSize,
                      margin: const EdgeInsets.only(left: 0.0, right: 0.0),
                      padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                      child: SvgPicture.asset(z.svg,
                        width: whZodiacSize,
                        height: whZodiacSize,
                        fit: BoxFit.scaleDown,
                        allowDrawingOutsideViewBox: true,
                        alignment: Alignment.center,
                        color: z.element.color, 
                        semanticsLabel: z.sign
                      ),
                    )
                  ),
                ),
              if (!_swFullScreen)
              for (var z in _house)
                new Positioned(
                  left: z.xyHouse.dx,
                  top: z.xyHouse.dy,
                  child: new GestureDetector(
                    onTap: () {
                      testCallPython(); // for test
                      print("onTap called. House " + z.id.toString());
                    },
                    child: new Container(
                      width: whHouseSize,
                      height: whHouseSize,
                      margin: const EdgeInsets.only(left: 0.0, right: 0.0),
                      padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                      //child: Text(z.id.toString(),
                      child: SvgPicture.asset(z.svg,
                        width: whHouseSize,
                        height: whHouseSize,
                        fit: BoxFit.scaleDown,
                        allowDrawingOutsideViewBox: true,
                        alignment: Alignment.center, 
                        semanticsLabel: z.sign
                      ),
                    ),
                  ),
                ),  
              if (!_swFullScreen)
              for (var z in _angle)
                if (z.svg != '')
                  new Positioned(
                    left: z.xyAngle.dx,
                    top: z.xyAngle.dy,
                    child: new GestureDetector(
                      onTap: () {
                        print("onTap called. House " + z.id.toString());
                      },
                      child: new Container(
                        width: whAngleSymbolSize,
                        height: whAngleSymbolSize,
                        margin: const EdgeInsets.only(left: 0.0, right: 0.0),
                        padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                        //child: Text(z.id.toString(),
                        child: SvgPicture.asset(z.svg,
                          width: whAngleSymbolSize,
                          height: whAngleSymbolSize,
                          fit: BoxFit.scaleDown,
                          allowDrawingOutsideViewBox: true,
                          alignment: Alignment.center, 
                          color: z.color, 
                          semanticsLabel: z.sign
                        ),
                      ),
                    ),
                  ),  
              if (!_swFullScreen)  
              for (var z in _angle)
                if (z.svg != '')
                  new Positioned( //.fill not identic
                    left: z.xyDeg.dx,
                    top: z.xyDeg.dy,
                    child: new GestureDetector(
                      onTap: () {
                        print("onTap called. " + z.id + " " + z.signPos);
                      },
                      child: new Container(
                        width: whAngleDegSymbolSize,
                        height: whAngleDegSymbolSize,
                        margin: const EdgeInsets.only(left: 0.0, right: 0.0),
                        padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                        child: SvgPicture.asset(z.svgDegre,
                          width: whAngleDegSymbolSize,
                          height: whAngleDegSymbolSize,
                          fit: BoxFit.scaleDown,
                          allowDrawingOutsideViewBox: true,
                          alignment: Alignment.center,
                          color: z.color, 
                          semanticsLabel: z.sign
                        ),
                      )
                    ),
                  ),
              if (!_swFullScreen)
              for (var z in _angle)
                if (z.svg != '')
                  new Positioned( //.fill not identic
                    left: z.xyMin.dx,
                    top: z.xyMin.dy,
                    child: new GestureDetector(
                      onTap: () {
                        print("onTap called. " + z.id + " " + z.signPos);
                      },
                      child: new Container(
                        width: whAngleMinSymbolSize,
                        height: whAngleMinSymbolSize,
                        margin: const EdgeInsets.only(left: 0.0, right: 0.0),
                        padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                        child: SvgPicture.asset(z.svgMin,
                          width: whAngleMinSymbolSize,
                          height: whAngleMinSymbolSize,
                          fit: BoxFit.scaleDown,
                          allowDrawingOutsideViewBox: true,
                          alignment: Alignment.center,
                          color: z.color, 
                          semanticsLabel: z.sign
                        ),
                      )
                    ),
                  ),
              if (!_swFullScreen)
              for (var z in _planet)
                new Positioned( //.fill not identic
                  left: z.xyPlanet.dx,
                  top: z.xyPlanet.dy,
                  child: new GestureDetector(
                    onTap: () {
                      print("onTap called. " + z.id + " " + z.signPos);
                    },
                    child: new Container(
                      width: whPlanetSymbolSize,
                      height: whPlanetSymbolSize,
                      margin: const EdgeInsets.only(left: 0.0, right: 0.0),
                      padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                      child: SvgPicture.asset(z.svg,
                        width: whPlanetSymbolSize,
                        height: whPlanetSymbolSize,
                        fit: BoxFit.scaleDown,
                        allowDrawingOutsideViewBox: true,
                        alignment: Alignment.center,
                        color: z.color, 
                        semanticsLabel: z.sign
                      ),
                    )
                  ),
                ),
              if (!_swFullScreen)
              for (var z in _planet)
                new Positioned( //.fill not identic
                  left: z.xyDeg.dx,
                  top: z.xyDeg.dy,
                  child: new GestureDetector(
                    onTap: () {
                      print("onTap called. " + z.id + " " + z.signPos);
                    },
                    child: new Container(
                      width: whPlanetDegSymbolSize,
                      height: whPlanetDegSymbolSize,
                      margin: const EdgeInsets.only(left: 0.0, right: 0.0),
                      padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                      child: SvgPicture.asset(z.svgDegre,
                        width: whPlanetDegSymbolSize,
                        height: whPlanetDegSymbolSize,
                        fit: BoxFit.scaleDown,
                        allowDrawingOutsideViewBox: true,
                        alignment: Alignment.center,
                        color: z.color, 
                        semanticsLabel: z.sign
                      ),
                    )
                  ),
                ),
              if (!_swFullScreen)
              for (var z in _planet)
                new Positioned( //.fill not identic
                  left: z.xyMin.dx,
                  top: z.xyMin.dy,
                  child: new GestureDetector(
                    onTap: () {
                      print("onTap called. " + z.id + " " + z.signPos);
                    },
                    child: new Container(
                      width: whPlanetMinSymbolSize,
                      height: whPlanetMinSymbolSize,
                      margin: const EdgeInsets.only(left: 0.0, right: 0.0),
                      padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                      child: SvgPicture.asset(z.svgMin,
                        width: whPlanetMinSymbolSize,
                        height: whPlanetMinSymbolSize,
                        fit: BoxFit.scaleDown,
                        allowDrawingOutsideViewBox: true,
                        alignment: Alignment.center,
                        color: z.color, 
                        semanticsLabel: z.sign
                      ),
                    )
                  ),
                ),
              // Background
              new Positioned(
                top: calcDraw.getSizeWH(),
                width: calcDraw.getSizeWH(),
                child: Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: new Container(
                    height: calcDraw.getSizeHWithFloatingButtonBottom(),
                    width: calcDraw.getSizeWH(),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          HexColor('#fafafa'),
                          Colors.blue[50],
                          Colors.blue[200],
                          Colors.blue[300],
                        ],
                      )
                    ),
                  ),
                )
              ),
              // Text scroll zone frameif
              if (_swZodiacText) 
                new Positioned(
                  top: _swFullScreen ? 0.0 : calcDraw.getSizeWH(),
                  width: calcDraw.getSizeWH(),
                  child: Align(
                    alignment: AlignmentDirectional.bottomCenter,
                    child: new Container(
                      margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                      height: _swFullScreen ? (calcDraw.getSizeHMinusFloatingButtonBottom() + calcDraw.getSizeWH()) : calcDraw.getSizeHMinusFloatingButtonBottom(),
                      width: calcDraw.getSizeWH(),
                      child: new SingleChildScrollView(
                        child: IntrinsicHeight(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                            /*Container( // Expanded -> Container for divide by list
                              color: Colors.red,
                              child: new Text('test'),
                            ),*/
                            SizedBox(
                              height: 20.0,
                            ),
                            for (Content z in _zodiacTextSelect.content)
                              if (z.typeContent == TypeContent.TypeTitle)
                                SizedBox(
                                  height: z.contentTitle.fontSize + 20.0,
                                  child: Container(
                                    child: new Text(z.contentTitle.text,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: z.contentTitle.fontSize)
                                    )
                                  ),
                                )
                              else if (z.typeContent == TypeContent.TypeText)
                                Container(
                                  child: new Text(z.contentText.text,
                                  textAlign: TextAlign.justify
                                  )
                                )
                              else if (z.typeContent == TypeContent.TypeSvg)
                                Container(
                                  /*
                                  width: (calcDraw.getSizeWH() * 35) / 100,
                                  height: (calcDraw.getSizeWH() * 35) / 100,
                                  margin: const EdgeInsets.only(left: 0.0, right: 0.0),
                                  padding: const EdgeInsets.only(left: 0.0, right: 0.0),*/
                                  child: SvgPicture.asset(z.contentSvg.asset,
                                    width: (calcDraw.getSizeWH() * 30) / 100,
                                    height: (calcDraw.getSizeWH() * 30) / 100,
                                    fit: BoxFit.scaleDown,
                                    allowDrawingOutsideViewBox: true,
                                    alignment: Alignment.center,
                                    //color: z.color, 
                                    //semanticsLabel: z.contentSvg.label
                                  ),
                                )
                              else if (z.typeContent == TypeContent.TypePng)
                                Container(
                                  child: Image.asset(
                                    z.contentPng.asset,
                                    fit: BoxFit.contain,
                                    width: (calcDraw.getSizeWH() * 35) / 100,
                                    height: (calcDraw.getSizeWH() * 35) / 100,
                                  )
                                )
                              ]),
                          /*
                            SizedBox(
                              height: 25.0,
                              child: Container(
                                child: new Text(_zodiacTextSelect.pictogramme.titre,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18.0)
                                )
                              ),
                            ),
                            Container(
                              child: new Text(_zodiacTextSelect.pictogramme.contenu,
                              textAlign: TextAlign.justify
                              )
                            ),
*/


/*
  Container(
   width:100,
   height: 100,
   decoration: BoxDecoration(
     image: ImageDecoration: NetworkImage("youImageLink")
   )
   */





 
                        ),
                        //color: Colors.grey,/*
                        /*child: new Text('test $_counter',
                          style: new TextStyle(color: Colors.red)
                        ),*/
                        /*
                        child: Stack(
                          children: <Widget>[
                            new Container(
                              child: new Text('test'),
                            ),
                            new Container(
                              child: new Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc ac justo pharetra dolor consequat sodales eu malesuada lacus. Praesent placerat ex ut ipsum lacinia finibus. Nunc sed mi nec magna dapibus semper. Sed quis nibh ac ex consequat scelerisque quis eu est. Sed sollicitudin laoreet dictum. Etiam pharetra volutpat sem et feugiat. Integer leo ex, condimentum sed sapien mattis, blandit bibendum dui. Phasellus et enim facilisis, rutrum arcu ut, mattis quam. Vivamus et tincidunt neque.\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc ac justo pharetra dolor consequat sodales eu malesuada lacus. Praesent placerat ex ut ipsum lacinia finibus. Nunc sed mi nec magna dapibus semper. Sed quis nibh ac ex consequat scelerisque quis eu est. Sed sollicitudin laoreet dictum. Etiam pharetra volutpat sem et feugiat. Integer leo ex, condimentum sed sapien mattis, blandit bibendum dui. Phasellus et enim facilisis, rutrum arcu ut, mattis quam. Vivamus et tincidunt neque.'),
                            )
                          ]
                        ),*/
                        //child: new Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc ac justo pharetra dolor consequat sodales eu malesuada lacus. Praesent placerat ex ut ipsum lacinia finibus. Nunc sed mi nec magna dapibus semper. Sed quis nibh ac ex consequat scelerisque quis eu est. Sed sollicitudin laoreet dictum. Etiam pharetra volutpat sem et feugiat. Integer leo ex, condimentum sed sapien mattis, blandit bibendum dui. Phasellus et enim facilisis, rutrum arcu ut, mattis quam. Vivamus et tincidunt neque.\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc ac justo pharetra dolor consequat sodales eu malesuada lacus. Praesent placerat ex ut ipsum lacinia finibus. Nunc sed mi nec magna dapibus semper. Sed quis nibh ac ex consequat scelerisque quis eu est. Sed sollicitudin laoreet dictum. Etiam pharetra volutpat sem et feugiat. Integer leo ex, condimentum sed sapien mattis, blandit bibendum dui. Phasellus et enim facilisis, rutrum arcu ut, mattis quam. Vivamus et tincidunt neque.'),
                      ),
                    ),
                  )
                )
            ],
          ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: Icon(_swFullScreen ? Icons.zoom_out : Icons.zoom_in),
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
