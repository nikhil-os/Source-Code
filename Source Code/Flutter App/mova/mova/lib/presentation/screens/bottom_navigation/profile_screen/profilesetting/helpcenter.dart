// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/helpCenter/contactUs_module/bloc/contact_us_bloc.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/helpCenter/contactUs_module/contactUs_resources/contactUs_repository.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/helpCenter/faq_module/bloc/faq_bloc.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/helpCenter/faq_module/faq_resources/faq_repository.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/profile_screen/profilesetting/helpcentermodal/web_page.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/utils/theme/theme.dart';
import 'package:webtime_movie_ocean/presentation/widget/size_configuration.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../utils/app_class.dart';

class HelpCenterProfileScreen extends StatefulWidget {
  const HelpCenterProfileScreen({super.key});

  @override
  State<HelpCenterProfileScreen> createState() => _HelpCenterProfileScreenState();
}

class _HelpCenterProfileScreenState extends State<HelpCenterProfileScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  final tabs = ['FAQ', 'Contact Us'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);

    _tabController?.animation?.addListener(() {
      final value = _tabController?.animation?.value;
      if (value != null && value.round() != _tabController?.index) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {});
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: (getStorage.read('isDarkMode') == true) ? ColorValues.scaffoldBg : ColorValues.whiteColor,
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
                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.containerBg : Colors.grey.withValues(alpha: .1),
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
                StringValue.helpCenter.tr,
                style: GoogleFonts.urbanist(fontSize: 20, fontWeight: FontWeight.w600),
              ),

              const SizedBox(width: 24), // This balances the row
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: List.generate(tabs.length, (index) {
              final isSelected = _tabController?.index == index;
              return Expanded(
                child: InkWell(
                  onTap: () {
                    _tabController?.animateTo(index);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        tabs[index],
                        style: GoogleFonts.outfit(
                          color: isSelected ? Colors.redAccent : ColorValues.grayColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: isSelected ? ColorValues.redColor : ColorValues.darkModeThird,
                        ),
                      ).paddingSymmetric(horizontal: 10),
                    ],
                  ),
                ),
              );
            }),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                FAQ(),
                Contactus(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FAQ extends StatefulWidget {
  const FAQ({super.key});

  @override
  State<FAQ> createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  FocusNode textFiledFocus = FocusNode();
  Color color = (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeSecond : ColorValues.whiteColor;

  @override
  void initState() {
    super.initState();
    textFiledFocus.addListener(() {
      if (textFiledFocus.hasFocus) {
        setState(() {
          color = (getStorage.read('isDarkMode') == true) ? ColorValues.redColor.withValues(alpha: 0.08) : const Color(0xFFFCE7E9);
        });
      } else {
        color = (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeSecond : ColorValues.whiteColor;
      }
    });
  }

  bool? isOpen;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocProvider(
      create: (_) => FaqBloc(RepositoryProvider.of<FAQRepository>(context))..add(GetFAQ()),
      child: BlocListener<FaqBloc, FAQState>(
        listener: (context, state) {},
        child: BlocBuilder<FaqBloc, FAQState>(
          builder: (context, state) {
            if (state is FAQLoading) {
              return Shimmer.fromColors(
                highlightColor: (getStorage.read('isDarkMode') == true) ? Colors.white12 : Colors.grey.shade100,
                baseColor: (getStorage.read('isDarkMode') == true) ? Colors.white24 : Colors.grey.shade300,
                child: SizedBox(
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                      top: SizeConfig.blockSizeVertical * 2,
                    ),
                    itemCount: 10,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, i) {
                      return Container(
                        margin: const EdgeInsets.all(10),
                        height: 50,
                        width: Get.width / 0.5,
                        decoration: BoxDecoration(color: ColorValues.grayShimmer, borderRadius: BorderRadius.circular(18)),
                      );
                    },
                  ),
                ),
              );
            } else if (state is FAQLoaded) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: List.generate(
                          state.movieModal.faQ!.length,
                          (index) {
                            final isDark = getStorage.read('isDarkMode') == true;
                            final isView = Faqdata[index]["isView"];

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  Faqdata[index]["isView"] = !isView;
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 20),
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                                decoration: BoxDecoration(
                                  color: isDark ? ColorValues.containerBg : ColorValues.whiteColor,
                                  border: Border.all(color: ColorValues.borderColor),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Question + Icon Row
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            state.movieModal.faQ![index].question.toString(),
                                            style: GoogleFonts.outfit(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: isDark ? Colors.white : const Color(0xff1C1C1E),
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          isView ? Icons.expand_less : Icons.expand_more,
                                          color: isDark ? Colors.white : const Color(0xff1C1C1E),
                                        ),
                                      ],
                                    ),
                                    if (isView)
                                      Container(
                                        margin: const EdgeInsets.symmetric(vertical: 10),
                                        height: 1,
                                        color: isDark ? Colors.white.withValues(alpha: 0.1) : const Color(0xffE0E0E0),
                                      ),
                                    if (isView)
                                      Text(
                                        state.movieModal.faQ![index].answer.toString(),
                                        style: GoogleFonts.urbanist(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          height: 1.5,
                                          color: isDark ? ColorValues.grayColorText : const Color(0xff424242),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is FAQError) {
              return Container();
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class Contactus extends StatefulWidget {
  const Contactus({super.key});

  @override
  State<Contactus> createState() => _ContactusState();
}

class _ContactusState extends State<Contactus> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocProvider(
      create: (_) => ContactUsBloc(RepositoryProvider.of<ContactUsRepository>(context))..add(ContactUs()),
      child: BlocListener<ContactUsBloc, ContactUsState>(
        listener: (context, state) {},
        child: BlocBuilder<ContactUsBloc, ContactUsState>(
          builder: (context, state) {
            if (state is ContactUsLoading) {
              return Shimmer.fromColors(
                highlightColor: (getStorage.read('isDarkMode') == true) ? Colors.white12 : Colors.grey.shade100,
                baseColor: (getStorage.read('isDarkMode') == true) ? Colors.white24 : Colors.grey.shade300,
                child: SizedBox(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                    itemCount: 10,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, i) {
                      return Container(
                        margin: const EdgeInsets.all(10),
                        height: 50,
                        width: Get.width / 0.5,
                        decoration: BoxDecoration(color: ColorValues.grayShimmer, borderRadius: BorderRadius.circular(10)),
                      );
                    },
                  ),
                ),
              );
            } else if (state is ContactUsLoaded) {
              return Padding(
                padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 3, right: SizeConfig.blockSizeHorizontal * 2),
                child: ListView.builder(
                  itemCount: state.movieModal.contact!.length,
                  itemBuilder: (context, i) {
                    return InkWell(
                      onTap: () {
                        Get.to(
                          () => WebViewApp(
                            link: state.movieModal.contact![i].link.toString(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: ColorValues.borderColor),
                          color: (getStorage.read('isDarkMode') == true) ? ColorValues.containerBg : ColorValues.whiteColor,
                        ),
                        padding: const EdgeInsets.all(8),
                        margin: EdgeInsets.only(
                          top: SizeConfig.blockSizeVertical * 2,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: PreviewNetworkImage(
                                  id: state.movieModal.contact![i].id ?? "",
                                  image: state.movieModal.contact![i].image ?? "",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              state.movieModal.contact![i].name.toString(),
                              style: titalstyle8,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (state is ContactUsError) {
              return Container();
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class ExpansionItem {
  final String header;
  final String body;
  bool isExpanded;

  ExpansionItem({required this.body, required this.header, this.isExpanded = false});
}
