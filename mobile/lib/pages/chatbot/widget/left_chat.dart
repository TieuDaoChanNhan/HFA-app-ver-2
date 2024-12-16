import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_for_all/common/entities/chatbot.dart';

Widget LeftChat(
  ChatbotEntity item,
  BuildContext context,
) {
  return Container(
    padding: EdgeInsets.only(top: 10.w, left: 15.w, right: 15.w, bottom: 10.w),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const CircleAvatar(child: Icon(Icons.person)),
        const SizedBox(
          width: 8,
        ),
        ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 230.w, minHeight: 40.w),
            child: Container(
                margin: EdgeInsets.only(right: 10.w, top: 0.w),
                padding: EdgeInsets.only(top: 10.w, left: 10.w, right: 10.w),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Text(
                  "${item.content}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 16,
                  ),
                )))
      ],
    ),
  );
}
