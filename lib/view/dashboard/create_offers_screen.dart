import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lootfat_owner/utils/colors.dart';
import 'package:lootfat_owner/utils/formatter.dart';
import 'package:lootfat_owner/utils/images.dart';
import 'package:lootfat_owner/utils/utils.dart';
import 'package:lootfat_owner/view/widgets/app_text_field.dart';

import '../../api_provider/offers_api.dart';
import '../../model/myoffers_details_model.dart';
import '../widgets/loading_overlay.dart';

class CreateOffersScreen extends StatefulWidget {
  final MyOffersDetailsModel? offerDetails;

  CreateOffersScreen({
    super.key,
    this.offerDetails,
  });

  @override
  State<CreateOffersScreen> createState() => _CreateOffersScreenState();
}

class _CreateOffersScreenState extends State<CreateOffersScreen> {
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  ImagePicker picker = ImagePicker();
  MultipartFile? multipartFile;
  File profileImage = File("");
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController offerPrice = TextEditingController();
  TextEditingController offerPercentage = TextEditingController();
  String? offerType;

  String profileImageError = '';
  String titleError = '';
  String descriptionError = '';
  String startDateError = '';
  String offerPercentageError = '';
  String offerPriceError = '';
  String priceError = '';
  String offerTypeError = '';
  String endDateError = '';
  String editOffers = 'addOffers';
  String offerImage = '';
  String offerId = '';
  bool isActive = true;

