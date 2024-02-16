import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/consts/my_validators.dart';
import 'package:shopping_app/providers/auth_provider.dart';
import 'package:shopping_app/providers/cart_provider.dart';
import 'package:shopping_app/providers/orders_provider.dart';
import 'package:shopping_app/providers/product_provider.dart';
import 'package:shopping_app/services/assets_manager.dart';
import 'package:shopping_app/services/my_app_method.dart';
import 'package:shopping_app/widgets/subtitle_text.dart';

class SendOrders extends StatefulWidget {
  static const routeName = '/SendOrders';

  const SendOrders({super.key});

  @override
  State<SendOrders> createState() => _SendOrdersState();
}

class _SendOrdersState extends State<SendOrders> {
  late TextEditingController _nameController,
      _addressController,
      _numberController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<void> _submitForm({
    required BuildContext context,
    required OrdersProvider ordersProvider,
    required CartProvider cartProvider,
    required ProductProvider productProvider,
    required AuthProvider authProvider,
    required String name,
    required String number,
    required String address,
  }) async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      await ordersProvider.sendCartItemsToServer(
          context: context,
          cartProvider: cartProvider,
          productProvider: productProvider,
          authProvider: authProvider,
          address: address,
          name: name,
          number: number);
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _numberController = TextEditingController();
    MyAppMethods.onbackgroundclick(context);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final ordersProvider = Provider.of<OrdersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'أرسال الطلبات',
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        AssetsManager.addressuser,
                        height: 150,
                        width: 150,
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      const SubtitleTextWidget(
                        label: "أدخل اسمك",
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                          textAlign: TextAlign.center,
                          controller: _nameController,
                          key: const ValueKey('اسم الزبون'),
                          decoration: const InputDecoration(
                            hintText: 'ادخل اسمك هنا',
                          ),
                          validator: (value) {
                            return MyValidators.uploadProdTexts(
                              value: value,
                              toBeReturnedString: "يرجى ادخال اسم صحيج",
                            );
                          }),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const SubtitleTextWidget(
                        label: "أدخل رقمك",
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        textAlign: TextAlign.center,
                        controller: _numberController,
                        keyboardType: TextInputType.number,
                        key: const ValueKey('رقم الزبون'),
                        decoration: const InputDecoration(
                          hintText: 'ادخل رقمك هنا',
                        ),
                        validator: (value) {
                          return MyValidators.uploadProdTexts(
                            value: value,
                            toBeReturnedString: "يرجى ادخال رقم صحيج",
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const SubtitleTextWidget(
                        label: "أدخل عنوانك",
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        textAlign: TextAlign.center,
                        controller: _addressController,
                        key: const ValueKey('عنوان الزبون'),
                        decoration: const InputDecoration(
                          hintText: 'ادخل عنوانك هنا',
                        ),
                        validator: (value) {
                          return MyValidators.uploadProdTexts(
                            value: value,
                            toBeReturnedString: "يرجى ادخال عنوان صحيج",
                          );
                        },
                      ),
                      const SizedBox(
                        height: 35.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.greenAccent,
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const SubtitleTextWidget(
                                  label: "إلغاء الأمر",
                                  fontSize: 20,
                                  color: Colors.black),
                            ),
                          ),
                          const SizedBox(
                            width: 25.0,
                          ),
                          ordersProvider.isloading
                              ? Container(
                                  width: 150,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blueAccent,
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.redAccent,
                                  ),
                                  child: TextButton(
                                    onPressed: () async {
                                      _submitForm(
                                        context: context,
                                        ordersProvider: ordersProvider,
                                        cartProvider: cartProvider,
                                        productProvider: productProvider,
                                        authProvider: authProvider,
                                        address: _addressController.text.trim(),
                                        name: _nameController.text.trim(),
                                        number: _numberController.text.trim(),
                                      );
                                    },
                                    child: const SubtitleTextWidget(
                                        label: "طلب",
                                        fontSize: 20,
                                        color: Colors.black),
                                  ),
                                ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
