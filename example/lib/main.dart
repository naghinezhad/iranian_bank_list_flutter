import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:iranian_banks/iranian_banks.dart';

// enum برای مدیریت وضعیت اعتبارسنجی بدون تغییر باقی می‌ماند
enum VerificationState { neutral, valid, invalid }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Vazirmatn',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fa')],
      locale: const Locale('fa'),
      home: const BankInfoPage(),
    );
  }
}

class BankInfoPage extends StatelessWidget {
  const BankInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('مثال اپلیکیشن شناسایی و اعتبارسنجی بانک'),
          bottom: const TabBar(
            tabs: [Tab(text: 'شماره کارت'), Tab(text: 'شماره شبا')],
          ),
        ),
        body: TabBarView(
          children: [
            BankLookupTab(
              lookupFunction: IranianBanks.getBankFromCard,
              verificationFunction: IranianBanks.verifyCard,
              labelText: 'شماره کارت',
              hintText: 'شماره ۱۶ رقمی کارت را وارد کنید',
              maxLength: 16,
              minLengthForLookup: 6, // شناسایی بانک از ۶ رقم
              keyboardType: TextInputType.number,
            ),
            BankLookupTab(
              lookupFunction: IranianBanks.getBankFromIban,
              verificationFunction: IranianBanks.verifyIBAN,
              labelText: 'شماره شبا (IBAN)',
              hintText: 'شماره شبا را با IR شروع کنید',
              maxLength: 26,
              minLengthForLookup: 7, // شناسایی بانک از ۷ کاراکتر (IR + 5)
              keyboardType: TextInputType.text,
            ),
          ],
        ),
      ),
    );
  }
}

class BankLookupTab extends StatefulWidget {
  final BankInfoView? Function(String) lookupFunction;
  final bool Function(String) verificationFunction;
  final String labelText;
  final String hintText;
  final int maxLength;
  final int minLengthForLookup; // پارامتر جدید برای حداقل طول شناسایی
  final TextInputType keyboardType;

  const BankLookupTab({
    super.key,
    required this.lookupFunction,
    required this.verificationFunction,
    required this.labelText,
    required this.hintText,
    required this.maxLength,
    required this.minLengthForLookup,
    required this.keyboardType,
  });

  @override
  State<BankLookupTab> createState() => _BankLookupTabState();
}

class _BankLookupTabState extends State<BankLookupTab> {
  final TextEditingController _controller = TextEditingController();
  BankInfoView? _bankInfo;
  VerificationState _verificationState = VerificationState.neutral;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onInputChanged);
  }

  // منطق این تابع کاملاً تغییر کرده است
  void _onInputChanged() {
    final inputText = _controller.text.replaceAll(RegExp(r'[\s-]'), '');

    setState(() {
      // --- بخش اول: شناسایی بانک (بر اساس حداقل طول) ---
      if (inputText.length >= widget.minLengthForLookup) {
        _bankInfo = widget.lookupFunction(inputText);
      } else {
        _bankInfo = null;
      }

      // --- بخش دوم: اعتبارسنجی (فقط در طول کامل) ---
      if (inputText.length == widget.maxLength) {
        final bool isValid = widget.verificationFunction(inputText);
        _verificationState =
            isValid ? VerificationState.valid : VerificationState.invalid;
      } else {
        // تا زمانی که طول کامل نشده، وضعیت خنثی است
        _verificationState = VerificationState.neutral;
      }
    });
  }

  Widget? _getVerificationIcon() {
    switch (_verificationState) {
      case VerificationState.valid:
        return const Icon(Icons.check_circle, color: Colors.green);
      case VerificationState.invalid:
        return const Icon(Icons.cancel, color: Colors.red);
      case VerificationState.neutral:
        return null;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onInputChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: _controller,
            keyboardType: widget.keyboardType,
            maxLength: widget.maxLength,
            decoration: InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
              suffixIcon: _getVerificationIcon(),
              counterText: '',
            ),
          ),
          const SizedBox(height: 24),
          BankCardWidget(bankInfo: _bankInfo),
        ],
      ),
    );
  }
}

// ویجت کارت بانکی بدون هیچ تغییری باقی می‌ماند
class BankCardWidget extends StatelessWidget {
  final BankInfoView? bankInfo;

  const BankCardWidget({super.key, this.bankInfo});

  @override
  Widget build(BuildContext context) {
    if (bankInfo == null) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const SizedBox(
          height: 200,
          child: Center(
            child: Text(
              'برای نمایش اطلاعات، شماره را وارد کنید.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      );
    }
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [bankInfo!.primaryColor, bankInfo!.darkerColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: bankInfo!.logoBuilder(height: 40),
              ),
              const Spacer(),
              Text(
                bankInfo!.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 2,
                      color: Colors.black26,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                bankInfo!.name,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
