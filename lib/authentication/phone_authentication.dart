import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:globebricks/home/home.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneAuthentication extends StatefulWidget {
  const PhoneAuthentication({super.key});

  @override
  State<PhoneAuthentication> createState() => _PhoneAuthenticationState();
}

class _PhoneAuthenticationState extends State<PhoneAuthentication>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool loading = false;

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _launchUniversalLinkIos(Uri url) async {
    final bool nativeAppLaunchSucceeded = await launchUrl(
      url,
      mode: LaunchMode.externalNonBrowserApplication,
    );
    if (!nativeAppLaunchSucceeded) {
      await launchUrl(
        url,
        mode: LaunchMode.inAppWebView,
      );
    }
  }

  final Uri toLaunch =
      Uri(scheme: 'https', host: 'www.okstitch.com', path: 'headers/');

  @override
  void dispose() {
    _controller.dispose();
    numberField.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  String countryCode = "+91";
  TextEditingController numberField = TextEditingController();
  GlobalKey<FormState> phoneAuthKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Row(children: [
                Icon(Icons.arrow_back_ios,
                    color: Platform.isIOS ? Colors.blue : Colors.black),
                Text(
                  "Back",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 25,
                      fontWeight: FontWeight.w400,
                      color: Platform.isIOS ? Colors.blue : Colors.black),
                ),
              ]),
            ),
          ),
          Text(
            "Continue with Phone Number",
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 20,
                fontFamily: "Mukta",
                color: Colors.black54),
          ),
          Lottie.asset(
            "assets/phone_verification.json",
            controller: _controller,
            onLoaded: (composition) {
              _controller
                ..duration = composition.duration
                ..forward();
            },
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.2,
            child: Form(
              key: phoneAuthKey,
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Phone number required.";
                  } else if (value.length < 10) {
                    return "Enter 10 digits.";
                  } else {
                    return null;
                  }
                },
                controller: numberField,
                maxLength: 10,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
                autofillHints: const [AutofillHints.telephoneNumber],
                decoration: InputDecoration(
                    prefixIcon: CountryCodePicker(
                      onChanged: (value) {
                        countryCode = value.toString();
                      },
                      initialSelection: 'IN',
                      favorite: const ['+91', 'IN'],
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,
                    ),
                    border: const OutlineInputBorder(),
                    hintText: "Number",
                    hintStyle: const TextStyle(color: Colors.black),
                    labelStyle: const TextStyle(color: Colors.black)),
              ),
            ),
          ),
        loading ? Platform.isIOS ? const CupertinoActivityIndicator() : const CircularProgressIndicator() : CupertinoButton(
            onPressed: () {
              if (phoneAuthKey.currentState!.validate()) {
                setState(() {
                  loading = true;
                });
                Future.delayed(const Duration(milliseconds: 1500)).then((value) => {
                if (Platform.isAndroid) {
                    Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Home(),
                    ),
                        (route) => false)
              },
              if (Platform.isIOS) {
                Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const Home(),
                    ),
                        (route) => false)
              }
                });
              }
            },
            color: Colors.blue,
            child: const Text(
              "Continue",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width / 8,
                left: MediaQuery.of(context).size.width / 30),
            child: Row(
              children: [
                Text(
                  "We will send you one time password\non your mobile number.",
                  style: TextStyle(
                    fontFamily: "Nunito",
                      fontSize: MediaQuery.of(context).size.width / 22),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width / 8,
                left: MediaQuery.of(context).size.width / 30,
                right: MediaQuery.of(context).size.width/30),
            child: GestureDetector(
              onTap: () async {
                Platform.isIOS
                    ? _launchUniversalLinkIos(toLaunch)
                    : _launchInBrowser(toLaunch);
              },
              child: RichText(
                text: TextSpan(
                  text: 'By pressing continue, you agree to our ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.width / 30,
                  ),
                  children: [
                    TextSpan(
                      text: 'Terms,',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: MediaQuery.of(context).size.width / 30,
                      ),
                    ),
                    TextSpan(
                      text: ' Privacy Policy',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: MediaQuery.of(context).size.width / 30,
                      ),
                    ),
                    TextSpan(
                      text: ' and ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width / 30,
                      ),
                    ),
                    TextSpan(
                      text: 'Cookies Policy',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: MediaQuery.of(context).size.width / 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    ));
  }
}
