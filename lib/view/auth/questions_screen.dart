import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lootfat_owner/utils/colors.dart';
import 'package:lootfat_owner/view/widgets/app_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api_provider/auth_api.dart';
import '../../model/question_list_model.dart';
import '../../utils/utils.dart';
import '../dashboard/bottom_bar_screen.dart';
import '../widgets/loading_overlay.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  int currentIndex = 0;
  bool isNavButton = false;
  bool isBackButton = false;
  List<QuestionModel> questionList = [];
  bool isLoading = true;

  void initState() {
    questionListApi();
    super.initState();
  }

  questionListApi() {
    try {
      setState(() {
        isLoading = true;
      });
      AuthAPI.questionList().then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          var res = json.decode(response.body);
          if (res['data'].isEmpty) {
            setState(() => isLoading = false);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const BottomBarScreen(),
              ),
            );
          } else {
            setState(() {
              res['data'].forEach((json) {
                questionList.add(
                  QuestionModel.fromJson(
                    json,
                  ),
                );
              });
              isLoading = false;
            });
          }
        } else {
          setState(() => isLoading = false);
          Utils.errorHandling(response);
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  questionAnswerApi(List dataList) {
    try {
      LoadingOverlay.of(context).show();
      AuthAPI.questionAnswer(dataList).then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          storePreferences(true);
          LoadingOverlay.of(context).hide();
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              isDismissible: false,
              enableDrag: false,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(25),
                  topStart: Radius.circular(25),
                ),
              ),
              builder: (context) => buildSheet(context));
        } else {
          LoadingOverlay.of(context).hide();
          Utils.errorHandling(response);
        }
      });
    } catch (e) {
      LoadingOverlay.of(context).hide();
    }
  }

  Future storePreferences(isQuestionsFilled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('isQuestionsFilled', isQuestionsFilled);
  }

  CarouselController controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isLoading == true
          ? AppLoader()
          : SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: questionList
                              .asMap()
                              .map(
                                (i, value) => MapEntry(
                                  i,
                                  AnimatedContainer(
                                    width: 40,
                                    duration: const Duration(milliseconds: 200),
                                    height: 6,
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: currentIndex == i ? AppColors.main : AppColors.white,
                                    ),
                                  ),
                                ),
                              )
                              .values
                              .toList(),
                        ),
                        const SizedBox(height: 8),
                        Text("${currentIndex + 1} of ${questionList.length}"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Select an answer",
                      style: TextStyle(
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: CarouselSlider.builder(
                      itemCount: questionList.length,
                      carouselController: controller,
                      itemBuilder: (contect, i, index) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              questionList[i].question,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 30),
                            ...questionList[i]
                                .options
                                .asMap()
                                .map((key, value) => MapEntry(
                                      key,
                                      Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (questionList[i].answers.contains(value.id)) {
                                                setState(() {
                                                  questionList[i].answers.remove(value.id);
                                                });
                                              } else {
                                                setState(() {
                                                  questionList[i].answers.add(value.id);
                                                });
                                              }
                                            },
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                AnimatedContainer(
                                                  height: 40,
                                                  duration: const Duration(
                                                    milliseconds: 400,
                                                  ),
                                                  margin: const EdgeInsets.only(
                                                    left: 4,
                                                    top: 4,
                                                  ),
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        questionList[i].answers.contains(value.id)
                                                            ? AppColors.main
                                                            : Colors.transparent,
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                ),
                                                Container(
                                                  height: 40,
                                                  margin: const EdgeInsets.only(right: 4),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.white,
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      const SizedBox(width: 10),
                                                      questionList[i].answers.contains(value.id)
                                                          ? Container(
                                                              width: 25,
                                                              height: 25,
                                                              alignment: Alignment.center,
                                                              decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.circular(100),
                                                                color: AppColors.main,
                                                              ),
                                                              child: Text(
                                                                (questionList[i]
                                                                            .answers
                                                                            .indexOf(value.id) +
                                                                        1)
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    fontSize: 13,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: AppColors.white),
                                                              ),
                                                            )
                                                          : Icon(
                                                              questionList[i]
                                                                      .answers
                                                                      .contains(value.id)
                                                                  ? Icons.check_circle_rounded
                                                                  : Icons.circle_outlined,
                                                              color: AppColors.main,
                                                              size: 25,
                                                            ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: Text(
                                                          value.option.toString(),
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            color: AppColors.textLight,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ))
                                .values
                                .toList(),
                          ],
                        ),
                      ),
                      options: CarouselOptions(
                        viewportFraction: 1,
                        height: double.infinity,
                        enableInfiniteScroll: false,
                        scrollPhysics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (i, reason) => setState(() => currentIndex = i),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: currentIndex != 0 && isBackButton == true
                              ? TextButton(
                                  onPressed: () {
                                    controller.previousPage();
                                  },
                                  style: ButtonStyle(
                                    overlayColor: MaterialStateColor.resolveWith(
                                      (states) => AppColors.shadow,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Back",
                                      style: TextStyle(
                                        color: AppColors.main,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (questionList[currentIndex].answers.isEmpty) {
                                Utils.toastMessage('Please, select the answer...');
                              } else {
                                if (currentIndex == (questionList.length - 1)) {
                                  List dataList = [];
                                  questionList.forEach((element) {
                                    dataList.add(element.toJson());
                                  });
                                  // API CALL
                                  questionAnswerApi(dataList);
                                } else {
                                  controller.nextPage();
                                  setState(() {
                                    isBackButton = true;
                                  });
                                }
                              }
                            },
                            child: const Center(
                              child: Text(
                                'Next',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildSheet(context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 14),
          Text(
            'Thank you for your\nanswer!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.main),
          ),
          SizedBox(height: 14),
          Text(
            'We have analyzed your answers and selected the offer program ',
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: 13, letterSpacing: 0.2, height: 1.4, color: Color(0xff8D93A3)),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BottomBarScreen(),
                ),
              );
            },
            child: const Center(
              child: Text(
                'Continue',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
