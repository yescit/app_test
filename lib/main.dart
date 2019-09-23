import 'dart:async';
import 'dart:convert';
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
        home: SRA()
    );
  }
}
final color = const Color(0xff3363ac);
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
    return SafeArea(
          child:  new WebviewScaffold(
              url: "https://esep.app/home/home-1/",
              ),
        );
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
        ));
  }
}