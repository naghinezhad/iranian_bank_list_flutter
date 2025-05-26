import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iranian_banks/iranian_banks.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const testCardNumber = '62198619';
    final bank = IranianBanks.getBankFromCard(testCardNumber);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('تست اطلاعات بانک')),
        body: Column(
          children: <Widget>[
            bank == null
                ? const Center(
                    child: Text('بانکی برای این شماره کارت پیدا نشد'),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bank.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        bank.logoBuilder(height: 100),
                        SvgPicture.asset(bank.logoPath),
                        const SizedBox(height: 16),
                        Text('نام بانک: ${bank.name}'),
                        Text(
                          'رنگ اصلی:',
                          style: TextStyle(color: bank.darkerColor),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
