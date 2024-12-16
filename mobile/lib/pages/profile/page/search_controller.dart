import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchingController extends GetxController {
  var searchResults = <Map<String, dynamic>>[].obs;
  var hasText = false.obs;

  void onTextChanged(String text) {
    hasText.value = text.isNotEmpty;
    log(hasText.toString());
    if (hasText.value) {
      performSearch(text);
    } else {
      searchResults.clear();
    }
  }

  void performSearch(String query) async {
    try {
      EasyLoading.show(status: "Đang xử lí...");
      log('Performing search with query: $query');

      final results = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: query)
          .get();

      searchResults.value = results.docs.map((doc) => doc.data()).toList();

      log('Search results: $searchResults');
    } catch (e) {
      log('Error performing search: $e');
    }
    finally{
      EasyLoading.dismiss();
    }
  }
}
