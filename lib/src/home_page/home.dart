import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_diseases_detection_using_deep_learning/constants/constants.dart';
import 'package:plant_diseases_detection_using_deep_learning/services/classify.dart';
import 'package:plant_diseases_detection_using_deep_learning/services/disease_provider.dart';
import 'package:plant_diseases_detection_using_deep_learning/services/hive_database.dart';
import 'package:plant_diseases_detection_using_deep_learning/src/home_page/components/history.dart';
import 'package:plant_diseases_detection_using_deep_learning/src/home_page/components/instructions.dart';
import 'package:plant_diseases_detection_using_deep_learning/src/home_page/components/titlesection.dart';
import 'package:plant_diseases_detection_using_deep_learning/src/home_page/models/disease_model.dart';
import 'package:plant_diseases_detection_using_deep_learning/src/suggestions_page/suggestions.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get disease from provider
    final _diseaseService = Provider.of<DiseaseService>(context);

    // Hive service
    HiveService _hiveService = HiveService();

    // Data
    Size size = MediaQuery.of(context).size;
    final Classifier classifier = Classifier();
    late Disease _disease;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SpeedDial(
        icon: Icons.camera_alt,
        spacing: 10,
        children: [
          SpeedDialChild(
            child: const FaIcon(
              FontAwesomeIcons.file,
              color: kWhite,
            ),
            label: "Choose image",
            backgroundColor: kMain,
            onTap: () async {
              late double _confidence;
              await classifier.getDisease(ImageSource.gallery).then((value) {
                _disease = Disease(
                    name: value![0]["label"],
                    imagePath: classifier.imageFile.path);

                _confidence = value[0]['confidence'];
              });
              // Check confidence
              if (_confidence > 0.8) {
                // Set disease for Disease Service
                _diseaseService.setDiseaseValue(_disease);

                // Save disease
               // _hiveService.addDisease(_disease);

                Navigator.restorablePushNamed(
                  context,
                  Suggestions.routeName,
                );
              } else {
                // Display unsure message

              }
            },
          ),
          SpeedDialChild(
            child: const FaIcon(
              FontAwesomeIcons.camera,
              color: kWhite,
            ),
            label: "Take photo",
            backgroundColor: kMain,
            onTap: () async {
              late double _confidence;

              await classifier.getDisease(ImageSource.camera).then((value) {
                _disease = Disease(
                    name: value![0]["label"],
                    imagePath: classifier.imageFile.path);

                _confidence = value[0]['confidence'];
              });

              // Check confidence
              if (_confidence > 0.8) {
                // Set disease for Disease Service
                _diseaseService.setDiseaseValue(_disease);

                // Save disease
                _hiveService.addDisease(_disease);

                Navigator.restorablePushNamed(
                  context,
                  Suggestions.routeName,
                );
              } else {
                // Display unsure message

              }
            },
          ),
        ],
      ),
      appBar: AppBar(
        title: Text('Plant Diseases Detection',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),),
      ),
      body: Container(
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //       image: AssetImage('assets/images/bg.jpg'), fit: BoxFit.cover),
        // ),
        child: CustomScrollView(
          slivers: [
            TitleSection('Select Image', size.height * 0.066),
            InstructionsSection(size),
            // TitleSection('Your History', size.height * 0.066),
            // HistorySection(size, context, _diseaseService)
          ],
        ),
      ),
    );
  }
}
