import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:image_picker/image_picker.dart';

class Unread {
  static List<String> avapath = [
    'https://i.pinimg.com/564x/7b/03/30/7b0330944d61259423810d2169ef4f16.jpg',
    'https://i.pinimg.com/564x/15/82/9d/15829d026839a7c399b361d1c9f5f838.jpg',
    'https://i.pinimg.com/736x/0a/cc/a9/0acca97d9783ea7f4249b514e6982d1e.jpg',
  ];

  static List<String> person = [
    'Người nhà',
    'Người nhà',
    'Bệnh nhân',
  ];

  static List<String> users = ['Nguyễn Thị D', 'Đặng Văn B', 'Trần Thị C'];

  static List<String> gender = ['Nữ', 'Nam', 'Nữ'];

  static List<String> age = ['25', '30', '56'];

  static List<String> doctors = ['Nguyễn Văn A', 'Nguyễn Văn B', 'Trần Văn C'];

  static List<String> notifications = [
    'Với chỉ số như hiện tại có nguy cơ nhồi máu cơ tim. Đề nghị tới bệnh viện khám lại',
    'Với chỉ số như hiện tại có nguy cơ nhồi máu cơ tim. Đề nghị tới bệnh viện khám lại',
    'Với chỉ số như hiện tại có nguy cơ nhồi máu cơ tim. Đề nghị tới bệnh viện khám lại'
  ];

  static List<String> timeDate = [
    '06:00, 29/07/2024',
    '06:00, 29/07/2024',
    '06:00, 29/07/2024',
  ];

  static List<String> attachments = ['1', '2', '0'];

  static List<bool> isAttached = [true, true, false];

  static List<RxBool> isImportant = [false.obs, false.obs, false.obs].obs;

  static List<List<String>> titles = [
    ['0', '1', '8'],
    ['0', '1', '8'],
    ['0', '1', '8'],
  ];

  static List<List<String>> times = [
    ['09:00', '09:00', '09:00'],
    ['09:00', '09:00', '09:00'],
    ['09:00', '09:00', '09:00'],
  ];

  static List<List<String>> values = [
    ['120/80', '36', 'XN'],
    ['120/80', '36', 'XN'],
    ['120/80', '36', 'XN'],
  ];

  static List<List<XFile>> files = [
    [],
    [],
    [],
  ];
}

class Important {
  static List<String> avapath = [
    'https://i.pinimg.com/564x/7b/03/30/7b0330944d61259423810d2169ef4f16.jpg',
    'https://i.pinimg.com/564x/15/82/9d/15829d026839a7c399b361d1c9f5f838.jpg',
    'https://i.pinimg.com/736x/0a/cc/a9/0acca97d9783ea7f4249b514e6982d1e.jpg',
    'https://i.pinimg.com/564x/7b/03/30/7b0330944d61259423810d2169ef4f16.jpg',
    'https://i.pinimg.com/564x/15/82/9d/15829d026839a7c399b361d1c9f5f838.jpg',
  ];

  static List<String> person = [
    'Người nhà',
    'Người nhà',
    'Bệnh nhân',
    'Người nhà',
    'Bệnh nhân',
  ];

  static List<String> users = [
    'Nguyễn Thị D',
    'Đặng Văn B',
    'Trần Thị C',
    'Cao Thị E',
    'Nguyễn Cao Kỳ'
  ];

  static List<String> gender = ['Nữ', 'Nam', 'Nữ', 'Nữ', 'Nam'];

  static List<String> age = ['25', '30', '56', '45', '70'];

  static List<String> notifications = [
    'Với chỉ số như hiện tại có nguy cơ nhồi máu cơ tim. Đề nghị tới bệnh viện khám lại',
    'Với chỉ số như hiện tại có nguy cơ nhồi máu cơ tim. Đề nghị tới bệnh viện khám lại',
    'Với chỉ số như hiện tại có nguy cơ nhồi máu cơ tim. Đề nghị tới bệnh viện khám lại',
    'Với chỉ số như hiện tại có nguy cơ nhồi máu cơ tim. Đề nghị tới bệnh viện khám lại',
    'Với chỉ số như hiện tại có nguy cơ nhồi máu cơ tim. Đề nghị tới bệnh viện khám lại',
  ];

