import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NutrisiPage extends StatelessWidget {
  final double _fontSize = 20;

  const NutrisiPage({super.key}); // Variabel untuk ukuran font

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('nutritionPageTitle'.tr()),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16,
                100), // Padding di bagian bawah untuk widget Peringatan
            children: [
              Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'nutritionIntro'.tr(),
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      _buildNutrisiItem('nutritionItemCreatinine'.tr()),
                      _buildNutrisiItem('nutritionItemLeucine'.tr()),
                      _buildNutrisiItem(
                          'nutritionItemBranchedChainAminoAcids'.tr()),
                      _buildNutrisiItem('nutritionItemOmega3'.tr()),
                      _buildNutrisiItem('nutritionItemVitaminD'.tr()),
                      _buildNutrisiItem('nutritionItemCalcium'.tr()),
                      _buildNutrisiItem('nutritionItemFruitsVegetables'.tr()),
                      Text(
                        "Konsumsi berbagai jenis buah dan sayuran yang mengandung vitamin anti-inflamasi, mineral, dan antioksidan.Konsumsi berbagai jenis buah dan sayuran Konsumsi berbagai jenis buah dan sayuran yang mengandung vitamin anti-inflamasi, mineral, dan antioksidan.",
                        style: TextStyle(
                          color: Colors
                              .transparent, // Mengatur warna menjadi transparan
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: true,
            child: Positioned(
              // Menempatkan widget Peringatan di bagian bawah layar
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Card(
                      elevation: 3,
                      color: Colors.red[100],
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'warningTitle'.tr(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            // SizedBox(height: 10),
                            Text(
                              'warningContent'.tr(),
                              style: TextStyle(fontSize: _fontSize),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method untuk membangun item nutrisi dengan ukuran font yang sama
  Widget _buildNutrisiItem(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: _fontSize),
    );
  }

  // kode cadangan:
  /*
  Widget _buildNutrisiItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0), // Indentasi kiri sebesar 20
      child: Text(
        '• $text', // Bullet di awal teks
        style: TextStyle(fontSize: _fontSize),
      ),
    );
  } */
}
