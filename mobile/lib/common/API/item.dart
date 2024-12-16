class Item {
  Item._();
  static String getIconPath(int index) {
    const iconPaths = [
      'assets/images/huyet_ap.png',
      'assets/images/than_nhiet.png',
      'assets/images/duong_huyet.png',
      'assets/images/nhip_tim.png',
      'assets/images/spo2.png',
      'assets/images/hrv.png',
      'assets/images/ecg.png',
      'assets/images/can_nang.png',
      'assets/images/xet_nghiem_mau.png',
      'assets/images/axit_uric.png',
    ];
    return iconPaths[index];
  }

  static String getTitle(int index) {
    const titles = [
      'Huyết áp',
      'Thân nhiệt',
      'Đường huyết',
      'Nhịp tim',
      'SPO2',
      'HRV',
      'ECG - Điện tâm đồ',
      'Cân nặng',
      'PCG',
      'Axit Uric',
    ];
    return titles[index];
  }

  static String getUnit(int index) {
    const units = [
      'mmHg',
      '°C',
      'mg/dL',
      'lần/phút',
      '%',
      'ms',
      '--',
      'kg',
      '--',
      '--',
    ];
    return units[index];
  }
}