  static List<String> doctors = [
    'Nguyễn Văn A',
    'Nguyễn Thị B',
    'Trần Văn C',
    'Lê Thị D',
    'Đặng Văn E'
  ];

  static List<String> timeDate = [
    '06:00, 29/07/2024',
    '06:00, 29/07/2024',
    '06:00, 29/07/2024',
    '06:00, 29/07/2024',
    '06:00, 29/07/2024',
  ];

  static List<String> attachments = ['1', '2', '0', '0', '3'];
  static List<bool> isAttached = [true, true, false, false, true];
  static List<RxBool> isImportant = [
    true.obs,
    true.obs,
    true.obs,
    true.obs,
    true.obs,
  ].obs;

  static List<List<String>> titles = [
    ['0', '1', '8'],
    ['0', '1', '8'],
    ['0', '1', '8'],
    ['0', '1', '8'],
    ['0', '1', '8'],
  ];

  static List<List<String>> times = [
    ['09:00', '09:00', '09:00'],
    ['09:00', '09:00', '09:00'],
    ['09:00', '09:00', '09:00'],
    ['09:00', '09:00', '09:00'],
    ['09:00', '09:00', '09:00'],
  ];

  static List<List<String>> values = [
    ['120/80', '36', 'XN'],
    ['120/80', '36', 'XN'],
    ['120/80', '36', 'XN'],
    ['120/80', '36', 'XN'],
    ['120/80', '36', 'XN'],
  ];

  static List<List<XFile>> files = [
    [],
    [],
    [],
  ];
}

class Seen {
  static List<String> avapath = [
    'https://i.pinimg.com/564x/7b/03/30/7b0330944d61259423810d2169ef4f16.jpg',
    'https://i.pinimg.com/564x/15/82/9d/15829d026839a7c399b361d1c9f5f838.jpg',
    'https://i.pinimg.com/736x/0a/cc/a9/0acca97d9783ea7f4249b514e6982d1e.jpg',
  ];

  static List<String> person = [
    'Người nhà',
    'Người nhà',
    'Bệnh nhân',
  ];

  static List<String> users = ['Nguyễn Thị D', 'Đặng Văn B', 'Trần Thị C'];

  static List<String> gender = ['Nữ', 'Nam', 'Nữ'];

  static List<String> age = ['25', '30', '56'];

  static List<String> notifications = [
    'Với chỉ số như hiện tại có nguy cơ nhồi máu cơ tim. Đề nghị tới bệnh viện khám lại',
    'Với chỉ số như hiện tại có nguy cơ nhồi máu cơ tim. Đề nghị tới bệnh viện khám lại',
    'Với chỉ số như hiện tại có nguy cơ nhồi máu cơ tim. Đề nghị tới bệnh viện khám lại',
  ];

  static List<String> doctors = ['Trần Văn C', 'Lê Thị D', 'Đặng Văn E'];

  static List<String> timeDate = [
    '06:00, 29/07/2024',
    '06:00, 29/07/2024',
    '06:00, 29/07/2024',
  ];

  static List<String> attachments = ['0', '0', '3'];
  static List<bool> isAttached = [false, false, true];
  static List<RxBool> isImportant = [
    false.obs,
    false.obs,
    false.obs,
  ].obs;

  static List<List<String>> titles = [
    ['0', '1', '8'],
    ['0', '1', '8'],
    ['0', '1', '8'],
  ];

  static List<List<String>> times = [
    ['09:00', '09:00', '09:00'],
    ['09:00', '09:00', '09:00'],
    ['09:00', '09:00', '09:00'],
  ];

  static List<List<String>> values = [
    ['120/80', '36', 'XN'],
    ['120/80', '36', 'XN'],
    ['120/80', '36', 'XN'],
  ];

  static List<List<XFile>> files = [
    [],
    [],
    [],
  ];
}
