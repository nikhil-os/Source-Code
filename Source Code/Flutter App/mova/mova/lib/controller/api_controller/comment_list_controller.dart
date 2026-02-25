import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/commentList_api/comment_list_api_controller.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/commentList_api/comment_list_modal.dart';

/// commentsList Getx Controller ///
class CommentListController extends GetxController {
  var isLoading = true.obs;
  var commentsList = <Comment>[].obs;
  ScrollController scrollController = ScrollController();

  void scrollToTop() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  commentsListData(String movieId) async {
    try {
      isLoading(true);
      var commentsListData = await CommentListProvider.commentList(movieId);
      commentsList.value = commentsListData.comment?.reversed.toList() ?? [];
    } finally {
      isLoading(false);
    }
  }
}
