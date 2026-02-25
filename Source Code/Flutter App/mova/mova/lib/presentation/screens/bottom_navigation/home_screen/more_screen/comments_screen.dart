// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/createComments_api/createComments_api_controller.dart';
import 'package:webtime_movie_ocean/controller/api_controller/comment_list_controller.dart';
import 'package:webtime_movie_ocean/controller/api_controller/movieDetailsController.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_class.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/utils/utils.dart';
import 'package:webtime_movie_ocean/presentation/widget/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CommentsScreen extends StatefulWidget {
  String movieId;
  int comments;

  CommentsScreen({
    super.key,
    required this.movieId,
    required this.comments,
  });

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  TextEditingController commentController = TextEditingController();
  CommentListController allCommentsList = Get.put(CommentListController());
  movieDetailsController movieAllDetails = Get.put(movieDetailsController());

  bool isButtonDisabled = true;

  void validateField(text) {
    if (commentController.text.isEmpty || commentController.text.isBlank == true) {
      setState(() {
        isButtonDisabled = true;
      });
    } else {
      setState(() {
        isButtonDisabled = false;
      });
    }
  }

  @override
  void initState() {
    allCommentsList.commentsListData(widget.movieId);
    commentController.addListener(() {
      validateField(commentController.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final createComment = Provider.of<CreateCommentProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: (getStorage.read('isDarkMode') == true) ? ColorValues.scaffoldBg : ColorValues.whiteColor,
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          decoration: BoxDecoration(
            color: (getStorage.read('isDarkMode') == true) ? ColorValues.appBarColor : ColorValues.whiteColor,
          ),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 5,
            left: 20,
            right: 16,
            bottom: 16,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.smallContainerBg : Colors.grey.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(11),
                  child: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                "${allCommentsList.commentsList.length} ${StringValue.comments.tr}",
                style: GoogleFonts.urbanist(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 24),
            ],
          ),
        ),
      ),

      /// Get All Comments of Movie ///
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return false;
        },
        child: SafeArea(
          child: SizedBox(
            height: Get.height,
            width: Get.width,
            child: Column(
              children: [
                Expanded(
                  child: Obx(() {
                    if (allCommentsList.isLoading.value) {
                      return commentsShimmer();
                    }
                    return ListView.builder(
                      padding: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 1.5,
                        left: SizeConfig.blockSizeHorizontal * 5,
                        right: SizeConfig.blockSizeHorizontal * 5,
                      ),
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      reverse: false,
                      controller: allCommentsList.scrollController,
                      itemCount: allCommentsList.commentsList.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                  child: (getStorage.read("updatedNewDp")?.isEmpty ?? true)
                                      ? (allCommentsList.commentsList[i].userImage == null
                                          ? Image.asset(
                                              AssetValues.noProfile,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              allCommentsList.commentsList[i].userImage ?? "",
                                              fit: BoxFit.cover,
                                            ))
                                      : Obx(
                                          () => ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: PreviewNetworkImage(
                                              id: allCommentsList.commentsList[i].id ?? "",
                                              image: allCommentsList.commentsList[i].userImage ?? "",
                                            ),
                                          ),
                                        ),
                                ),
                                SizedBox(
                                  width: SizeConfig.blockSizeHorizontal * 2,
                                ),
                                Text(
                                  allCommentsList.commentsList[i].fullName.toString().capitalizeFirst ?? "",
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                PopupMenuButton<String>(
                                  offset: const Offset(0, 40),
                                  color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeSecond : ColorValues.whiteColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  icon: ImageIcon(
                                    const AssetImage(
                                      IconAssetValues.moreCircle,
                                    ),
                                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.darkModeSecond,
                                  ),
                                  onSelected: (String value) {
                                    if (value == "Report") {
                                      openReportBottomSheet();
                                    } else if (value == "Block") {
                                      openBlockBottomSheet();
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return <String>["Report", "Block"].map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: Text(
                                          choice,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      );
                                    }).toList();
                                  },
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: Get.width / 1.15,
                                  child: Text(
                                    allCommentsList.commentsList[i].comment?.capitalizeFirst ?? "",
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 10,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: SizeConfig.blockSizeVertical * 1),
                            Row(
                              children: [
                                Text(
                                  allCommentsList.commentsList[i].time.toString(),
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.grayColor : ColorValues.grayColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Divider(
                              color: (getStorage.read('isDarkMode') == true)
                                  ? ColorValues.dividerColor
                                  : ColorValues.darkModeThird.withValues(alpha: 0.10),
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    );
                  }),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.appBarColor : ColorValues.darkModeThird.withValues(alpha: 0.05),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(17),
                    ),
                    border: Border(
                      top: BorderSide(
                        color: (getStorage.read('isDarkMode') == true) ? ColorValues.dividerColor : ColorValues.dividerColor.withValues(alpha: 0.20),
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        height: 56,
                        padding: const EdgeInsets.only(left: 20),
                        margin: const EdgeInsets.only(left: 15),
                        width: Get.width - 95,
                        decoration: BoxDecoration(
                          color: (getStorage.read('isDarkMode') == true)
                              ? ColorValues.detailContainer
                              : ColorValues.darkModeThird.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: (getStorage.read('isDarkMode') == true) ? ColorValues.borderColor : ColorValues.redColor,
                          ),
                        ),
                        child: TextFormField(
                          controller: commentController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 100,
                          minLines: 1,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(bottom: 4),
                            border: InputBorder.none,
                            hintText: StringValue.addComments.tr,
                            hintStyle: GoogleFonts.outfit(color: ColorValues.grayText, fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      const Spacer(),
                      AbsorbPointer(
                        absorbing: !enabled,
                        child: InkWell(
                          onTap: isButtonDisabled
                              ? () {}
                              : () async {
                                  AppUtils.showLog('buttonClicked');
                                  setState(() {
                                    enabled = false;
                                    Future.delayed(const Duration(seconds: 1), () {
                                      setState(() {
                                        enabled = true;
                                      });
                                    });
                                  });
                                  FocusScope.of(context).unfocus();
                                  await createComment.createComment(widget.movieId, commentController.text);
                                  commentController.clear();
                                  movieAllDetails.allDetails(widget.movieId);

                                  allCommentsList.scrollToTop();
                                },
                          child: const CircleAvatar(
                            radius: 25,
                            backgroundColor: ColorValues.redColor,
                            child: ImageIcon(
                              AssetImage(
                                IconAssetValues.boldSend,
                              ),
                              color: ColorValues.whiteColor,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void openReportBottomSheet() {
    Get.bottomSheet(
      backgroundColor: (getStorage.read('isDarkMode') == true) ? ColorValues.dividerColor : ColorValues.whiteColor,
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: Get.height * 0.55,
        decoration: BoxDecoration(
          color: (getStorage.read('isDarkMode') == true) ? ColorValues.dividerColor : ColorValues.whiteColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(40),
            topLeft: Radius.circular(40),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: Colors.grey.shade400,
              ),
            ),
            Text(
              StringValue.report.tr,
              style: GoogleFonts.outfit(
                fontSize: 24,
                color: Colors.red,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Divider(color: Colors.grey),
            const Icon(Icons.report_problem, size: 70, color: Colors.red),
            Text(
              StringValue.wantToReport.tr,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    height: 50,
                    width: Get.width / 2.5,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: (getStorage.read('isDarkMode') == true) ? const Color(0xff35383F) : ColorValues.redBoxColor,
                    ),
                    child: Text(
                      StringValue.cancel.tr,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.redColor,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Get.back();
                    _showLoader();

                    await Future.delayed(const Duration(seconds: 2));

                    Get.back();
                    Fluttertoast.showToast(msg: "Report submitted successfully");
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: Get.width / 2.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.red,
                    ),
                    child: Text(
                      StringValue.report.tr,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void openBlockBottomSheet() {
    Get.bottomSheet(
      backgroundColor: (getStorage.read('isDarkMode') == true) ? ColorValues.dividerColor : ColorValues.whiteColor,
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: Get.height * 0.55,
        decoration: BoxDecoration(
          color: (getStorage.read('isDarkMode') == true) ? ColorValues.dividerColor : ColorValues.whiteColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(40),
            topLeft: Radius.circular(40),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: Colors.grey.shade400,
              ),
            ),
            Text(
              StringValue.block.tr,
              style: GoogleFonts.outfit(
                fontSize: 24,
                color: Colors.red,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Divider(color: Colors.grey),
            const Icon(Icons.block, size: 70, color: Colors.red),
            Text(
              StringValue.wantToBlock.tr,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    height: 50,
                    width: Get.width / 2.5,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: (getStorage.read('isDarkMode') == true) ? const Color(0xff35383F) : ColorValues.redBoxColor,
                    ),
                    child: Text(
                      StringValue.cancel.tr,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.redColor,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Get.back();
                    _showLoader();

                    await Future.delayed(const Duration(seconds: 2));

                    Get.back();
                    Fluttertoast.showToast(msg: "Blocked successfully");
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: Get.width / 2.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.red,
                    ),
                    child: Text(
                      StringValue.block.tr,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLoader() {
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Colors.red)),
      barrierDismissible: false,
    );
  }

  Shimmer commentsShimmer() {
    return Shimmer.fromColors(
      highlightColor: (getStorage.read('isDarkMode') == true) ? Colors.white12 : Colors.grey.shade100,
      baseColor: (getStorage.read('isDarkMode') == true) ? Colors.white24 : Colors.grey.shade300,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 4),
        itemCount: 10,
        itemBuilder: (BuildContext context, int i) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(),
                  const SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: 60,
                    height: 20,
                    alignment: Alignment.centerLeft,
                    color: (getStorage.read('isDarkMode') == true) ? Colors.white12 : Colors.grey.shade100,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 120,
                height: 20,
                alignment: Alignment.centerLeft,
                color: (getStorage.read('isDarkMode') == true) ? Colors.white12 : Colors.grey.shade100,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 80,
                height: 20,
                alignment: Alignment.centerLeft,
                color: (getStorage.read('isDarkMode') == true) ? Colors.white12 : Colors.grey.shade100,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          );
        },
      ),
    );
  }
}
