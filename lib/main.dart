import 'dart:async';
import 'dart:convert';
import 'package:esep/contact.dart';
import 'package:esep/info.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:connectivity/connectivity.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: true,
        //color: Colors.amber[600],
//        home: SRA()
        home: NewHomePage()
    );
  }
}
final color = const Color(0xff3363ac);


class NewHomePage extends StatelessWidget {
  double _lateralPadding = 15;
  double _baseSpaceBetweenCards = 15;
  double _spaceBetweenCards = 15;
  double _svgSideSize = 35;

  Size calculateCardSize(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    //todo: capire cosa sono i -10
    double availableWidth = mq.width - (_lateralPadding * 2) - _spaceBetweenCards - 10;
    double iconSize = availableWidth / 2;
    return Size(iconSize, iconSize);
  }

  @override
  Widget build(BuildContext context) {
    Size cardSize = calculateCardSize(context);

    return Scaffold(
      body: ListView(
        children: <Widget>[
          Image.asset('assets/ss_loading.png', width: MediaQuery.of(context).size.width / 3, height: MediaQuery.of(context).size.width / 2,),
          SizedBox(height: 25),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: _lateralPadding, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Card(
                  elevation: 8.0,
                  child: InkWell(
                    splashColor: Color.fromARGB(255, 159, 174, 229),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => InfoPage())),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      width: cardSize.width,
                      height: cardSize.height,
                        child: Center(
                            child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Icon(Icons.info_outline, size: 48),
                                    Text("Info", style: TextStyle(fontSize: 11), textAlign: TextAlign.center)
                                  ],
                                )
                            )
                        )
                    )
                  )
                ),
                Card(
                    elevation: 8.0,
                    child: InkWell(
                        splashColor: Color.fromARGB(255, 159, 174, 229),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SRA())),
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            width: cardSize.width,
                            height: cardSize.height,
                            child: Center(
                                child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Icon(Icons.play_arrow, size: 48),
                                        Text("Accedi", style: TextStyle(fontSize: 11), textAlign: TextAlign.center)
                                      ],
                                    )
                                )
                            )
                        )
                    )
                ),
              ],
            )
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: _lateralPadding, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Card(
                      elevation: 8.0,
                      child: InkWell(
                          splashColor: Color.fromARGB(255, 159, 174, 229),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ContactPage())),
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              width: cardSize.width,
                              height: cardSize.height,
                              child: Center(
                                  child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Icon(Icons.contacts, size: 48),
                                          Text("Contatti", style: TextStyle(fontSize: 11), textAlign: TextAlign.center)
                                        ],
                                      )
                                  )
                              )
                          )
                      )
                  ),
                ],
              )
          )
        ],
      )
    );
  }
}













class SRA extends StatefulWidget {
  @override
  _SRAState createState() => _SRAState();
}

class _SRAState extends State<SRA> {
   String tokenSaver;
   FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
   
   @override
   void initState(){
     firebaseMessaging.configure(
       onLaunch: (Map<String, dynamic> msg){
         print("onLaunch called");
       },
       onResume: (Map<String, dynamic> msg){
         print("onResume called");
       },
       onMessage: (Map<String, dynamic> msg){
         print("onMessage called");
       },
     );
     firebaseMessaging.requestNotificationPermissions(
       const IosNotificationSettings(
         sound: true,
         alert: true,
         badge: true
       )
     );
     firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings setting){
       print("IOS Setting Registered");
     });
     firebaseMessaging.getToken().then((token){
       update(token);
     });
     super.initState();
   }
   update(String token){
       tokenSaver = token;
       print(token);
       setState(() {
        
       });
  }
  
  @override
  Widget build(BuildContext context) {
     return Center(
       child: SplashScreen(
         seconds: 5,
         navigateAfterSeconds: HomePage(),
         image: Image.asset('assets/ss_caption.png'),
         backgroundColor: color,
         styleTextUnderTheLoader: TextStyle(),
         photoSize: 120.0,
         loaderColor: Colors.amber[600],
       ),
     );
  }

}
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _connectionStatus = 'Unknown';
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectionStatus = result.toString();
      print(_connectionStatus);
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future getData() async {
    http.Response response =
        await http.get("https://jsonplaceholder.typicode.com/posts/");
    var result = jsonDecode(response.body);
    return result;
  }
 Widget _webLauncher() {
    return WebviewScaffold(
            url: "https://esep.app/",
          );
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          centerTitle: true,
          title: Text("Esep App")
        ),
        body: new FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
                return _webLauncher();
            } else {
              return Center(
                child: Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.fromLTRB(0, 120, 0, 0),),
                    Image.asset('assets/ss_loading.png', scale: 4.5,),
                    Padding(padding: EdgeInsets.fromLTRB(0, 00, 0, 30),),
                    HeartbeatProgressIndicator(
                      child: Icon(Icons.wifi, color: color,size: 35.0,),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            title: Text('Info'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            title: Text('Contatti'),
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.amber[800],
        onTap: (int index) {
          if(index == 0) return null;
          if(index == 1) {
            return Navigator.pushReplacement(context, MaterialPageRoute(maintainState: false, builder: (context) => InfoPage()));
          }
          if(index == 2) {
            return Navigator.pushReplacement(context, MaterialPageRoute(maintainState: false, builder: (context) => ContactPage()));
          }
        },
      ),
    );
  }
}
