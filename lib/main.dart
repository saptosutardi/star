import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart'; // Import package untuk menggunakan TextInputFormatter
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'page_kuesioner.dart';
import 'package:device_preview/device_preview.dart';

import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(EasyLocalization(
    supportedLocales: const [Locale('id'), Locale('en', 'US')],
    path: 'assets/translations',
    // child: DevicePreview(builder: (context) => MyApp()),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'STAR',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.light,
        ),
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const FirstSplashScreen(),
      routes: {
        '/dashboard': (context) => const DashboardPage(),
        '/pageAwam': (context) => const PageKeusioner(),
        '/splashScreenTambahan': (context) => const SplashScreenTambahan(),
        // Ganti dengan nama kelas dan widget splash screen tambahan Anda
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class FirstSplashScreen extends StatelessWidget {
  const FirstSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mendapatkan tanggal saat ini
    DateTime now = DateTime.now();
    // Memformat tanggal sesuai dengan format yang diinginkan
    String formattedDate = DateFormat('dd.MM.yy').format(now);
    return Scaffold(
      // backgroundColor: Colors.red[50],
      appBar: AppBar(
        title: const Text(''), // Title kosong
        actions: const [], // Actions kosong
      ),
      body: Container(
        // Menerapkan gradasi warna pada background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white, // Warna putih di bagian atas
              Colors.red[100]!, // Warna red[50] di bagian bawah
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width, // Lebar sesuai layar
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // Menyelaraskan pusat vertikal
                  children: [
                    Image(
                      image: AssetImage("assets/logo.png"),
                      height: 60,
                      width: 60,
                    ),
                    SizedBox(width: 10), // Memberi jarak antara logo dan teks
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // Menyelaraskan teks di tengah vertikal
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // Menyelaraskan teks di sebelah kiri horizontal
                      children: [
                        Text(
                          "STAR",
                          style: TextStyle(
                            fontSize: 42,
                            // Sesuaikan ukuran font sesuai kebutuhan
                            fontWeight: FontWeight.bold,
                            // color: Colors.deepOrange, // Warna deepOrange
                          ),
                        ),
                        Text(
                          "Sarcopenia Screening App",
                          textAlign: TextAlign.center,
                          // Menambahkan properti textAlign
                          style: TextStyle(
                            fontSize:
                                12, // Sesuaikan ukuran font sesuai kebutuhan
                            // color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Tambahkan versi aplikasi di bagian bawah
              Positioned(
                bottom: 500, // Geser ke bagian bawah
                right: 14,
                child: Text(
                  formattedDate,
                  style: const TextStyle(
                    color: Colors.grey, // Warna sedikit kabur
                  ),
                ),
              ),
              const Text(""),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context,
                            '/splashScreenTambahan'); // Ganti dengan rute yang sesuai
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.deepOrange),
                        foregroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 9, 6, 6)),
                        side: MaterialStateProperty.all<BorderSide>(
                          const BorderSide(color: Colors.white),
                        ),
                      ),
                      child: Text(
                        "startButton".tr(),
                        style:
                            const TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool hipertensiChecked = false;
  bool diabetesChecked = false;
  bool kolesterolChecked = false;
  bool strokeChecked = false;
  bool jantungChecked = false;
  bool otherChecked = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSharedPreferences();
  }

  Future<void> loadSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      hipertensiChecked = prefs.getBool('hipertensiChecked') ?? false;
      diabetesChecked = prefs.getBool('diabetesChecked') ?? false;
      kolesterolChecked = prefs.getBool('kolesterolChecked') ?? false;
      strokeChecked = prefs.getBool('strokeChecked') ?? false;
      jantungChecked = prefs.getBool('jantungChecked') ?? false;
    });
  }

  Future<void> resetSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hipertensiChecked', false);
    await prefs.setBool('diabetesChecked', false);
    await prefs.setBool('kolesterolChecked', false);
    await prefs.setBool('strokeChecked', false);
    await prefs.setBool('jantungChecked', false);
  }

  @override
  Widget build(BuildContext context) {
    DateTime? lastPressed;
    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (lastPressed == null ||
            now.difference(lastPressed!) > const Duration(seconds: 3)) {
          lastPressed = now;
          Fluttertoast.showToast(
            msg: "Tekan lagi untuk keluar aplikasi",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return false;
        }
        // exit(0); // Tutup aplikasi
        SystemNavigator
            .pop(); // Menutup aplikasi dengan cara yang lebih alami pada Android
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons
                      .menu), // Ganti dengan ikon menu drawer yang Anda inginkan
                  onPressed: () {
                    Scaffold.of(context)
                        .openDrawer(); // Aksi untuk membuka drawer
                  },
                );
              },
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('firstSplashScreenTitle1'.tr(),
                    style: const TextStyle(fontSize: 20.0)),
                Text('firstSplashScreenTitle2'.tr(),
                    style: const TextStyle(fontSize: 12.0)),
              ],
            ),
          ),
          drawer: buildDrawer(context),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(
                    horizontal: 8.0), // Tambahkan margin sesuai kebutuhan
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => IsiDataPage()),
                    );
                  },
                  child: const Text(
                    "PENGGUNA BARU",
                    style: TextStyle(fontSize: 28.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),*/
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RiwayatPenyakitPage(),
                      ),
                    );
                  },
                  // style: ButtonStyle(
                  //   minimumSize: MaterialStateProperty.all(const Size(200, 50)),
                  // ),
                  child: Text(
                    'startToScreening'.tr(),
                    style: const TextStyle(fontSize: 28.0),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //
              // image: AssetImage("assets/logo.png"),
              Image.asset("assets/logo.png", width: 100, height: 100),
            ],
          )),
          ListTile(
            title: Text('languageTitle'.tr()),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('chooseLanguage'.tr()),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () async {
                            context.setLocale(const Locale('id'));
                            Navigator.of(context).pop();
                          },
                          child: Text('bahasaIndonesia'.tr()),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            context.setLocale(const Locale('en', 'US'));
                            Navigator.of(context).pop();
                          },
                          child: Text('langEnglish'.tr()),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            title: Text('aboutAppTitle'.tr()),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('aboutAppTitle'.tr()),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'aboutAppContent'.tr(),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Tutup dialog
                            Navigator.of(context).pop();
                          },
                          child: Text('close'.tr()),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            title: Text('creatorTitle'.tr()),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('creatorTitle'.tr()),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            // Tindakan ketika nama dr. Winda Hamida ditekan
                            // Menghubungi melalui WhatsApp
                            const phoneNumber =
                                '628123456789'; // Ganti dengan nomor telepon yang sesuai
                            var message = 'greetingUserDoctorNameApp'.tr();
                            _launchWhatsApp(phoneNumber, message);
                            print("--->> on Tap to WhatsApps");
                          },
                          child: const Text(
                            'dr. Winda Nurhamda',
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                fontSize: 20),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Tutup dialog
                            Navigator.of(context).pop();
                          },
                          child: Text('close'.tr()),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void toggleCheckbox(String condition) {
    setState(() {
      if (condition == 'Hipertensi') {
        hipertensiChecked = !hipertensiChecked;
      } else if (condition == 'Diabetes') {
        diabetesChecked = !diabetesChecked;
      } else if (condition == 'Kolesterol') {
        kolesterolChecked = !kolesterolChecked;
      } else if (condition == 'Stroke') {
        strokeChecked = !strokeChecked;
      } else if (condition == 'Jantung') {
        jantungChecked = !jantungChecked; //Harmayadi
      }
    });
  }

  void restartApp(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const FirstSplashScreen()),
      (Route<dynamic> route) => false,
    );
  }
}

