import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

List<RxBool> ontap = [
  false.obs,
  false.obs,
  false.obs,
];

List<String> avapath = [
  'https://s3-alpha-sig.figma.com/img/72f7/1c48/1924a99473c91bfdac585c9cc9c2bc58?Expires=1725235200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=JJRQyU2WPw3bxkBouF3GMVKTXeI8FJP6AWDZpHW~WI09zPcha1Xz7-Y1sK6gWGjKMCkE8y2FdGGMdEMJfVED0AO9yjx3Z1H~iTSI6MGuo2-9QRAeZ48ncVe22fnrO3Xiy2yVdcEfy~YQ0yMt02E8tlA0zye0kmxpw3HNXeoPYt0VDTfQblXn6tJ00AE3wp2aUzpVvXmXnOEq2PjlNUDPA457zIbZSVhoNjK-umG8zol-qVQXCktEDKUuY6DEfjiux9EcIszGQYHMTck8WVVrMh9xdIcdNOHg2~aF7POwxKLefX68Ig-CnbdKbiaosFdOZ4ZKsz3Hb-mrXBRPrRfNzw__',
  'https://s3-alpha-sig.figma.com/img/2381/ee7d/7fba196014b07dcd2bee7a8e541cc2be?Expires=1725235200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=mUzRkI30L~Y~LyTcyumFmQD5r3T4RFVhYnRx5z28-N3OwNWSwv66IgZQNSA-BDLH4CTv~RQIxfplOHQF3871WCOs7qxtjqTx4sPcZJqpCgzDoGOQhBBRwQSIF3w4bbFPmIjBjKOePNG1SxIhvbR2V9Cj~kRd0WqT5XO44TApFbKH0z8eEV5ePThAXUlldaAJmZS78GwfJFlkwN6ZnvnY3yinrtlobC5Zcal-iYqV3HO0YoJxcAdzJNQqD9SdSh8WMF-Eyk52EgVcH7ut-xkp-CkTnaXs4la2dyg5wq4JUVQfjIDnTF3eY1tnh3Qcq8fzf80OWUugAP~2LJ8vQKeZoQ__',
  'https://s3-alpha-sig.figma.com/img/d5fb/6bc1/39a3da5bc43ab0601942a4cf33722fa1?Expires=1725235200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=fUxId2OXCnVfAchhTfutfwyZyTKl1qtZoZD6LqBylRWsHb5wz7s6IR811m7WAa2b2RAYuLz90jLqb74gUDfyptlEUmfUFzkxhMBwDLlFfACld5N-iN~zY2ieT4fT3cFHsXhgn5MAF6k88rrPOjsyN~UWFkeJx53cuAKeN8Wm~lQmFsgpJBq790jcrrvXkxUiu5a-T7RddXELox31yRM584iVNbJiyYCmqDtMsWPxE3H8ohn3vP5C1N9TQRToeNhHomrC4FKK-83OTcNd2F6HY21-6ev52AyhZo3ZBIbaIfPE6qz4ZMx1AQ4V-RFtaFqXQenFxTZYFOyI~EkTnz0uhw__',
];

List<String> patientname = [
  'Nguyễn Văn A',
  'Nguyễn Thị B',
  'Trần Văn C',
];

List<String> gender = [
  'Nam',
  'Nữ',
  'Nam',
];

List<String> age = [
  '25',
  '70',
  '50',
];

List<String> time = [
  '6:00, 27/07',
  '6:00, 27/07',
  '6:00, 27/07',
];

List<String> people = [
  'Người nhà',
  'Bệnh nhân',
  'Bệnh nhân',
];

List<String> warning = [
  '1',
  '0',
  '0',
];

List<RxBool> chose = [
  false.obs,
  false.obs,
  false.obs,
  false.obs,
  false.obs,
  false.obs,
  false.obs,
  false.obs,
  false.obs,
  false.obs,
];

RxBool existed = false.obs;

int lengthofdata = 0;

List<String> doctor = [
  'Nguyễn Văn B',
];

List<RxBool> tapped = [
  false.obs,
  false.obs,
  false.obs,
  false.obs,
  false.obs,
];

List<int> ind = [
  0,
  1,
  2,
  3,
  8,
];

List<int> view = <int>[].obs;
