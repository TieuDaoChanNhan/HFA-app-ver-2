// import 'package:flutter/material.dart';

// class StatusDevice extends StatefulWidget {
//   final bool connected;
//   final String name_device;
//   const StatusDevice(
//       {super.key, required this.connected, required this.name_device});

//   @override
//   State<StatusDevice> createState() => _StatusDeviceState();
// }

// class _StatusDeviceState extends State<StatusDevice> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.surfaceContainer,
//               borderRadius: BorderRadius.circular(18),
//               boxShadow: const [
//                 BoxShadow(
//                   color: Color.fromRGBO(0, 0, 0, 0.3),
//                   spreadRadius: 0.6,
//                   blurRadius: 2,
//                   // offset: Offset(0, 3), // changes position of shadow
//                 )
//               ],
//             ),
//             child: widget.connected
//                 ? Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.developer_board,
//                             size: 32,
//                             color: Theme.of(context).colorScheme.primary,
//                           ),
//                           const SizedBox(
//                             width: 16,
//                           ),
//                           const Text(
//                             "Đang kết nối",
//                             style: TextStyle(
//                               color: Colors.green,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             widget.name_device,
//                             style: TextStyle(
//                               color: Theme.of(context)
//                                   .colorScheme
//                                   .onPrimaryContainer,
//                               fontSize: 14,
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 16,
//                           ),
//                           Icon(
//                             Icons.block,
//                             color: Theme.of(context).colorScheme.error,
//                             size: 24,
//                           ),
//                         ],
//                       ),
//                     ],
//                   )
//                 : Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.developer_board,
//                             size: 32,
//                             color: Theme.of(context).colorScheme.primary,
//                           ),
//                           const SizedBox(
//                             width: 16,
//                           ),
//                           Text(
//                             "Ngừng kết nối",
//                             style: TextStyle(
//                               color: Theme.of(context).colorScheme.outline,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             widget.name_device,
//                             style: TextStyle(
//                               color: Theme.of(context).colorScheme.secondary,
//                               fontSize: 14,
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 16,
//                           ),
//                           Icon(
//                             Icons.bolt,
//                             color:
//                                 Theme.of(context).colorScheme.onSurfaceVariant,
//                             size: 24,
//                           )
//                         ],
//                       ),
//                     ],
//                   )),
//         const SizedBox(
//           height: 12,
//         ),
//       ],
//     );
//   }
// }