void _launchWhatsApp(String phoneNumber, String message) async {
  // final url = 'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';
  // final url = "whatsapp://send?phone=$phoneNumber&text=$message";

  final phoneNumber = '6281246727079';
  final message = "greetingUserDoctorNameApp".tr();
  final url =
      'whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}';

  try {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      // Handle the error or show a dialog to the user
      print('Could not launch $url');
    }
  } catch (e) {
    print('Error: $e');
  }

  // if (await canLaunch(url)) {
  //   await launch(url);
  // } else {
  //   throw 'Could not launch $url';
  // }
}

class RiwayatPenyakitPage extends StatelessWidget {
  bool hipertensiChecked = false;
  bool diabetesChecked = false;
  bool kolesterolChecked = false;
  bool strokeChecked = false;
  bool jantungChecked = false;
  bool otherChecked = false;
  TextEditingController textFieldController = TextEditingController();

  RiwayatPenyakitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Kembali ke HomeScreen ketika back button ditekan
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => DashboardPage()),
          (Route<dynamic> route) => false,
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('diseaseHistoryTitle'.tr()),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Navigasi ke DashboardPage ketika tombol kembali di AppBar ditekan
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DashboardPage()),
              );
            },
          ),
        ),
        body: StatefulBuilder(
          builder: (context, setState) {
            var textStyle =
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 22);
            // var textFieldController;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 30),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      'diseaseHistoryPrompt'.tr(),
                      style: const TextStyle(fontSize: 18),
                    ),
                    CheckboxListTile(
                      title: Text('hypertensionLabel'.tr(), style: textStyle),
                      value: hipertensiChecked,
                      onChanged: (newValue) {
                        setState(() {
                          hipertensiChecked = newValue ?? false;
                          updateSharedPreferences();
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('diabetesLabel'.tr(), style: textStyle),
                      value: diabetesChecked,
                      onChanged: (newValue) {
                        setState(() {
                          diabetesChecked = newValue ?? false;
                          updateSharedPreferences();
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('cholesterolLabel'.tr(), style: textStyle),
                      value: kolesterolChecked,
                      onChanged: (newValue) {
                        setState(() {
                          kolesterolChecked = newValue ?? false;
                          updateSharedPreferences();
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('strokeLabel'.tr(), style: textStyle),
                      value: strokeChecked,
                      onChanged: (newValue) {
                        setState(() {
                          strokeChecked = newValue ?? false;
                          updateSharedPreferences();
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('heartDiseaseLabel'.tr(), style: textStyle),
                      value: jantungChecked,
                      onChanged: (newValue) {
                        setState(() {
                          jantungChecked = newValue ?? false;
                          updateSharedPreferences();
                        });
                      },
                    ),
                    // Tambahkan TextField di bawah CheckboxListTile
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: textFieldController,
                        decoration: InputDecoration(
                          labelText: 'otherConditionLabel'.tr(),
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z\s]+')),
                          // Hanya memperbolehkan huruf dan spasi
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigator.pop(context);

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const DashboardPage()),
                              );
                              // MaterialPageRoute(builder: (context) => DashboardPage()),
                              // (Route<dynamic> route) => false,
                            },
                            child: Text(
                              'cancelButton'.tr(),
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(6)),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              // await loadSharedPreferences();

                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              final bool? hipertensiChecked =
                                  prefs.getBool('hipertensiChecked');
                              final bool? diabetesChecked =
                                  prefs.getBool('diabetesChecked');
                              final bool? kolesterolChecked =
                                  prefs.getBool('kolesterolChecked');
                              print("--> testing push button LANJUTKAN ");
                              print(
                                  "--> hipertensiChecked = $hipertensiChecked");
                              print("--> diabetesChecked = $diabetesChecked");
                              print(
                                  "--> kolesterolChecked = $kolesterolChecked");
                              Navigator.of(context).pushNamed(
                                  '/pageAwam'); // Navigasi ke '/pageAwam'
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                            child: Text(
                              'continueButton'.tr(),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(8)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> updateSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hipertensiChecked', hipertensiChecked);
    await prefs.setBool('diabetesChecked', diabetesChecked);
    await prefs.setBool('kolesterolChecked', kolesterolChecked);
    await prefs.setBool('strokeChecked', strokeChecked);
    await prefs.setBool('jantungChecked', jantungChecked);
  }
}

class IsiDataPage extends StatelessWidget {
  const IsiDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController ageController = TextEditingController();
    final TextEditingController weightController = TextEditingController();
    final TextEditingController heightController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('fillDataLabel'.tr()),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: const Color.fromRGBO(255, 240, 240, 1.0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'name'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: ageController,
                  decoration: const InputDecoration(
                    labelText: 'Usia (tahun)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: weightController,
                  decoration: InputDecoration(
                    labelText: 'weight'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: heightController,
                  decoration: const InputDecoration(
                    labelText: 'height',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 32)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'returnButton'.tr(),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(8)),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (nameController.text.isEmpty ||
                            ageController.text.isEmpty ||
                            weightController.text.isEmpty ||
                            heightController.text.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  'fillAllFieldsError'.tr(),
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'ok'.tr(),
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 24),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          // Lakukan aksi lanjutan jika semua isian sudah diisi
                          print('Lakukan aksi lanjutan');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: Text(
                        'continueButton'.tr(),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RekomendasiPage extends StatelessWidget {
  const RekomendasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('recommendationTitle'.tr()),
      ),
      body: Center(
        child: Text('recommendationPageTitle'.tr()),
      ),
    );
  }
}

// SPLASH SCREEN
class SplashScreenTambahan extends StatelessWidget {
  const SplashScreenTambahan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Tambahkan SizedBox di sini untuk menambahkan ruang kosong di atas Card pertama
            const SizedBox(height: kToolbarHeight),
            // Menggunakan kToolbarHeight agar setinggi AppBar

            // Card 1
            _buildCard(
              "splashScreenCard1".tr(),
            ),

            // Card 2
            _buildCard(
              "splashScreenCard2".tr(),
            ),

            // Card 3
            _buildCard(
              "splashScreenCard3".tr(),
            ),

            // FilledButton "Lewati" di bagian bawah tengah
            // SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                Navigator.pushNamed(
                    context, '/dashboard'); // Navigasi ke halaman beranda
              },
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  // Mengatur ukuran agar sesuai dengan konten
                  children: [
                    const Icon(Icons.arrow_forward),
                    const SizedBox(width: 8),
                    Text(
                      'skipButton'.tr(),
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    // Menambahkan jarak antara teks dan ikon
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String content) {
    return Card(
      margin: const EdgeInsets.all(14.0),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: <Widget>[
            Text(
              content,
              style: const TextStyle(fontSize: 23.0),
            ),
          ],
        ),
      ),
    );
  }
}
