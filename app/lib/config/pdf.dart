import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/health/diet_model.dart';
import '../models/health/workout_model.dart';
import 'app_config.dart';

Future<void> generateAndShareDietPDF(List<Meal> meals) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(16),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: meals.map((meal) {
              return pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 16),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "meals".tr(),
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue,
                      ),
                    ),
                    pw.Text(
                      AppConfig.user!.name,
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      meal.name,
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.grey800,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: meal.foods!.map((food) {
                        return pw.Padding(
                          padding: const pw.EdgeInsets.only(bottom: 4),
                          child: pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Expanded(child:
                              pw.Text(
                                "${food.name} - ${food.quantity} g",
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  color: PdfColors.black,
                                ),
                              )),
                              pw.SizedBox(width: 8),
                              pw.Text(
                                food.observation ?? '',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  color: PdfColors.black,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    pw.Divider(thickness: 1, color: PdfColors.grey400),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    ),
  );

  try {
    final tempDir = await getTemporaryDirectory();
    final file = File("${tempDir.path}/diet.pdf");
    await file.writeAsBytes(await pdf.save());

    final xFile = XFile(file.path);
    await Share.shareXFiles([xFile], text: "Check out my diet plan!");
  } catch (e) {
    AppConfig.getLogger().e("Error generating or sharing PDF: $e");
  }
}

Future<void> generateAndShareWorkoutPDF(List<Workout> workouts) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(16),
      build: (context) {
        return [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: workouts.map((workout) {
              return pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 16),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(height: 8),
                    pw.Text(
                      '${workout.name} - ${workout.exercises.length} exercicios',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.grey800,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: workout.exercises.map((exercise) {
                        return pw.Padding(
                          padding: const pw.EdgeInsets.only(bottom: 4),
                          child: pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Expanded(
                                child: pw.Text(
                                  "${exercise.name} - ${exercise.series ?? '-'}x${exercise.repetitions ?? '-'}",
                                  style: pw.TextStyle(
                                    fontSize: 12,
                                    color: PdfColors.black,
                                  ),
                                ),
                              ),
                              pw.SizedBox(width: 8),
                              pw.Text(
                                exercise.notes ?? '',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  color: PdfColors.black,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    pw.Divider(thickness: 1, color: PdfColors.grey400),
                  ],
                ),
              );
            }).toList(),
          ),
        ];
      },
    ),
  );

  try {
    final tempDir = await getTemporaryDirectory();
    final file = File("${tempDir.path}/workouts.pdf");
    await file.writeAsBytes(await pdf.save());

    final xFile = XFile(file.path);
    await Share.shareXFiles([xFile], text: "Check out my workout plan!");
  } catch (e) {
    AppConfig.getLogger().e("Error generating or sharing PDF: $e");
  }
}
