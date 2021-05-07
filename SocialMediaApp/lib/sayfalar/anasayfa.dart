import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/sayfalar/akis.dart';
import 'package:socialapp/sayfalar/ara.dart';
import 'package:socialapp/sayfalar/duyurular.dart';
import 'package:socialapp/sayfalar/pages/home_page.dart';
import 'package:socialapp/sayfalar/profil.dart';
import 'package:socialapp/sayfalar/renk.dart';
import 'package:socialapp/sayfalar/yukle.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';

class AnaSayfa extends StatefulWidget {
  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int _aktifSayfaNo = 0;
  PageController sayfaKumandasi;

  @override
  void initState() { 
    super.initState();
    sayfaKumandasi = PageController();
  }

  @override
  void dispose() { 
    sayfaKumandasi.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    String aktifKullaniciId = Provider.of<YetkilendirmeServisi>(context, listen: false).aktifKullaniciId;
    
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (acilanSayfaNo){
          setState(() {
            _aktifSayfaNo = acilanSayfaNo;
          });
        },
        controller: sayfaKumandasi,
        children: <Widget>[
          Akis(),
          Ara(),
          Yukle(),
          Duyurular(),
          Profil(profilSahibiId: aktifKullaniciId,),
          Home()
        ],
      ),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
              canvasColor: KprimaryColor,
            ), // sets the inactive color of the `Botto
              child: BottomNavigationBar(
                elevation: 0,
          currentIndex: _aktifSayfaNo,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Akış"),
            BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Keşfet"),
            BottomNavigationBarItem(icon: Icon(Icons.file_upload), label: "Yükle"),
            BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Duyurular"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
            
          ],
          onTap: (secilenSayfaNo){
            setState(() {
              sayfaKumandasi.jumpToPage(secilenSayfaNo);
            });
          },
          ),
      ),
    );
  }
}