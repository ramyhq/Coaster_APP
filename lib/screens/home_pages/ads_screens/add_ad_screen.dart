import 'dart:io';
import 'dart:math';

import 'package:coastv1/consts/app_functions/places.dart';
import 'package:coastv1/consts/colors.dart';
import 'package:coastv1/consts/text_const.dart';
import 'package:coastv1/data_layer/database_services/ads_db_services.dart';
import 'package:coastv1/data_layer/models/user_data.dart';
import 'package:coastv1/my_widgets/login_button.dart';
import 'package:coastv1/my_widgets/my_text_field.dart';
import 'package:coastv1/screens/home_drawer/home_drawer.dart';
import 'package:coastv1/screens/home_pages/ads_screens/ads_places_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddAdScreen extends StatefulWidget {
  const AddAdScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AddAdScreenState createState() => _AddAdScreenState();
}

class _AddAdScreenState extends State<AddAdScreen> {
  // Variables
  final _formKey = GlobalKey<FormState>();
  var uuid = Uuid();

  // Ad data
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _areaController;
  late TextEditingController _descriptionController;
  late TextEditingController _addressController;
  late TextEditingController _mobController;

  File? _pickedImage;
  List<File> _pickedImageList = [];
  List<String?> _imagesUrl = [];
  String? _adID; // rent or sell
  String? _adType; // rent or sell
  String? _apartmentType; // flat or villa
  String? _location; // flat or villa
  double? _level;
  double? _rooms;
  double? _wcs;

  bool _letsValidat = false;
  bool _isUploading = false;

  Future<void> uploadImages() async {
    setState(() {
      _isUploading = true;
    });
    for (int i = 0; i < _pickedImageList.length; i++) {
      String imageUrl = await AdsDatabaseServices().uploadImage(
        image: _pickedImageList[i],
        cloud_path: 'ads_images',
        file_name: _titleController.text + Random().nextInt(10000).toString(),
      );
      _imagesUrl.add(imageUrl.toString());
    }
    setState(() {
      print(_imagesUrl);
      _isUploading = false;
    });
  }

