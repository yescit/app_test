import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  ContactPageState createState() => ContactPageState();
}

class ContactPageState extends State<ContactPage> {

  void _openDirections() async {
    String url = 'https://www.google.it/maps/dir/MY+Location/Z. I. Predda Niedda strada 34, 07100 Sassari';
    String appleUrl = 'http://maps.apple.com/?ll=Z. I. Predda Niedda strada 34, 07100 Sassari';

    if(Platform.isIOS) {
      if(await canLaunch(appleUrl)) {
        await launch(appleUrl);
      } else {
        print("Impossibile aprire la mappa con le direzioni stradali iOS");
      }
    }

    if(Platform.isAndroid) {
      if(await canLaunch(url)) {
        await launch(url);
      } else {
        print("Impossibile aprire la mappa con le direzioni stradali Android");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        centerTitle: true,
        title: Text("Contatti")
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 0, bottom: 0, left: 15, right: 15),
        child: ListView(
          children: <Widget>[
            _buildListTile(Icons.mail, "segreteria@esepnordsardegna.it", () => launch("mailto:segreteria@esepnordsardegna.it"), Color(0xFFfbad50), Color(0xFFfbad50)),
            _buildListTile(Icons.mail, "esepnordsardegna@pec.it", () => launch("mailto:esepnordsardegna@pec.it"), Color(0xFFfbad50), Color(0xFFfbad50)),
            _buildListTile(Icons.phone, "+39 079 261043", () => launch("tel:+39079261043"), Color(0xFF38A1F3), Color(0xFF38A1F3)),
            _buildListTile(Icons.map, "Z. I. Predda Niedda strada 34, 07100 Sassari", () => _openDirections(), Color(0xFF38A1F3), Color(0xFF38A1F3)),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 25),
              child: Text("CCIAA SS n° 136141\nC.F. 92013630907\nP.IVA 01693320903", style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600))
            )
          ],
        )
      )

    );
  }

  Widget _buildListTile(IconData icon, String title, Function onTap, Color splashColor, Color highlightColor) {
    return InkWell(
        onTap: () => onTap(),
        splashColor: splashColor,
        highlightColor: highlightColor,
        child: ListTile(
          leading: Icon(icon, size: 24, color: Colors.black87),
          title: Text(title, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
        )
    );
  }
}