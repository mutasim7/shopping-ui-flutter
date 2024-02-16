import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/Root_App_Store_Screen.dart';
import 'package:shopping_app/services/auth_services.dart';
import 'package:shopping_app/widgets/subtitle_text.dart';

class StoresWidget extends StatelessWidget {
  const StoresWidget({
    super.key,
    required this.name,
    required this.storeId,
    required this.storeaddress,
    this.storeImage,
    required this.status,
  });

  final String name;
  final int storeId;
  final int status;
  final String storeaddress;
  final String? storeImage;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // final storeProvider = Provider.of<StoreProvider>(context);
    Map<String, dynamic> arguments = {
      'storeId': storeId,
      'storeAddress': storeaddress,
    };

    return Visibility(
      visible: status == 0 ? false : true,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            RootAppStoreScreen.routeName,
            arguments: arguments,
          );
        },
        child: Card(
          color: const Color.fromARGB(214, 182, 156, 255),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  storeImage == null
                      ? Image.asset(
                          "assets/images/icons8-store-96.png",
                          height: 150,
                          width: 150,
                        )
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            // border: Border.all(
                            //   color: Colors
                            //       .deepPurpleAccent, // اللون المرغوب للحدود
                            //   width: 3.0, // سماكة الحدود
                            // ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                20.0), // نفس نصف قطر الحدود المستديرة للـ Container
                            child: FancyShimmerImage(
                              imageUrl: AuthServices.linkStorage + storeImage!,
                              width: double.infinity,
                              height: size.height * 0.22,
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SubtitleTextWidget(
                      label: name,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
