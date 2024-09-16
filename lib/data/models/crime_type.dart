import 'package:alerta_criminal/theme/custom_colors.dart';
import 'package:flutter/material.dart';

class CrimeType {
  final int id;
  final String label;
  final Image icon;
  final Color color;

  CrimeType(this.id, this.label, this.icon, this.color);
}

List<CrimeType> crimeTypes = [
    CrimeType(1, 'Assalto', Image.asset('assets/icon_crime_black50.png'), CustomColors().black50),
    CrimeType(2, 'Roubo de veículo', Image.asset('assets/icon_crime_black60.png'), CustomColors().black60),
    CrimeType(3, 'Tiroteio', Image.asset('assets/icon_crime_black90.png'), CustomColors().black90),
    CrimeType(4, 'Arrastão',  Image.asset('assets/icon_crime_black70.png'), CustomColors().black70),
    CrimeType(5, 'Furto', Image.asset('assets/icon_crime_black40.png'), CustomColors().black40),
    CrimeType(6, 'Vandalismo', Image.asset('assets/icon_crime_black30.png'), CustomColors().black30),
    CrimeType(7, 'Homicídio', Image.asset('assets/icon_crime_black100.png'), CustomColors().black100),
    CrimeType(8, 'Sequestro', Image.asset('assets/icon_crime_black80.png'), CustomColors().black80),
  ];