import 'package:crypto_list/constant/constants.dart';
import 'package:dio/dio.dart';
import 'package:crypto_list/model/crypto.dart';
import 'package:flutter/material.dart';
import 'crypto_list_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadScreen extends StatefulWidget {
  const LoadScreen({Key? key}) : super(key: key);

  @override
  State<LoadScreen> createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Image(
              image: AssetImage('assets/images/logo.png'),
            ),
            SpinKitWave(
              size: 30.0,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    if (response.statusCode == 200) {
      List<Crypto> cryptoList = response.data['data']
          .map<Crypto>((e) => Crypto.fromMapJson(e))
          .toList();

      if (!mounted) return;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CryptoListScreen(
                    cryptoList: cryptoList,
                  )));
    } else if (response.statusCode == 404) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("404 Try it later")));
    }
  }
}
