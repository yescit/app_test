import 'package:esep/WaveClippers.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  InfoPageState createState() => InfoPageState();
}

class InfoPageState extends State<InfoPage> {
  Widget _buildTopWavyPart() {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: WaveClipper2(),
          child: Container(
            child: Column(),
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Theme.of(context).primaryColorDark.withOpacity(0.3), Theme.of(context).primaryColorLight.withOpacity(0.3)])),
          ),
        ),
        ClipPath(
          clipper: WaveClipper3(),
          child: Container(
            child: Column(),
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Theme.of(context).primaryColorDark.withOpacity(0.6), Theme.of(context).primaryColorLight.withOpacity(0.6)])),
          ),
        ),
        ClipPath(
          clipper: WaveClipper1(),
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Container(
                    child: Image.asset('assets/ss_loading.png', width: MediaQuery.of(context).size.width / 3, height: MediaQuery.of(context).size.width / 2,),
                    height: 120
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Theme.of(context).primaryColorDark, Theme.of(context).primaryColorLight])),
          ),
        ),
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: BackButton(color: Colors.white,),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          _buildTopWavyPart(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
            child: Text("ESEP.APP è la Web App dell’Ente Scuola Edile Province Nord Sardegna che ha come obiettivo promuovere i progetti dell’ente e incentivare lo scambio tra imprese e corsisti", style: TextStyle(fontSize: 16))
          )
        ],
      )
    );
  }
}