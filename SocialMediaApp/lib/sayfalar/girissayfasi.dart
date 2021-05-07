import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/sayfalar/hesapolustur.dart';
import 'package:socialapp/sayfalar/orDivider.dart';
import 'package:socialapp/sayfalar/renk.dart';
import 'package:socialapp/sayfalar/sifremiunuttum.dart';
import 'package:socialapp/servisler/firestoreservisi.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';

class GirisSayfasi extends StatefulWidget {
  @override
  _GirisSayfasiState createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  final _formAnahtari = GlobalKey<FormState>();
  final _scaffoldAnahtari = GlobalKey<ScaffoldState>();
  bool yukleniyor = false;
  String email, sifre;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldAnahtari,
        body: Container(
          width: double.infinity,
          height: size.height,
          decoration: BoxDecoration(
            color: KprimaryColor,
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: -20,
                right: -20,
                child: Image.asset(
                  'assets/images/pati.png',
                  width: size.width * 0.4,
                  color: Colors.deepPurple,
                ),
              ),
              Positioned(
                top: -30,
                left: 0,
                child: Image.asset(
                  'assets/images/yuvarlak.png',
                  width: size.width * 0.4,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              _sayfaElemanlari(),
              _yuklemeAnimasyonu(),
            ],
          ),
        ));
  }

  Widget _yuklemeAnimasyonu() {
    if (yukleniyor) {
      return Center(child: CircularProgressIndicator());
    } else {
      return SizedBox(
        height: 0.0,
      );
    }
  }

  Widget _sayfaElemanlari() {
    return Form(
      key: _formAnahtari,
      child: ListView(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 60.0),
        children: <Widget>[
          Image.asset(
            'assets/images/sahipson.png',
            width: double.infinity,
            height: 250,
          ),
          SizedBox(
            height: 40.0,
          ),
          TextFormField(
            cursorColor: Colors.black,
            autocorrect: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              fillColor: Colors.white.withOpacity(0.5),
              filled: true,
              hintText: "Email adresinizi girin",
              errorStyle: TextStyle(fontSize: 12.0, color: Colors.black),
              prefixIcon: Icon(
                Icons.mail,
                color: Colors.black,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            validator: (girilenDeger) {
              if (girilenDeger.isEmpty) {
                return "Email alanı boş bırakılamaz!";
              } else if (!girilenDeger.contains("@")) {
                return "Girilen değer mail formatında olmalı!";
              }
              return null;
            },
            onSaved: (girilenDeger) => email = girilenDeger,
          ),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            cursorColor: Colors.black,
            obscureText: true,
            decoration: InputDecoration(
              fillColor: Colors.white.withOpacity(0.5),
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(50),
              ),
              hintText: "Şifrenizi girin",
              errorStyle: TextStyle(fontSize: 12.0, color: Colors.black),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black,
              ),
            ),
            validator: (girilenDeger) {
              if (girilenDeger.isEmpty) {
                return "Şifre alanı boş bırakılamaz!";
              } else if (girilenDeger.trim().length < 4) {
                return "Şifre 4 karakterden az olamaz!";
              }
              return null;
            },
            onSaved: (girilenDeger) => sifre = girilenDeger,
          ),
          SizedBox(
            height: 25.0,
          ),
          Row(
            children: <Widget>[
              // Expanded(
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       shape: new RoundedRectangleBorder(
              //         borderRadius: new BorderRadius.circular(50),
              //       ),
              //       onPrimary: Colors.white,
              //       shadowColor: Colors.blueAccent,
              //       elevation: 5,
              //     ),
              //     onPressed: () {
              //       Navigator.of(context).push(MaterialPageRoute(
              //           builder: (context) => HesapOlustur()));
              //     },
              //     child: Text(
              //       "Hesap Oluştur",
              //       textAlign: TextAlign.center,
              //       style: TextStyle(
              //         fontSize: 18,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),

              //     //color: Theme.of(context).primaryColor,
              //     //textColor: Colors.white,
              //   ),
              // ),

              Expanded(
                child: ElevatedButton(
                  onPressed: _girisYap,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50),
                    ),
                    onPrimary: Colors.white,
                    shadowColor: Colors.greenAccent,
                    elevation: 5,
                  ),
                  child: Text(
                    "Giriş Yap",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              )
            ],
          ),

          SizedBox(
            height: 60.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Hesabınız Yok Mu?",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HesapOlustur()));
                },
                child: Text(
                  "Hesap Oluştur",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(3.2, 3.2),
                        blurRadius: 7.0,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),

          OrDivider(),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _googleIleGiris,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    "assets/images/facebook.svg",
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: _googleIleGiris,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    "assets/images/google.svg",
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
            ],
          ),
          // Center(
          //     child: Text(
          //   "veya",
          //   style: TextStyle(
          //     color: Colors.white,
          //   ),
          // )),
          SizedBox(
            height: 10.0,
          ),

          // Center(
          //   child: InkWell(
          //   onTap: _googleIleGiris,
          //   child: Text(
          //     "Google İle Giriş Yap",
          //     style: TextStyle(
          //       fontSize: 19.0,
          //       fontWeight: FontWeight.bold,
          //       color: Colors.white,
          //     ),
          //   ),
          // )),
          SizedBox(
            height: 10.0,
          ),
          Center(
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SifremiUnuttum()));
                  },
                  child: Text(
                    "Şifremi Unuttum",
                    style: TextStyle(
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(3.2, 3.2),
                          blurRadius: 7.0,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ))),
        ],
      ),
    );
  }

  void _girisYap() async {
    final _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);

    if (_formAnahtari.currentState.validate()) {
      _formAnahtari.currentState.save();

      setState(() {
        yukleniyor = true;
      });

      try {
        await _yetkilendirmeServisi.mailIleGiris(email, sifre);
      } catch (hata) {
        setState(() {
          yukleniyor = false;
        });

        uyariGoster(hataKodu: hata.code);
      }
    }
  }

  void _googleIleGiris() async {
    var _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);

    setState(() {
      yukleniyor = true;
    });

    try {
      Kullanici kullanici = await _yetkilendirmeServisi.googleIleGiris();
      if (kullanici != null) {
        Kullanici firestoreKullanici =
            await FireStoreServisi().kullaniciGetir(kullanici.id);
        if (firestoreKullanici == null) {
          FireStoreServisi().kullaniciOlustur(
              id: kullanici.id,
              email: kullanici.email,
              kullaniciAdi: kullanici.kullaniciAdi,
              fotoUrl: kullanici.fotoUrl);
        }
      }
    } catch (hata) {
      setState(() {
        yukleniyor = false;
      });

      uyariGoster(hataKodu: hata.code);
    }
  }

  uyariGoster({hataKodu}) {
    String hataMesaji;

    if (hataKodu == "user-not-found") {
      hataMesaji = "Böyle bir kullanıcı bulunmuyor";
    } else if (hataKodu == "invalid-email") {
      hataMesaji = "Girdiğiniz mail adresi geçersizdir";
    } else if (hataKodu == "wrong-password") {
      hataMesaji = "Girilen şifre hatalı";
    } else if (hataKodu == "user-disabled") {
      hataMesaji = "Kullanıcı engellenmiş";
    } else {
      hataMesaji = "Tanımlanamayan bir hata oluştu $hataKodu";
    }

    final snackBar = SnackBar(content: Text(hataMesaji));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
