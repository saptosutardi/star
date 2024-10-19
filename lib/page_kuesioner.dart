import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:star/page_ke_dokter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'page_execise.dart';
import 'page_nutrisi.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

Stopwatch stopwatch = Stopwatch()..start();

class PageKeusioner extends StatefulWidget {
  const PageKeusioner({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PageKeusionerState createState() => _PageKeusionerState();
}

class _PageKeusionerState extends State<PageKeusioner> {
  final List<int> steps = [1, 2, 3, 4, 5];
  List<int?> answers = [null, null, null, null, null];
  int currentStep = 1;
  double fontSize = 18.0;

  var user1 = false;
  var user2 = false;

  void increaseFontSize() {
    setState(() {
      fontSize += 2.0;
    });
  }

  void decreaseFontSize() {
    setState(() {
      fontSize = fontSize > 2.0 ? fontSize - 2.0 : fontSize;
    });
  }

  void navigateBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var mainColor = const Color(0xFFB02F00); //Colors.deepOrange;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('firstSplashScreenTitle1'.tr(),
                style: const TextStyle(fontSize: 20.0)),
            Text('firstSplashScreenTitle2'.tr(),
                style: const TextStyle(fontSize: 12.0)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: increaseFontSize,
            icon: const Icon(Icons.zoom_in),
          ),
          IconButton(
            onPressed: decreaseFontSize,
            icon: const Icon(Icons.zoom_out),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doted Line Step Indicator
              Center(
                child: SizedBox(
                  width: 200.0,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const SizedBox(
                        width: 180.0,
                        child: Divider(
                          color: Colors.grey,
                          thickness: 2,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (var step in steps)
                            Icon(
                              Icons.circle,
                              color:
                                  step == currentStep ? mainColor : Colors.grey,
                              size: step == currentStep ? 24.0 : 16.0,
                            )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              // Icon di tengah CustomStepIndicator
              Align(
                alignment: Alignment.center,
                child: getStepIcon(currentStep - 1),
              ),
              // Pertanyaan dan Pilihan Jawaban
              Text(
                getQuestion(currentStep - 1),
                style: TextStyle(fontSize: fontSize + 2),
              ),
              const SizedBox(height: 5),
              Text(
                "stepInstruction".tr(),
                style: TextStyle(
                  fontSize: fontSize + 2,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 10),
              for (int i = 0; i < 3; i++)
                RadioListTile<int?>(
                  title: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: answers[currentStep - 1] == i
                            ? mainColor
                            : Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      getAnswerText(i),
                      style: TextStyle(
                        fontSize: fontSize + 2,
                        color: answers[currentStep - 1] == i
                            ? mainColor
                            : mainColor,
                      ),
                    ),
                  ),
                  value: i,
                  groupValue: answers[currentStep - 1],
                  onChanged: (value) {
                    setState(() {
                      answers[currentStep - 1] = value;
                    });
                  },
                ),

              const SizedBox(height: 30),
              if (answers[currentStep - 1] != null)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(
                          horizontal:
                              16.0), // Tambahkan margin sesuai kebutuhan

                      child: OutlinedButton(
                        style: ButtonStyle(
                          side: MaterialStateProperty.resolveWith<BorderSide>(
                            (Set<MaterialState> states) {
                              return BorderSide(color: mainColor);
                            },
                          ),
                          minimumSize: MaterialStateProperty.all(const Size(
                              200, 50)), // Sesuaikan ukuran sesuai kebutuhan
                        ),
                        onPressed: () {
                          if (currentStep > 1) {
                            setState(() {
                              currentStep--;
                            });
                          } else {
                            // Navigator.pop(context);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RiwayatPenyakitPage(),
                              ),
                            );
                          }
                        },
                        child: Text(
                          'prevButton'.tr(),
                          style: const TextStyle(
                              fontSize:
                                  18.0), // Sesuaikan ukuran teks sesuai kebutuhan
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: FilledButton(
                        onPressed: () async {
                          if (currentStep < 5) {
                            setState(() {
                              currentStep++;
                            });
                          } else {
                            int totalScore = calculateTotalScore();
                            debugPrint("--> totalScore = $totalScore");
                            bool isAnyTrue =
                                await checkAnySharedPreferencesTrue();
                            debugPrint("--> isAnyTrue = $isAnyTrue");
                            if (isAnyTrue) {
                              // Lakukan sesuatu jika ada salah satu boolean yang true
                              debugPrint(
                                  '--> Ada salah satu atau beberapa boolean yang true.');
                            } else {
                              // Lakukan sesuatu jika tidak ada satupun boolean yang true
                              debugPrint('--> Tidak ada boolean yang true.');
                            }

                            debugPrint("--> testing push button LANJUTKAN ");
                            String resultText = totalScore > 3
                                ? 'resultTextSarcopenia'.tr()
                                : 'resultTextNoSarcopenia'.tr();

                            stopwatch.stop();
                            final elapsedMilliseconds =
                                stopwatch.elapsedMilliseconds;
                            print('--> Waktu respon: $elapsedMilliseconds ms');
                            stopwatch.reset();
                            stopwatch.start();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HasilKuesionerPage(
                                    resultText: resultText,
                                    totalScore: totalScore),
                              ),
                            );
                          }
                        },
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(const Size(
                              200, 50)), // Sesuaikan ukuran sesuai kebutuhan
                        ),
                        child: Text(
                          currentStep < 5
                              ? 'nextButton'.tr()
                              : 'seeResultsButton'.tr(),
                          style: const TextStyle(
                              fontSize:
                                  18.0), // Sesuaikan ukuran teks sesuai kebutuhan
                        ),
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }

  String getQuestion(int step) {
    List<String> questions = [
      'question1'.tr(),
      'question2'.tr(),
      'question3'.tr(),
      'question4'.tr(),
      'question5'.tr(),
    ];
    return questions[step];
  }

  String getAnswerText(int index) {
    List<String> answerTexts = [
      'answerOption1'.tr(),
      'answerOption2'.tr(),
      'answerOption3'.tr(),
    ];

    if (currentStep == 5) {
      answerTexts = [
        'answerOption4'.tr(),
        'answerOption5'.tr(),
        'answerOption6'.tr(),
      ];
    }

    return answerTexts[index];
  }

  int calculateTotalScore() {
    return answers.fold(0, (sum, score) => sum + score!);
  }

  Widget getStepIcon(int step) {
    List<String> stepIcons = [
      'strength.gif',
      'assissting.gif',
      'rise.gif',
      'climb.gif',
      'falling.gif',
    ];

    return Image.asset(
      'assets/${stepIcons[step]}',
      width: 160.0,
      height: 160.0,
    );
  }
}

Future<bool> checkAnySharedPreferencesTrue() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool? hipertensiChecked = prefs.getBool('hipertensiChecked');
  final bool? diabetesChecked = prefs.getBool('diabetesChecked');
  final bool? kolesterolChecked = prefs.getBool('kolesterolChecked');
  final bool? strokeChecked = prefs.getBool('strokeChecked');
  final bool? jantungChecked = prefs.getBool('jantungChecked');

  print(
      "--> pref = $hipertensiChecked, $diabetesChecked, $kolesterolChecked, $strokeChecked, $jantungChecked");

  return hipertensiChecked == true ||
      diabetesChecked == true ||
      kolesterolChecked == true ||
      strokeChecked == true ||
      jantungChecked == true;
}

class RekomendasiPage extends StatelessWidget {
  const RekomendasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('recommendationPageTitle'.tr()),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ExercisePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: Text('exercisePageButton'.tr(),
                      style: const TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: OutlinedButton(
                  onPressed: () {
                    // Navigasi ke halaman nutrisi saat tombol "Nutrisi" ditekan
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NutrisiPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: Text('nutritionPageButton'.tr(),
                      style: const TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                margin: const EdgeInsets.all(16.0),
                elevation: 3,
                color: Colors.red[100],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'warningTitle'.tr(),
                        style: const TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'warningContent'.tr(),
                        style: const TextStyle(fontSize: 24.0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: <Widget>[
            Expanded(child: Text(label)),
            Checkbox(
              value: value,
              onChanged: (bool? newValue) {
                onChanged(newValue!);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HasilKuesionerPage extends StatelessWidget {
  final String resultText;
  final int totalScore;

  const HasilKuesionerPage({
    super.key,
    required this.resultText,
    required this.totalScore,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('resultTitle'.tr()),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        // Navigasi ke DashboardPage ketika tombol kembali di AppBar ditekan
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const DashboardPage()),
        // );

        // Navigator.pop(context);
        // },
        // ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${'totalScoreText'.tr()} $totalScore',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 42),
            Text(
              "resultOfScreening".tr(),
              style: const TextStyle(fontSize: 24),
            ),
            Text(
              resultText,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool('hipertensiChecked', false);
                    await prefs.setBool('diabetesChecked', false);
                    await prefs.setBool('kolesterolChecked', false);
                    await prefs.setBool('strokeChecked', false);
                    await prefs.setBool('jantungChecked', false);
                    // Navigator.of(context)
                    //     .pushNamed('/pageAwam'); // Navigasi ke '/pageAwam'

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RiwayatPenyakitPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: Text('retryButton'.tr(),
                      style: const TextStyle(fontSize: 24)),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    bool isAnyTrue = await checkAnySharedPreferencesTrue();
                    print("--> isAnyTrue = $isAnyTrue");
                    if (isAnyTrue) {
                      // Lakukan sesuatu jika ada salah satu boolean yang true
                      print(
                          '--> Ada salah satu atau beberapa boolean yang true...');

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PeringatanPage()),
                      );
                    } else {
                      // Lakukan sesuatu jika tidak ada satupun boolean yang true
                      print('--> Tidak ada boolean yang true.');
                      print("--> testing push button LANJUTKAN ");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RekomendasiPage()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('seeRecommendationsButton'.tr(),
                      style: const TextStyle(fontSize: 24)),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // await requestStoragePermission();
                    final pdf = pw.Document();
                    pdf.addPage(
                      pw.Page(
                        build: (pw.Context context) => pw.Center(
                          child: pw.Text('Hello World!'),
                        ),
                      ),
                    );
                    print("--> print");

                    // Simpan PDF ke penyimpanan perangkat
                    // final file = File('example.pdf');
                    // await file.writeAsBytes(await pdf.save());

                    // Tampilkan pesan sukses
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('PDF berhasil dibuat!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Unduh hasil'.tr(),
                      style: const TextStyle(fontSize: 24)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
