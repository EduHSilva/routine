import 'package:flutter/material.dart';
import 'package:routine/widgets/custom_button.dart';
import 'login_view.dart';
import 'package:easy_localization/easy_localization.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(), 
          Image.asset('assets/images/welcome_image.png'),
          const SizedBox(height: 20),
          Text(
            'welcome'.tr(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'transformLife'.tr(),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomButton(
                  text: 'signIn',
                  onPressed: () => {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LoginView(),
                        ))
                      })),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
