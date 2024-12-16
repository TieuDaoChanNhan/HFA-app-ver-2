// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class FindDevice extends StatefulWidget {
//   final bool complete_find_all;
//   const FindDevice({super.key, required this.complete_find_all});

//   @override
//   State<FindDevice> createState() => _FindDeviceState();
// }

// class _FindDeviceState extends State<FindDevice> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           header(),
//           const SizedBox(
//             height: 16,
//           ),
//           if (widget.complete_find_all == false) finding(),
//           list_founded_device(),
//           const SizedBox(
//             height: 45,
//           ),
//           build_button(),
//         ],
//       ),
//     );
//   }

//   Widget header() {
//     return Row(
//       children: [
//         Icon(
//           Icons.manage_search,
//           size: 32,
//           color: Theme.of(context).colorScheme.primary,
//         ),
//         const SizedBox(
//           width: 16,
//         ),
//         Text(
//           "Tìm kiếm thiết bị",
//           style: TextStyle(
//               fontSize: 24, color: Theme.of(context).colorScheme.onSurface),
//         ),
//       ],
//     );
//   }

//   Widget finding() {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset("assets/images/circular-indeterminate.png"),
//             const SizedBox(
//               width: 16,
//             ),
//             Text(
//               "Đang tìm kiếm",
//               style: TextStyle(
//                 color: Theme.of(context).colorScheme.outline,
//                 fontSize: 16,
//               ),
//             )
//           ],
//         ),
//         const SizedBox(
//           height: 16,
//         ),
//       ],
//     );
//   }

//   int number_device = 4;
//   List<String> name_device = [
//     "HFA-Portcare 01",
//     "HFA-Portcare 01",
//     "HFA-Portcare 01",
//     "HFA-Portcare 01",
//   ];
//   List<String> id_device = [
//     "9c3682a0-f27b-490d-b861-5e056d9a1234",
//     "9c3682a0-f27b-490d-b861-5e056d9a1234",
//     "9c3682a0-f27b-490d-b861-5e056d9a1234",
//     "9c3682a0-f27b-490d-b861-5e056d9a1234",
//   ];
//   List<double> distance = [
//     -60,
//     -60,
//     -60,
//     -60,
//   ];
//   Widget list_founded_device() {
//     return Container(
//       decoration: BoxDecoration(
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(4),
//             topRight: Radius.circular(4),
//           ),
//           border: Border.all(color: Theme.of(context).colorScheme.outline)),
//       width: MediaQuery.of(context).size.width - 75,
//       child: Column(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(4),
//                 topRight: Radius.circular(4),
//               ),
//               color: Theme.of(context).colorScheme.surfaceContainer,
//             ),
//             padding: const EdgeInsets.all(8),
//             child: Row(
//               children: [
//                 Text(
//                   "Kết quả tìm kiếm",
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.onSurface,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           for (int i = 0; i < number_device; i++)
//             founded_device(name_device[i], id_device[i], distance[i]),
//         ],
//       ),
//     );
//   }

//   Widget founded_device(String nameDevice, String idDevice, double distance) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//       child: Column(
//         children: [
//           const SizedBox(
//             height: 16,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         nameDevice,
//                         style: TextStyle(
//                           color: Theme.of(context).colorScheme.onSurface,
//                           fontSize: 14,
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 4,
//                       ),
//                       Text(
//                         idDevice,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Theme.of(context).colorScheme.onSurfaceVariant,
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//               Row(
//                 children: [
//                   Text(
//                     distance.toString(),
//                     style: TextStyle(
//                         fontSize: 12,
//                         color: Theme.of(context).colorScheme.onSurface),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget build_button() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         TextButton(
//           onPressed: () async {
//             Get.back();
//           },
//           child: Text(
//             'Đóng',
//             style: TextStyle(
//               fontSize: 14,
//               color: Theme.of(context).colorScheme.primary,
//             ),
//           ),
//         ),
//         const SizedBox(width: 16),
//         TextButton(
//           onPressed: () async {
//             Get.back();
//           },
//           child: Text(
//             'Xác nhận',
//             style: TextStyle(
//               fontSize: 14,
//               color: Theme.of(context).colorScheme.primary,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
