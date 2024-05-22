import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:lootfat_owner/utils/colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetMyQrCode extends StatefulWidget {
  const GetMyQrCode({super.key});

  @override
  State<GetMyQrCode> createState() => _GetMyQrCodeState();
}

class _GetMyQrCodeState extends State<GetMyQrCode> {
  ScreenshotController screenshotController = ScreenshotController();
  String? myQrCode = "";
  String? shopName = "";

  GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    getMyCode();
    super.initState();
  }

  getMyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myQrCode = prefs.getString("qrCode");
      shopName = prefs.getString("shopName");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.main,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
            Screenshot(
              controller: screenshotController,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    shopName ?? "",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        RepaintBoundary(
                          key: globalKey,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: QrImageView(
                              data: myQrCode!,
                              version: QrVersions.auto,
                              gapless: true,
                              backgroundColor: Colors.white,
                              size: 300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: BorderSide(width: 2, color: Colors.white),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () => captureAndShare(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 20),
                    Text("Share QR"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // captureAndShare() async {
  //   final directory = await getDownloadsDirectory(); //from path_provide package
  //   String fileName = "LootFat";
  //   String path = '$directory';
  //   screenshotController.captureAndSave(path, fileName: fileName);
  //   await Share.shareXFiles([
  //     XFile('$directory/LootFat.jpg'),
  //   ], text: 'My QR Code');
  // }

  // captureAndShare() async {
  //   final image = await QrPainter(
  //     data: myQrCode!,
  //     version: QrVersions.auto,
  //     gapless: false,
  //     color: Colors.white,
  //     emptyColor: Colors.black,
  //   ).toImageData(500.0); // Generate QR code image data

  //   final filename = 'qr_code.png';
  //   final tempDir =
  //       await getTemporaryDirectory(); // Get temporary directory to store the generated image
  //   final file = await File('${tempDir.path}/$filename')
  //       .create(); // Create a file to store the generated image
  //   var bytes = image!.buffer.asUint8List(); // Get the image bytes
  //   await file.writeAsBytes(bytes);
  //   // Share.shareFiles([file.path],
  //   //     text: 'QR code for $myQrCode',
  //   //     subject: 'QR Code',
  //   //     mimeTypes: ['image/png']);

  //   final files = <XFile>[];
  //   files.add(XFile(file.path, name: filename));

  //   await Share.shareXFiles(
  //     files,
  //     text: 'QR code for $myQrCode',
  //     subject: 'QR Code',
  //   );

  //   // Share the generated image using the share_plus package
  //   //print('QR code shared to: $path');
  // }

  Future<void> captureAndShare() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      var image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);
      final files = <XFile>[];
      files.add(XFile(file.path, name: file.path));
      await Share.shareXFiles(
        files,
        text: 'QR code for $myQrCode',
        subject: 'QR Code',
      );
      // final channel = const MethodChannel('channel:me.alfian.share/share');
      // channel.invokeMethod('shareFile', 'image.png');
    } catch (e) {
      print(e.toString());
    }
  }
}