  @override
  void initState() {
    if (widget.offerDetails != null) {
      setState(() {
        editOffers = 'editOffers';
        title.text = widget.offerDetails!.title;
        offerId = widget.offerDetails!.id;
        offerType = widget.offerDetails!.offerType;
        isActive = widget.offerDetails!.isActive;
        selectedStartDate = widget.offerDetails!.startDate.toLocal();
        selectedEndDate = widget.offerDetails!.endDate.toLocal();
        price.text = widget.offerDetails!.price.toString();
        offerPrice.text = widget.offerDetails!.offerPrice.toString();
        offerPercentage.text = widget.offerDetails!.offerPercentage.toString();
        description.text = widget.offerDetails!.description;
        offerImage = widget.offerDetails!.offerImage;
        startDate.text =
            "${Utils.convertDate(selectedStartDate!, 'dd MMM, yyyy')}";
        endDate.text = "${Utils.convertDate(selectedEndDate!, 'dd MMM, yyyy')}";
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

  bool validationCreateOffers() {
    bool isValid = true;
    setState(() {
      titleError = '';
      descriptionError = '';
      endDateError = '';
      startDateError = '';
      offerPercentageError = '';
      offerPriceError = '';
      priceError = '';
      offerTypeError = '';
      profileImageError = '';
    });
    if (title.text.isEmpty) {
      setState(() {
        titleError = "Please enter offer title";
      });
      isValid = false;
    }
    if (profileImage.path.isEmpty && offerImage.isEmpty) {
      setState(() {
        profileImageError = "Please select the offer image";
      });
      isValid = false;
    }
    if (description.text.isEmpty) {
      setState(() {
        descriptionError = "Please enter description";
      });
      isValid = false;
    }
    if (startDate.text.isEmpty) {
      setState(() {
        startDateError = "Please select start date";
      });
      isValid = false;
    }
    if (endDate.text.isEmpty) {
      setState(() {
        endDateError = "Please select end date";
      });
      isValid = false;
    }
    if (startDate.text.isNotEmpty && endDate.text.isNotEmpty) {
      if (selectedEndDate!.isBefore(selectedStartDate!)) {
        setState(() {
          endDateError = "Please select valid end date";
        });
        isValid = false;
      }
    }
    if (price.text.isEmpty) {
      setState(() {
        priceError = "Please enter regular price";
      });
      isValid = false;
    }
    if (offerPrice.text.isEmpty) {
      setState(() {
        offerPriceError = "Please enter discounted price";
      });
      isValid = false;
    }
    if (price.text.isNotEmpty && offerPrice.text.isNotEmpty) {
      if (int.parse(price.text) < int.parse(offerPrice.text)) {
        setState(() {
          offerPriceError = "Discounted price not grater than regular price.";
        });
        isValid = false;
      }
    }
    if (offerPercentage.text.isEmpty) {
      setState(() {
        offerPercentageError = "Please Enter Offer Percentage";
      });
      isValid = false;
    }
    if (offerType == null) {
      setState(() {
        offerTypeError = "Please select valid offer type";
      });
      isValid = false;
    }

    return isValid;
  }

  createOfferApi() {
    FocusScope.of(context).requestFocus(FocusNode());
    LoadingOverlay.of(context).show();
    try {
      MyOffersAPI.createOffer(
        title: title.text,
        description: description.text,
        startDate: Utils.stringUTCDate(selectedStartDate!),
        endDate: Utils.stringUTCDate(selectedEndDate!),
        offerType: offerType,
        price: price.text,
        offerPrice: offerPrice.text,
        offerPercentage: offerPercentage.text,
        fileData: profileImage,
      ).then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          var res = json.decode(response.body);
          LoadingOverlay.of(context).hide();
          setState(() {
            offerId = res['data']['_id'];
          });
          manageOfferStatus();
          Utils.toastMessage(res['message']);
          Navigator.pop(context, true);
        } else {
          LoadingOverlay.of(context).hide();
          Utils.errorHandling(response);
        }
      });
    } catch (e) {
      LoadingOverlay.of(context).hide();
    }
  }

  editOfferApi() {
    FocusScope.of(context).requestFocus(FocusNode());
    LoadingOverlay.of(context).show();
    try {
      if (widget.offerDetails!.isActive != isActive) {
        manageOfferStatus();
      }
      MyOffersAPI.editOffer(
        title: title.text,
        description: description.text,
        startDate: Utils.stringUTCDate(selectedStartDate!),
        endDate: Utils.stringUTCDate(selectedEndDate!),
        offerType: offerType,
        price: price.text,
        offerPrice: offerPrice.text,
        offerPercentage: offerPercentage.text,
        fileData: profileImage,
        offerId: offerId,
      ).then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          var res = json.decode(response.body);
          LoadingOverlay.of(context).hide();
          Utils.toastMessage(res['message']);
          Navigator.pop(context, true);
        } else {
          LoadingOverlay.of(context).hide();
          Utils.errorHandling(response);
        }
      });
    } catch (e) {
      LoadingOverlay.of(context).hide();
    }
  }

  Future<bool> back(returnStatus) async {
    Navigator.pop(context, returnStatus);
    return true;
  }

  manageOfferStatus() {
    try {
      MyOffersAPI.manageStatus(
        offerId,
      ).then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          // OKKK
        } else {
          Utils.errorHandling(response);
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => back(false),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              editOffers == 'editOffers' ? "Edit Offers" : "Create Offers"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    hintText: "Title",
                    errorMessage: titleError,
                    controller: title,
                    titleText: "Offer Title*",
                    isTitleText: true,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Offer Type',
                    style: TextStyle(
                      color: AppColors.main,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  Theme(
                    data: new ThemeData(
                        canvasColor: Colors.red,
                        primaryColor: Colors.black,
                        hintColor: Colors.black,
                        colorScheme: ColorScheme.fromSwatch()
                            .copyWith(secondary: Colors.black)),
                    child: DropdownButtonHideUnderline(
                      child: Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: AppColors.textLight, width: 1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: EdgeInsets.only(left: 12, right: 10),
                        child: DropdownButton(
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(6),
                          elevation: 0,
                          dropdownColor: Colors.white,
                          focusColor: Colors.white,
                          iconEnabledColor: Colors.black,
                          hint: Text(
                            'Offer Type',
                            style: TextStyle(
                              fontSize: 13.0,
                              color: AppColors.main,
                            ),
                          ),
                          value: offerType,
                          style: TextStyle(
                            color: AppColors.main,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          onChanged: (newValue) {
                            setState(() {
                              offerType = newValue!;
                            });
                          },
                          items: [
                            'Buy One Get One',
                            '% Based Discount',
                            'Buy One Get Specific Item',
                            'Combo Offer',
                            'Birthday and Anniversary Discount',
                            'Time Based Discount',
                            "First Time Customer Discount",
                            'Order again and Save',
                          ]
                              .map((value) => DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                  if (offerTypeError.isNotEmpty)
                    Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: AppTextField.inputErrorMessage(offerTypeError)),
                  const SizedBox(height: 10),
                  if (editOffers == 'editOffers')
                    Text(
                      'Status',
                      style: TextStyle(
                        color: AppColors.main,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (editOffers == 'editOffers') SizedBox(height: 6),
                  if (editOffers == 'editOffers')
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.textLight,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(
                            'Status',
                            style: TextStyle(
                              fontSize: 13.0,
                              color: AppColors.main,
                            ),
                          )),
                          Switch(
                              activeColor: AppColors.appColor,
                              activeTrackColor:
                                  AppColors.appColor.withOpacity(0.3),
                              inactiveThumbColor: AppColors.main,
                              inactiveTrackColor:
                                  AppColors.main.withOpacity(0.2),
                              splashRadius: 50.0,
                              value: isActive,
                              onChanged: (value) {
                                setState(() => isActive = value);
                              }),
                        ],
                      ),
                    ),
                  const SizedBox(height: 10),
                  AppTextField(
                    hintText: "DD/MM/YYYY",
                    errorMessage: startDateError,
                    readonly: true,
                    controller: startDate,
                    titleText: "Offer Start Date",
                    isTitleText: true,
                    onTap: () async {
                      var dateAndTime = await Utils.showDateTimePicker(
                        context: context,
                        initialDate: selectedStartDate ?? DateTime.now(),
                        firstDate: widget.offerDetails == null
                            ? DateTime.now()
                            : widget.offerDetails!.startDate
                                    .isBefore(DateTime.now())
                                ? widget.offerDetails!.startDate
                                : DateTime.now(),
                        lastDate: DateTime(2050),
                      );
                      if (dateAndTime != null) {
                        selectedStartDate = dateAndTime;
                        startDate.text =
                            "${Utils.convertDate(selectedStartDate!, 'dd MMM, yyyy')}";
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    hintText: "DD/MM/YYYY",
                    errorMessage: endDateError,
                    readonly: true,
                    controller: endDate,
                    titleText: "Offer End Date",
                    isTitleText: true,
                    onTap: () async {
                      var dateAndTime = await Utils.showDateTimePicker(
                        context: context,
                        initialDate: selectedEndDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2050),
                      );
                      if (dateAndTime != null) {
                        selectedEndDate = dateAndTime;
                        endDate.text =
                            "${Utils.convertDate(selectedEndDate!, 'dd MMM, yyyy')}";
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    hintText: "Price",
                    errorMessage: priceError,
                    controller: price,
                    keyboardType: TextInputType.number,
                    onChange: (e) {
                      setState(() {});
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    titleText: "Regular Price*",
                    isTitleText: true,
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    hintText: "Offer Price",
                    errorMessage: offerPriceError,
                    controller: offerPrice,
                    onChange: (e) {
                      setState(() {});
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    titleText: "Offer Price*",
                    isTitleText: true,
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    hintText: "Enter your total discount %",
                    errorMessage: offerPercentageError,
                    controller: offerPercentage,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(2),
                      LimitRangeTextInputFormatter(1, 99),
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    titleText: "Discount %*",
                    isTitleText: true,
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    hintText: "Description",
                    errorMessage: descriptionError,
                    controller: description,
                    maxLines: 4,
                    contentVerticalPadding: 10,
                    titleText: "Description*",
                    isTitleText: true,
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(6),
                        highlightColor: AppColors.white.withOpacity(0.4),
                        splashColor: AppColors.appColor.withOpacity(0.2),
                        onTap: () {
                          getImage();
                        },
                        child: Container(
                          height: Utils.height(context) * 0.3,
                          width: Utils.height(context) * 0.3,
                          padding: EdgeInsets.all(
                              profileImage.path.isEmpty ? 10 : 0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.main.withOpacity(0.1),
                                  width: 1),
                              borderRadius: BorderRadius.circular(6)),
                          child: profileImage.path.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.file(
                                    profileImage,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : offerImage.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.network(
                                        offerImage,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, url, error) =>
                                            Container(
                                                color: AppColors.appColor
                                                    .withOpacity(0.1),
                                                child: Icon(Icons.error,
                                                    color: Colors.black)),
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: AppColors.appColor,
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      int.parse(loadingProgress
                                                          .expectedTotalBytes
                                                          .toString())
                                                  : null,
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: AppColors.appColor,
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    spreadRadius: 5,
                                                    blurRadius: 7,
                                                    offset: Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                                border: Border.all(
                                                    width: 2,
                                                    color: Colors.white)),
                                            child: SvgPicture.asset(
                                              SvgImages.upload,
                                              width: 25,
                                              height: 25,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'Upload Single Image',
                                            style: TextStyle(
                                              color: AppColors.main,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            decoration: BoxDecoration(
                                                color: AppColors.main,
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: Text(
                                              'Upload',
                                              style: TextStyle(
                                                color: AppColors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ]),
                        ),
                      ),
                    ),
                  ),
                  if (profileImageError.isNotEmpty)
                    Padding(
                        padding: EdgeInsets.only(top: 5),
                        child:
                            AppTextField.inputErrorMessage(profileImageError)),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (validationCreateOffers()) {
                        if (editOffers == 'editOffers') {
                          editOfferApi();
                        } else {
                          createOfferApi();
                        }
                      }
                    },
                    child: const Center(
                      child: Text(
                        'Submit',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  selectTimeThemeSet(child) {
    return Theme(
      data: ThemeData.light().copyWith(
        colorScheme: ColorScheme.light(primary: AppColors.appColor),
        dialogBackgroundColor: Colors.white,
      ),
      child: child,
    );
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

  Future getImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Set Offer Image',
            toolbarColor: AppColors.main,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Set Offer Image',
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          profileImage = File(croppedFile.path);
        });
      }
    }
  }

  String getDiscountPercentage() {
    if (offerPrice.text.isNotEmpty && price.text.isNotEmpty) {
      var percentage = ((int.parse(price.text) - int.parse(offerPrice.text)) /
          int.parse(price.text) *
          100);
      if (percentage < 1) {
        return "00.00";
      }
      return "${percentage.toStringAsFixed(2)}";
    } else {
      return "00.00";
    }
  }
}
