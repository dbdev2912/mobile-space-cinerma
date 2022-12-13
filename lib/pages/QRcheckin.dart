import 'package:barcode_scan2/gen/protos/protos.pb.dart';
import 'package:barcode_scan2/model/android_options.dart';
import 'package:barcode_scan2/model/scan_options.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/BASE_CONFIG.dart';
import '../services/BASE_URL.dart';
import 'checkin_detail.dart';


class Checkin extends StatefulWidget{
  const Checkin({ Key? key }) : super( key: key );

  @override
  _CheckinState createState() => _CheckinState();
}

class _CheckinState extends State<Checkin>{
  ScanResult? scanResult;
  static final qrFormat = BarcodeFormat.qr;

  void QRScanTrigger() async {
    try {
      final result = await BarcodeScanner.scan(
          options: ScanOptions(
            restrictFormat: [qrFormat],
            android: AndroidOptions(
              aspectTolerance: 0.0,
              useAutoFocus: true,
            ),
          )
      );

      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => CheckinDetail( id: result.rawContent ))
      );
    } on PlatformException catch (e) {
      print("Errorr");
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(

      body: Center(
          child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      decoration: const BoxDecoration(
                          color: Colors.white
                      ),
                      height: 120.0,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                                shadowColor: Colors.transparent,
                              ),
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                              child: const Icon( Icons.arrow_back, color: Color.fromRGBO(129, 129, 129, 1), size: 32.0 )
                          ),

                          Container(
                            margin: const EdgeInsets.all(12.0),
                            child: Text(
                                "Checkin infor",
                                style: const TextStyle(
                                    fontSize: BASE_HEAD_BAR_FONT_SIZE,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(153, 0, 0, 1)
                                )
                            ),
                          ),

                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 5.0, color: Colors.white),
                              borderRadius: BorderRadius.circular(75.0),
                            ),
                            width: 100.0,
                            height: 100.0,
                            margin: const EdgeInsets.all(12),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),

                                    gradient: const LinearGradient(
                                      colors: [Color.fromRGBO(255, 102, 85, 1), Color.fromRGBO(153, 0, 0, 1)],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    )
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage("$BASE_SERVER_URL/images/logo.jpg"),
                                  ),
                                )
                            ),
                          ),
                        ],
                      )
                  ),

                  Container(
                      child: Center(
                        child: Text("Scan a code to checkin and have your seat!"),
                      )
                  )

                ],
              )
          )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.qr_code),
        onPressed: (){
          QRScanTrigger();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}