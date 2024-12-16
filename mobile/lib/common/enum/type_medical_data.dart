enum TypeMedicalData {
  bloodPressure,
  temperature,
  bloodGlucose,
  heartRate,
  spo2,
  hrv,
  ecg,
  weight,
  pcg,
  axitUric
}

extension TypeMedicalDataExtension on TypeMedicalData {
  String get value {
    switch (this) {
      case TypeMedicalData.bloodPressure:
        return "Huyết áp";
      case TypeMedicalData.temperature:
        return "Nhiệt độ";
      case TypeMedicalData.bloodGlucose:
        return "Đường huyết";
      case TypeMedicalData.heartRate:
        return "Nhịp tim";
      case TypeMedicalData.spo2:
        return "SPO2";
      case TypeMedicalData.hrv:
        return "HRV";
      case TypeMedicalData.ecg:
        return "ECG - Điện tâm đồ";
      case TypeMedicalData.weight:
        return "Cân nặng";
      case TypeMedicalData.pcg:
        return "PCG";
      case TypeMedicalData.axitUric:
        return "Axit Uric";
    }
  }

  // Chuyển đổi từ chuỗi sang TypeMedicalData
  static TypeMedicalData fromString(String value) {
    switch (value) {
      case '0':
        return TypeMedicalData.bloodPressure;
      case '1':
        return TypeMedicalData.temperature;
      case '2':
        return TypeMedicalData.bloodGlucose;
      case '3':
        return TypeMedicalData.heartRate;
      case '4':
        return TypeMedicalData.spo2;
      case '5':
        return TypeMedicalData.hrv;
      case '6':
        return TypeMedicalData.ecg;
      case '7':
        return TypeMedicalData.weight;
      case '8':
        return TypeMedicalData.pcg;
      case '9':
        return TypeMedicalData.axitUric;
      default:
        throw ArgumentError('Invalid value for TypeMedicalData');
    }
  }
}