  void clearTextFiled() {
    setState(() {
      _adID = null;
      _priceController.clear();
      _areaController.clear();
      _titleController.clear();
      _descriptionController.clear();
      _addressController.clear();
      _mobController.clear();
      _level = null;
      _rooms = null;
      _wcs = null;
      _adType = null;
      _apartmentType = null;
      _pickedImageList = [];
      _imagesUrl = [];
      _location = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    AdsDatabaseServices dbs = AdsDatabaseServices();
    _adID = uuid.v1();
    final userDataFromDB =
        Provider.of<User?>(context); // stream of profile user data from DB

    return SafeArea(
      child: Scaffold(
        drawer: const HomeDrawer(),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        padding: const EdgeInsets.only(left: 10),
                        shrinkWrap: true,
                        reverse: false,
                        scrollDirection: Axis.horizontal,
                        itemCount: _pickedImageList.length + 1,
                        itemBuilder: (c, index) {
                          return GestureDetector(
                            child: SizedBox(
                              width: index == 0 ? 120 : 220,
                              child: Card(
                                color: Colors.transparent,
                                elevation: index == 0 ? 0 : 2,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: index == 0
                                    ? const Icon(Icons.add_a_photo,
                                        size: 70, color: Colors.grey)
                                    : Image.file(
                                        _pickedImageList.reversed
                                            .toList()[index - 1],
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            onTap: index != 0
                                ? null
                                : () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:  Text('Choose Image'.tr,
                                              style: kDialogAlert),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: [
                                                SizedBox(
                                                  height: 40,
                                                  child: InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      child:  Text(
                                                          'Camera'.tr,
                                                          style:
                                                              kDialogAlertElements),
                                                      onTap: () async {
                                                        Navigator.pop(context);
                                                        var image =
                                                            await AdsDatabaseServices()
                                                                .pickImage(
                                                                    source: ImageSource
                                                                        .camera);
                                                        setState(() {
                                                          _pickedImageList
                                                              .add(image);
                                                        });
                                                      }),
                                                ),
                                                const SizedBox(height: 20),
                                                SizedBox(
                                                  height: 40,
                                                  child: InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    child:  Text('Gallery'.tr,
                                                        style:
                                                            kDialogAlertElements),
                                                    onTap: () async {
                                                      Navigator.pop(context);
                                                      var image =
                                                          await AdsDatabaseServices()
                                                              .pickImage(
                                                                  source: ImageSource
                                                                      .gallery);
                                                      setState(() {
                                                        _pickedImageList
                                                            .add(image);
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                          );
                        }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Title
                  MyTextField(
                    validator: (val) {
                      if (_letsValidat) {
                        if (val!.isEmpty || val.length < 11) {
                          return 'Enter a title'.tr;
                        } else {
                          return null;
                        }
                      }
                      return null;
                    },
                    controller: _titleController,
                    hintText: 'Title'.tr,
                    labelText: 'Title',
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  // Description
                  MyTextField(
                    validator: (val) {
                      if (_letsValidat) {
                        if (val!.isEmpty || val.isEmpty) {
                          return "You have to talk about your ad ".tr;
                        } else {
                          return null;
                        }
                      }
                      return null;
                    },
                    controller: _descriptionController,
                    hintText: 'description'.tr,
                    labelText: 'description',
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    minLines: 2,
                    maxLines: 7,
                  ),
                  // Mobile
                  MyTextField(
                    controller: _mobController,
                    validator: (val) {
                      if (_letsValidat) {
                        if (val!.isEmpty || val.length < 11) {
                          return "Wrong Number".tr;
                        } else {
                          return null;
                        }
                      }
                    },
                    hintText: 'Mobile'.tr,
                    labelText: 'Mobile',
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                  ),
                  // Price
                  MyTextField(
                    controller: _priceController,
                    validator: (val) {
                      if (_letsValidat) {
                        if (val!.isEmpty) {
                          return "Enter Price".tr;
                        } else {
                          return null;
                        }
                      }
                    },
                    hintText: 'Price'.tr,
                    labelText: 'Price',
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  // Area of place
                  MyTextField(
                    validator: (val) {
                      if (_letsValidat) {
                        if (val!.isEmpty || val.length < 11) {
                          return "What is the area of the place?".tr;
                        } else {
                          return null;
                        }
                      }
                    },
                    controller: _areaController,
                    hintText: 'Area of the place'.tr,
                    labelText: 'Area of the place',
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                  // Address
                  MyTextField(
                    validator: (val) {
                      if (_letsValidat) {
                        if (val!.isEmpty || val.length < 11) {
                          return "Enter address".tr;
                        } else {
                          return null;
                        }
                      }
                    },
                    controller: _addressController,
                    hintText: 'Address'.tr,
                    labelText: 'Address',
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),

                  /// DropdownButton Section
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 25),
                    child: Column(
                      children: [
                        //Location or Place
                        DropdownButton<String>(
                          isExpanded: true,
                          hint:  Text("Location".tr),
                          value: _location,
                          onChanged: (val) {
                            setState(() {
                              _location = val;
                            });
                          },
                          items: List.generate(places.length, (index) {
                            return DropdownMenuItem(
                                value: places[index].location,
                                child: Text(places[index].location.toString()));
                          }),
                        ),
                        // place type
                        DropdownButton<String>(
                          isExpanded: true,
                          hint:  Text("Rent or Sell".tr),
                          value: _adType,
                          onChanged: (val) {
                            setState(() {
                              _adType = val;
                            });
                          },
                          items:  [
                            DropdownMenuItem(
                                value: 'rent', child: Text('rent'.tr)),
                            DropdownMenuItem(
                                value: 'sell', child: Text('sell'.tr)),
                          ],
                        ),
                        // Apartment type
                        DropdownButton<String>(
                          isExpanded: true,
                          hint:  Text("Apartment type".tr),
                          value: _apartmentType,
                          onChanged: (val) {
                            setState(() {
                              _apartmentType = val;
                            });
                          },
                          items:  [
                            DropdownMenuItem(
                                value: 'apartment', child: Text('apartment'.tr)),
                            DropdownMenuItem(
                                value: 'villa', child: Text('villa'.tr)),
                            DropdownMenuItem(
                                value: 'chalet', child: Text('chalet'.tr)),
                            DropdownMenuItem(
                                value: 'land', child: Text('land'.tr)),
                            DropdownMenuItem(
                                value: 'shop', child: Text('shop'.tr)),
                          ],
                        ),
                        // Level
                        DropdownButton<double>(
                          isExpanded: true,
                          hint:  Text("Level".tr),
                          value: _level,
                          onChanged: (val) {
                            setState(() {
                              _level = val;
                            });
                          },
                          items: List.generate(11, (index) {
                            return DropdownMenuItem(
                                value: index.toDouble(),
                                child: Text(index.toString()));
                          }),
                        ),
                        // Rooms
                        DropdownButton<double>(
                          isExpanded: true,
                          hint:  Text("Rooms".tr),
                          value: _rooms,
                          onChanged: (val) {
                            setState(() {
                              _rooms = val;
                            });
                          },
                          items: List.generate(11, (index) {
                            return DropdownMenuItem(
                                value: index.toDouble(),
                                child: Text(index.toString()));
                          }),
                        ),
                        // Wcs
                        DropdownButton<double>(
                          isExpanded: true,
                          hint:  Text("Wcs".tr),
                          value: _wcs,
                          onChanged: (val) {
                            setState(() {
                              _wcs = val;
                            });
                          },
                          items: List.generate(5, (index) {
                            return DropdownMenuItem(
                                value: index.toDouble(),
                                child: Text(index.toString()));
                          }),
                        ),
                      ],
                    ),
                  ),
                  _isUploading
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 30.0),
                          child: GFLoader(
                            androidLoaderColor:
                                AlwaysStoppedAnimation<Color>(colorBlue),
                          ),
                        )
                      : LoginButton(
                          width: 210,
                          height: 60,
                          labelStyle: kLoginLabelStyle,
                          label: 'Add Ad'.tr,
                          onPressed: () async {
                            FocusScope.of(context)
                                .unfocus(); // to unfocused Keyboard
                            setState(() {
                              _letsValidat = false;
                            });
                            if (_formKey.currentState!.validate() &&
                                userDataFromDB != null) {
                              if (_pickedImageList.isEmpty) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar( SnackBar(
                                  content: Text('Select image'.tr),
                                  duration: const Duration(seconds: 1),
                                ));
                                return;
                              }
                              try {
                                await uploadImages();
                                await dbs.addAd(
                                  adID: _adID,
                                  createdBy: userDataFromDB.email!.trim(),
                                  adDate: DateTime.now(),
                                  title: _titleController.text.trim(),
                                  description:
                                      _descriptionController.text.trim(),
                                  mob: _mobController.text.trim(),
                                  price: double.parse(
                                      _priceController.text.trim()),
                                  area:
                                      double.parse(_areaController.text.trim()),
                                  address: _addressController.text.trim(),
                                  location: _location.toString(),
                                  adType: _adType.toString().trim(),
                                  apartmentType:
                                      _apartmentType.toString().trim(),
                                  level: _level ?? 0.0,
                                  rooms: _rooms ?? 0.0,
                                  wcs: _wcs ?? 0.0,
                                  imageSlider: _imagesUrl,
                                );
                                clearTextFiled();
                              } catch (e) {
                                print('#532 add new ad button error : $e');
                              }

                              //Navigator.pop(context);
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => AdsPlacesScreen()));
                            }
                          },
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _priceController =
        TextEditingController(); // 0.0 if user didn't enter value
    _areaController = TextEditingController(); // 0.0 if user didn't enter value
    _descriptionController = TextEditingController();
    _addressController = TextEditingController();
    _mobController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _priceController.dispose();
    _areaController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _mobController.dispose();
  }
}
