import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/modeller/gonderi.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/sayfalar/pages/home_page.dart';
import 'package:socialapp/sayfalar/renk.dart';
import 'package:socialapp/servisler/firestoreservisi.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';
import 'package:socialapp/widgetlar/gonderikarti.dart';
import 'package:socialapp/widgetlar/silinmeyenFutureBuilder.dart';

class Akis extends StatefulWidget {
  @override
  _AkisState createState() => _AkisState();
}

class _AkisState extends State<Akis> {

  final _refreshIndicatorKey = GlobalKey<ScaffoldState>();

  List<Gonderi> _gonderiler = [];

  Future<void> _akisGonderileriniGetir() async {
    String aktifKullaniciId =
        Provider.of<YetkilendirmeServisi>(context, listen: false)
            .aktifKullaniciId;

    List<Gonderi> gonderiler =
        await FireStoreServisi().akisGonderileriniGetir(aktifKullaniciId);
    if (mounted) {
      setState(() {
        _gonderiler = gonderiler;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _akisGonderileriniGetir();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: KprimaryColor,
      appBar: AppBar(
        title: Text("SahipBul"),
        backgroundColor: KprimaryColor,
        elevation: 0,
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: KprimaryColor,
                elevation: 0,
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Home()));
              },
              child: Icon(Icons.games))
        ],
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          clipBehavior: Clip.none,
          width: size.width * 0.97,
          height: size.height * 0.828,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(35),
          ),
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _akisGonderileriniGetir,
                      child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _gonderiler.length,
                      itemBuilder: (context, index) {
                        Gonderi gonderi = _gonderiler[index];

                        return SilinmeyenFutureBuilder(
                            future: FireStoreServisi()
                                .kullaniciGetir(gonderi.yayinlayanId),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return SizedBox();
                              }
                              Kullanici gonderiSahibi = snapshot.data;
                              return GonderiKarti(
                                gonderi: gonderi,
                                yayinlayan: gonderiSahibi,
                              );
                            });
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
