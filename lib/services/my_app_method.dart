import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/screens/search_screen.dart';
import 'package:shopping_app/widgets/title_text.dart';

import '../widgets/subtitle_text.dart';
import 'assets_manager.dart';

class MyAppMethods {
  static Future<void> showErrorORWarningDialog({
    required BuildContext context,
    required String subtitle,
    required Function fct,
    bool isError = true,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AssetsManager.warning,
                height: 60,
                width: 60,
              ),
              const SizedBox(
                height: 16.0,
              ),
              SubtitleTextWidget(
                label: subtitle,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: !isError,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const SubtitleTextWidget(
                          label: "إلغاء الأمر", color: Colors.green),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      fct();
                      Navigator.pop(context);
                    },
                    child: const SubtitleTextWidget(
                        label: "نعم", color: Colors.red),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  static Future<void> showErrorORWarningDialogWithWhatsapp({
    required BuildContext context,
    required String subtitle,
    required Function fct,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AssetsManager.warning,
                height: 75,
                width: 75,
              ),
              const SizedBox(
                height: 20.0,
              ),
              SubtitleTextWidget(
                label: subtitle,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                height: 16.0,
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    iconColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 49, 172, 53),
                    ),
                    iconSize: MaterialStatePropertyAll(25),
                    backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 173, 255, 215),
                    ),
                  ),
                  onPressed: () {
                    fct();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SubtitleTextWidget(
                        label: "رقم الواتساب",
                        color: Color.fromARGB(255, 49, 172, 53),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Image.asset(
                        "assets/images/whatsapp.png",
                        width: 25,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  static Future<void> imagePickerDialog({
    required BuildContext context,
    required Function cameraFCT,
    required Function galleryFCT,
    required Function removeFCT,
  }) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(
              child: TitlesTextWidget(
                label: "Choose option",
              ),
            ),
            content: SingleChildScrollView(
                child: ListBody(
              children: [
                TextButton.icon(
                  onPressed: () {
                    cameraFCT();
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.camera),
                  label: const Text(
                    "Camera",
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    galleryFCT();
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.image),
                  label: const Text(
                    "Gallery",
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    removeFCT();
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.remove),
                  label: const Text(
                    "Remove",
                  ),
                ),
              ],
            )),
          );
        });
  }

  static onbackgroundclick(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Map<String, dynamic> arguments = {
        'storeId': int.parse(message.data['pageid'].toString()),
        'storeAddress': message.data['pagename'],
      };
      if (message.notification != null) {
        Navigator.pushNamed(context, SearchScreen.routeName,
            arguments: arguments);
      }
    });
  }

  static ontirmenetdclick(BuildContext context) async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    Map<String, dynamic> arguments = {
      'storeId': int.parse(message!.data['pageid'].toString()),
      'storeAddress': message.data['pagename'],
    };
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: arguments);
  }
}
