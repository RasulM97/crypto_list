import 'dart:io';
import 'package:crypto_list/constant/constants.dart';
import 'package:crypto_list/model/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CryptoListScreen extends StatefulWidget {
  const CryptoListScreen({Key? key, required this.cryptoList})
      : super(key: key);
  final List<Crypto>? cryptoList;

  @override
  State<CryptoListScreen> createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  List<Crypto>? listOfCrypto;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    listOfCrypto = widget.cryptoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (Platform.isWindows || Platform.isLinux || Platform.isLinux)
            IconButton(
              onPressed: () {
                _refreshIndicatorKey.currentState?.show();
              },
              icon: const Icon(
                Icons.refresh_rounded,
                color: Colors.white,
              ),
            ),
        ],
        backgroundColor: blackColor,
        title: const Text(
          'کریپتو بازار',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'moraba',
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: blackColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                onChanged: (value) {
                  _filterList(value);
                },
                decoration: InputDecoration(
                    hintText: 'اسم رمزارز معتبر را سرچ کنید',
                    hintStyle: const TextStyle(
                        fontFamily: 'moraba', color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none),
                    ),
                    filled: true,
                    fillColor: greenColor),
              ),
            ),
          ),
          Visibility(
            visible: isSearching,
            child: const Text(
              'در حال آپدیت لیست رمز ارز ها...',
              textDirection: TextDirection.rtl,
              style: TextStyle(color: greenColor, fontFamily: 'moraba'),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              color: blackColor,
              backgroundColor: greenColor,
              onRefresh: () async {
                List<Crypto> freshData = await _refresh();
                setState(() {
                  listOfCrypto = freshData;
                });
              },
              child: ListView.builder(
                  itemCount: listOfCrypto!.length,
                  itemBuilder: (context, index) {
                    return _listTileItems(listOfCrypto![index]);
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Crypto>> _refresh() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    return listOfCrypto = response.data['data']
        .map<Crypto>((e) => Crypto.fromMapJson(e))
        .toList();
  }

  Widget _listTileItems(Crypto crypto) {
    return ListTile(
      trailing: SizedBox(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  crypto.priceUsd!.toStringAsFixed(2),
                  style: const TextStyle(color: greyColor, fontSize: 18),
                ),
                Text(
                  crypto.changePercent24Hr!.toStringAsFixed(2),
                  style: TextStyle(
                    color: _colorChangeText(crypto.changePercent24Hr!),
                  ),
                )
              ],
            ),
            SizedBox(
                width: 50,
                child: Center(
                  child: _leadingIcon(crypto.changePercent24Hr!),
                )),
          ],
        ),
      ),
      title: Text(
        crypto.name!,
        style: const TextStyle(color: greenColor),
      ),
      subtitle: Text(
        crypto.symbol!,
        style: const TextStyle(color: greyColor),
      ),
      leading: SizedBox(
        width: 30.0,
        child: Center(
          child: Text(
            crypto.rank.toString(),
            style: const TextStyle(color: greyColor),
          ),
        ),
      ),
    );
  }

  Widget _leadingIcon(double percentChange) {
    return percentChange <= 0
        ? const Icon(
            Icons.trending_down,
            size: 24,
            color: redColor,
          )
        : const Icon(
            Icons.trending_up,
            size: 24,
            color: greenColor,
          );
  }

  Color _colorChangeText(double percentChange) {
    return percentChange <= 0 ? redColor : greenColor;
  }

  Future<void> _filterList(String value) async {
    List<Crypto> cryptoResultList = [];

    if (value.isEmpty) {
      setState(() {
        isSearching = true;
      });
      var result = await _refresh();
      setState(() {
        listOfCrypto = result;
        isSearching = false;
      });
      return;
    }
    cryptoResultList = listOfCrypto!.where((element) {
      return element.name!.toLowerCase().contains(value.toLowerCase());
    }).toList();

    setState(() {
      listOfCrypto = cryptoResultList;
    });
  }
}
