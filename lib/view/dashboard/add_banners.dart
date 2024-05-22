import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lootfat_owner/api_provider/banner_api.dart';
import 'package:lootfat_owner/model/banner_model.dart';
import 'package:lootfat_owner/utils/colors.dart';
import 'package:lootfat_owner/utils/utils.dart';
import 'package:lootfat_owner/view/widgets/app_text_field.dart';
import 'package:lootfat_owner/view/widgets/loading_overlay.dart';

class CreateBannerScreen extends StatefulWidget {
  final BannerViewModel? data;
  const CreateBannerScreen({super.key, required this.data});

  @override
  State<CreateBannerScreen> createState() => _CreateBannerScreenState();
}

class _CreateBannerScreenState extends State<CreateBannerScreen> {
  final ImagePicker _picker = ImagePicker();
  File? bannerImage;
  String title = "", description = "";
  String bannerNetworkImg = "";
  String titleError = "";
  String descriptionError = "";
  TextEditingController startdate = TextEditingController(text: "");
  String startDateError = "";
  TextEditingController endDate = TextEditingController(text: "");
  String endDateError = "";

  @override
  void initState() {
    if (widget.data != null) {
      setState(() {
        title = widget.data!.title;
        description = widget.data!.description;
        bannerNetworkImg = widget.data!.bannerImage;
        startdate.text = DateFormat('yyyy-MM-dd').format(widget.data!.fromDate);
        endDate.text = DateFormat('yyyy-MM-dd').format(widget.data!.toDate);
      });
    }
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Publish Banner"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  try {
                    final XFile? pickedFile = await _picker.pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 1600,
                      maxHeight: 800,
                      imageQuality: 80,
                    );
                    if (pickedFile != null) {
                      CroppedFile? croppedFile = await ImageCropper().cropImage(
                        sourcePath: pickedFile.path,
                        aspectRatio: CropAspectRatio(ratioX: 2, ratioY: 1),
                        uiSettings: [
                          AndroidUiSettings(
                            toolbarTitle: 'Set Banner View',
                            toolbarColor: AppColors.main,
                            toolbarWidgetColor: Colors.white,
                            initAspectRatio: CropAspectRatioPreset.original,
                            lockAspectRatio: true,
                          ),
                          IOSUiSettings(
                            title: 'Set Banner View',
                          ),
                        ],
                      );
                      if (croppedFile != null) {
                        setState(() {
                          bannerImage = File(croppedFile.path);
                        });
                      }
                      // setState(() {
                      //   bannerImage = File(pickedFile.path);
                      // });
                    }
                  } catch (e) {
                    Utils.toastMessage("$e");
                  }
                },
                child: bannerImage == null
                    ? bannerNetworkImg.isNotEmpty
                        ? ClipRRect(
                            child: Image.network(
                              bannerNetworkImg,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.fitWidth,
                              loadingBuilder:
                                  (context, child, loadingProgress) =>
                                      Utils.loadingBuilder(
                                context,
                                child,
                                loadingProgress,
                              ),
                              errorBuilder: (context, child, loadingProgress) =>
                                  Utils.errorBuilder(
                                context,
                                child,
                                loadingProgress,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          )
                        : Container(
                            height: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.black12,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.upload),
                                  SizedBox(height: 5),
                                  Text(
                                    "Upload Image",
                                  ),
                                ],
                              ),
                            ),
                          )
                    : ClipRRect(
                        child: Image.file(
                          bannerImage!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
              ),
              SizedBox(height: 10),
              const Text(
                "Title*",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              AppTextField(
                hintText: "Enter your title",
                errorMessage: titleError,
                initialValue: title,
                onChange: (val) {
                  setState(() {
                    title = val;
                    titleError = '';
                  });
                },
              ),
              SizedBox(height: 10),
              const Text(
                "Description*",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              AppTextField(
                hintText: "Enter banner description",
                errorMessage: descriptionError,
                initialValue: description,
                onChange: (val) {
                  setState(() {
                    description = val;
                    descriptionError = '';
                  });
                },
              ),
              SizedBox(height: 10),
              const Text(
                "Start Date*",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              AppTextField(
                hintText: "Select start date",
                errorMessage: startDateError,
                readonly: true,
                controller: startdate,
                onTap: () async {
                  var date = await showDatePicker(
                      context: context,
                      initialDate: startdate.text == ""
                          ? DateTime.now()
                          : DateTime.parse(startdate.text),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2024),
                      builder: (context, child) {
                        return datePickerTheme(child);
                      });
                  if (date != null) {
                    setState(() {
                      startdate.text = DateFormat('yyyy-MM-dd').format(date);
                      startDateError = "";
                    });
                  }
                },
              ),
              SizedBox(height: 10),
              const Text(
                "End Date*",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              AppTextField(
                hintText: "Select end date",
                errorMessage: endDateError,
                readonly: true,
                controller: endDate,
                onTap: () async {
                  var date = await showDatePicker(
                    context: context,
                    initialDate: endDate.text == ""
                        ? DateTime.now()
                        : DateTime.parse(endDate.text),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2050),
                    builder: (context, child) {
                      return datePickerTheme(child);
                    },
                  );
                  if (date != null) {
                    setState(() {
                      endDate.text = DateFormat('yyyy-MM-dd').format(date);
                      endDateError = "";
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (validation()) {
                    if (widget.data == null) {
                      createBanner();
                    } else {
                      updateBanner();
                    }
                  }
                },
                child: const Center(
                  child: Text(
                    'Publish Banner',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validation() {
    bool isValid = true;
    setState(() {
      titleError = '';
      descriptionError = '';
      startDateError = '';
      endDateError = '';
    });
    if (bannerImage == null && widget.data == null) {
      Utils.toastMessage("Select your banner image");
      isValid = false;
    }
    if (title.isEmpty) {
      setState(() {
        titleError = "Please Enter Title";
      });
      isValid = false;
    }

    if (description.isEmpty) {
      setState(() {
        descriptionError = "Please Enter Description";
      });
      isValid = false;
    }
    if (startdate.text.isEmpty) {
      setState(() {
        startDateError = "Please Select Start Date";
      });
      isValid = false;
    }
    if (endDate.text.isEmpty) {
      setState(() {
        endDateError = "Please Select End Date";
      });
      isValid = false;
    }
    if (startdate.text.isNotEmpty && endDate.text.isNotEmpty) {
      if (DateTime.parse(endDate.text)
          .isBefore(DateTime.parse(startdate.text))) {
        Utils.toastMessage("Invalid date selection");
        isValid = false;
      }
    }
    return isValid;
  }

  void createBanner() {
    LoadingOverlay.of(context).show();
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      BannerApi.createBanner(
        title,
        description,
        bannerImage!,
        startdate.text,
        endDate.text,
      ).then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          LoadingOverlay.of(context).hide();
          Navigator.of(context).pop(true);
        } else {
          LoadingOverlay.of(context).hide();
          Utils.errorHandling(response);
        }
      });
    } catch (e) {
      LoadingOverlay.of(context).hide();
    }
  }

  void updateBanner() {
    LoadingOverlay.of(context).show();
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      BannerApi.updateBanner(
        widget.data!.id,
        title,
        description,
        bannerImage,
        startdate.text,
        endDate.text,
      ).then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          LoadingOverlay.of(context).hide();
          Navigator.of(context).pop(true);
        } else {
          LoadingOverlay.of(context).hide();
          Utils.errorHandling(response);
        }
      });
    } catch (e) {
      LoadingOverlay.of(context).hide();
    }
  }

  datePickerTheme(child) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.light(
          primary: AppColors.main,
          onPrimary: AppColors.white,
          onSurface: AppColors.main,
          surface: Colors.pink,
        ),
        dialogBackgroundColor: Colors.white,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.appColor,
          ),
        ),
      ),
      child: child!,
    );
  }
}
