import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _textController;
  late final FocusNode _textFocus;

  String qrText = '';

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences prefs;

  _asyncInitialization() async {
    prefs = await _prefs;
    qrText = prefs.getString('qrText') ?? '';
    return qrText;
  }

  @override
  void initState() {
    _asyncInitialization().then((result) {
      qrText = prefs.getString('qrText') ?? '';
      _textController = TextEditingController(text: qrText);
      _textFocus = FocusNode();
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QRcode generator'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              iconSize: 40.0,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BarcodePage()));

              },
              icon: const Icon(Icons.arrow_forward),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _textController,
              focusNode: _textFocus,
              decoration: InputDecoration(
                labelText: 'QR Text',
                labelStyle: const TextStyle(
                  color: Color(0xFF80919F),
                ),
                hintText: 'Enter text / URL',
                hintStyle: const TextStyle(
                  color: Color(0xFF80919F),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black54,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onChanged: (value) => setState(() {
                qrText = value;
                prefs.setString('qrText', qrText);
              }),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SizedBox(
                height: 200,
                width: 200,
                child: QrImageView(
                  data: qrText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BarcodePage extends StatefulWidget {
  const BarcodePage({super.key});

  @override
  State<BarcodePage> createState() => _BarcodePageState();
}

class _BarcodePageState extends State<BarcodePage> {
  late final TextEditingController _textController;
  late final FocusNode _textFocus;

  String barcodeText = '';

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences prefs;

  _asyncInitialization() async {
    prefs = await _prefs;
    barcodeText = prefs.getString('barcodeText') ?? '';
    return barcodeText;
  }

  @override
  void initState() {
    _asyncInitialization().then((result) {
      barcodeText = prefs.getString('barcodeText') ?? '';
      _textController = TextEditingController(text: barcodeText);
      _textFocus = FocusNode();
      setState(() {});
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _textController,
              focusNode: _textFocus,
              decoration: InputDecoration(
                labelText: 'Barcode Text',
                labelStyle: const TextStyle(
                  color: Color(0xFF80919F),
                ),
                hintText: 'Enter text / URL',
                hintStyle: const TextStyle(
                  color: Color(0xFF80919F),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black54,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onChanged: (value) => setState(() {
                barcodeText = value;
                prefs.setString('barcodeText', barcodeText);
              }),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: SfBarcodeGenerator(
                    value: barcodeText,
                    symbology: Code128(module: 3),
                    showValue: true,
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
