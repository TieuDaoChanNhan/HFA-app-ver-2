import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/entities/chatbot.dart';
import 'package:health_for_all/pages/chatbot/widget/view_image.dart';

Widget RightChat(ChatbotEntity item, BuildContext context) {
  return Container(
    padding: EdgeInsets.only(top: 10.w, left: 15.w, right: 15.w, bottom: 10.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
                minHeight: 40.w),
            child: Container(
                margin: EdgeInsets.only(right: 10.w, top: 0.w),
                padding: EdgeInsets.only(
                    top: 10.w, left: 10.w, right: 10.w, bottom: 10.w),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.all(Radius.circular(10.w))),
                child: item.image == ""
                    ? Text(
                        "${item.content}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${item.content}",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          GestureDetector(
                              onTap: () {
                                Get.to(() => ViewImage(imageUrl: item.image!));
                              },
                              child: Image.network(
                                item.image!,
                                width: MediaQuery.of(context).size.width * 0.7,
                              )),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ))),
      ],
    ),
  );
}
