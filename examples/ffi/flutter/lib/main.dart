import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:filecoin/filecoin.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

const msg = {
  "description": "Tampered signature and look if it is valid",
  "private_key": "8VcW07ADswS4BV2cxi5rnIadVsyTDDhY1NfDH19T8Uo=",
  "message": {
    "To": "t17uoq6tp427uzv7fztkbsnn64iwotfrristwpryy",
    "From": "t1d2xrzcslx7xlbbylc5c3d5lvandqw4iwl6epxba",
    "Nonce":1200, 
    "Value": "100000",
    "GasLimit": 1,
    "GasFeeCap": "1",
    "GasPremium": "1",
    "Method": 0,
    "Params": ""
  }
};
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const String Mnemonic =
      'equip will roof matter pink blind book anxiety banner elbow sun young';
  static const String Path = "m/44'/461'/0/0/0";

  static String _privateKey() {
    var error = Filecoin.errorNew();
    var extendedKey =
        Filecoin.keyDerive(Utf8.toUtf8(Mnemonic), Utf8.toUtf8(Path), error);

    var privateKey = "Error";
    if (Filecoin.errorCode(error) != 0) {
      stderr.write(Filecoin.errorMessage(error));
    } else {
      var privateKeyPtr = Filecoin.extendedKeyPrivateKey(extendedKey, error);
      privateKey = Utf8.fromUtf8(privateKeyPtr);
      assert(privateKey ==
          'f15716d3b003b304b8055d9cc62e6b9c869d56cc930c3858d4d7c31f5f53f14a');
      Filecoin.stringFree(privateKeyPtr);
    }

    Filecoin.extendedKeyFree(extendedKey);
    Filecoin.errorFree(error);

    return privateKey;
  }

  static String _signMessage() {
    var message = jsonEncode(msg['message']);
    var privKey = msg["private_key"];
    var sign = Filecoin.signMessage(Utf8.toUtf8(message), Utf8.toUtf8(privKey));
    return Utf8.fromUtf8(sign);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Filecoin'),
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                  'PrivateKey for Mnemonic "$Mnemonic" and Path "$Path": ${_privateKey()}'),
              Text(_signMessage())
            ],
          ),
        ),
      ),
    );
  }
}
