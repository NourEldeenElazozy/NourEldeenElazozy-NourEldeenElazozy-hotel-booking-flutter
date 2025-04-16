import 'package:flutter/material.dart';
import 'package:hotel_booking/Model/RestAreas.dart';
import 'package:hotel_booking/core/constants/my_colors.dart';
import 'package:hotel_booking/presentation/common_widgets/custom_button.dart';
import 'package:hotel_booking/presentation/screen/RestAreaController.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:get/get.dart';
class AddRestAreaScreen extends StatefulWidget {
  @override
  _AddRestAreaScreenState createState() => _AddRestAreaScreenState();
}

class _AddRestAreaScreenState extends State<AddRestAreaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _restArea = RestAreas(

    areaType: [''],
    name: "Rest Area Name",
    location: "123 Main St, City, Country",
    gamesdetails: "",
    price: 0,
    totalSpace: 0,
    internalSpace: 0,
    maxGuests: 0,
    numDoubleBeds: 0,
    numSingleBeds: 0,
    numHalls: 0,
    numBedrooms: 0,
    numFloors: 0,
    numBathroomsIndoor: 0,
    numBathroomsOutdoor: 0,
    kitchenAvailable: false,
    kitchenContents: ["Utensils", "Fridge", "Microwave"],
    hasAcHeating: true,
    tvScreens: true,
    freeWifi: true,
    entertainmentGames: ["Board Games", "Video Games"],
    outdoorSpace: false,
    grassSpace: false,
    poolType: "Infinity",
    poolSpace: 0,
    poolDepth: 0,
    poolHeating: true,
    poolFilter: true,
    garage: true,
    outdoorSeating: true,
    childrenGames: true,
    outdoorKitchen: true,
    slaughterPlace: false,
    well: true,
    powerGenerator: true,
    outdoorBathroom: false,
    otherSpecs: "Near the lake",
    hostId: 1,
    mainImage: "",
    detailsImages: [],
    rating: 0,
    description: "A beautiful rest area with all amenities.",
    geoArea: "Geo Area Description",

    cityId: 9,
    checkInTime: "14:00",
    checkOutTime: "12:00",
    jumpAvailable: false,
    boardPitAvailable: false,
    fishingAvailable: false,
    depositValue: 0,
    googleMapsLocation: "",
    holidayPrice: 0,
    idProofType: "لا يشترط",
    eidDaysPrice: 0,
  );

  XFile? _mainImage;
  List<XFile> _detailsImages = [];
  int _currentStep = 0;
  late RestAreaController controller;
@override
void initState() {
super.initState();
controller = Get.put(RestAreaController());
}
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('إضافة استراحة جديدة',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'Tajawal',
              )),
          centerTitle: true,
          backgroundColor: MyColors.primaryColor,
          elevation: 0,
          iconTheme: IconThemeData(color: MyColors.primaryColor),
        ),
        body: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: MyColors.primaryColor,
            ),
          ),
          child: Stepper(
            currentStep: _currentStep,
            onStepContinue: () {
              final isLastStep = _currentStep == 3;
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                if (isLastStep) {
                  _submitForm();
                } else {
                  setState(() => _currentStep += 1);
                }
              }
              /*
              if (_currentStep < 3) {
                setState(() => _currentStep += 1);
              } else {
                _submitForm();
              }
             */
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() => _currentStep -= 1);
              }
            },
            steps: [
              _buildBasicInfoStep(),
              _buildRoomsAndFacilitiesStep(),
              _buildOutdoorFeaturesStep(),
              _buildImagesStep(),
            ],
            controlsBuilder: (context, details) {
              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentStep != 0)
                      ElevatedButton(
                        onPressed: details.onStepCancel,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('السابق',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'Tajawal',
                            )),
                      ),
                    ElevatedButton(
                      onPressed: () {
                        if (_currentStep == 3) {
                          print(_restArea.kitchenAvailable);

                          if (_formKey.currentState!.validate()) {
                            controller?.saveRestArea(_restArea,_mainImage,_detailsImages);
                            // إذا كانت جميع الحقول صالحة
                            _formKey.currentState!.save();
                            print(_restArea.name);
                            print(_restArea.location);
                            // هنا يمكنك استدعاء دالة الإرسال
                            _submitForm();
                          }
                        } else {
                          // التحقق من صحة الحقول قبل الانتقال للخطوة التالية
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            details.onStepContinue!();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _currentStep == 3 ? 'حفظ البيانات' : 'التالي',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Step _buildBasicInfoStep() {
    return Step(
      title: Text('المعلومات الأساسية',
          style: TextStyle(color: MyColors.TealColor)),
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildTextFormField(
              'اسم الاستراحة',
              Icons.home_work,
              (value) {
                print(value);
                _restArea.name = value!; // تحديث الكائن هنا
              },
              validator: _requiredValidator,
            ),
            _buildTextFormField(
              'المساحة الداخلية',
              Icons.area_chart, // أي رمز مناسب هنا
              (value) {
                _restArea.internalSpace =
                    int.tryParse(value!) ?? 0; // تحديث الكائن هنا
              },
              validator: _requiredValidator,
            ),
            _buildTextFormField(
              'المساحة الإجمالية',
              Icons.grid_view, // أي رمز مناسب هنا
              (value) {
                _restArea.totalSpace =
                    int.tryParse(value!) ?? 0; // تحديث الكائن هنا
              },
              validator: _requiredValidator,
            ),
            _buildTextFormField(
              'عدد الطوابق',
              Icons.apps, // أي رمز مناسب هنا
              (value) {
                _restArea.numFloors =
                    int.tryParse(value!) ?? 0; // تحديث الكائن هنا
              },
              validator: _requiredValidator,
            ),
            _buildTextFormField(
              'الموقع',
              Icons.location_on,
              (value) => _restArea.location = value!,
              validator: _requiredValidator,
            ),
            _buildNumberField(
              'السعر',
              Icons.attach_money,
              (value) => _restArea.price = value,
              validator: _requiredValidator,
            ),
            _buildNumberField(
              'العدد الأقصى للضيوف',
              Icons.people,
              (value) => _restArea.maxGuests = value.toInt(),
              validator: _requiredValidator,
            ),
            _buildNumberField(
              'قيمة العربون',
              Icons.monetization_on_outlined,
              (value) => _restArea.depositValue = value,
              validator: _requiredValidator,
            ),
            _buildTextFormField(
              'الموقع على خرائط جوجل (رابط)',
              Icons.map,
              (value) => _restArea.googleMapsLocation = value ?? "",
              validator: _requiredValidator,
            ),
            _buildNumberField(
              'سعر العطل الرسمية',
              Icons.event,
              (value) => _restArea.holidayPrice = value,
              validator: _requiredValidator,
            ),
            _buildNumberField(
              'سعر أيام العيد',
              Icons.celebration,
              (value) => _restArea.eidDaysPrice = value,
              validator: _requiredValidator,
            ),
            _buildDropdown(
              'نوع اثبات الهوية المطلوب',
              Icons.credit_card,
              [
                'جواز سفر ساري المفعول',
                'كتيب عائلة',
                'وثيقة زواج',
                'لا يشترط'
              ],
              _restArea.idProofType,
                  (value) => _restArea.idProofType = value ?? 'لا يشترط', // Default value

            ),
            _buildDropdown(
              'المنطقة الجغرافية',
              Icons.map,
              [
                'مطلة على البحر',
                'قريبة من البحر',
                'وسط البلاد',
                'في منطقة سياحية'
              ],
              _restArea.geoArea,
              (value) =>
                  _restArea.geoArea = value ?? '', // استخدم قيمة افتراضية
            ),
            _buildAreaTypeCheckboxes(),
            _buildTimeRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildAreaTypeCheckboxes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(' فئة الزوار', style: TextStyle(fontSize: 16)),
        CheckboxListTile(
          title: Text('للعائلات'),
          value: _restArea.areaType.contains('للعائلات'),
          onChanged: (bool? isChecked) {
            setState(() {
              if (isChecked == true) {
                _restArea.areaType.add('للعائلات');
              } else {
                _restArea.areaType.remove('للعائلات');
              }
            });
          },
        ),
        CheckboxListTile(
          title: Text('للشباب'),
          value: _restArea.areaType.contains('للشباب'),
          onChanged: (bool? isChecked) {
            setState(() {
              if (isChecked == true) {
                _restArea.areaType.add('للشباب');
              } else {
                _restArea.areaType.remove('للشباب');
              }
            });
          },
        ),
        CheckboxListTile(
          title: Text('للمناسبات'),
          value: _restArea.areaType.contains('للمناسبات'),
          onChanged: (bool? isChecked) {
            setState(() {
              if (isChecked == true) {
                _restArea.areaType.add('للمناسبات');
              } else {
                _restArea.areaType.remove('للمناسبات');
              }
            });
          },
        ),
        CheckboxListTile(
          title: Text('لكل الاستخدامات'),
          value: _restArea.areaType.contains('لكل الاستخدامات'),
          onChanged: (bool? isChecked) {
            setState(() {
              if (isChecked == true) {
                _restArea.areaType.add('لكل الاستخدامات');
              } else {
                _restArea.areaType.remove('لكل الاستخدامات');
              }
            });
          },
        ),
      ],
    );
  }

  Step _buildRoomsAndFacilitiesStep() {
    return Step(
      title:
          Text('الغرف والمرافق', style: TextStyle(color: MyColors.TealColor)),
      content: Column(
        children: [
          _buildSectionTitle(
            'الغرف والأسرة',
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildNumberInputChip(
                  'غرف نوم',
                  Icons.bed,
                  _restArea.numBedrooms ?? 0,
                  (value) => _restArea.numBedrooms = value),
              _buildNumberInputChip(
                  'أسرة مزدوجة',
                  Icons.bed,
                  _restArea.numDoubleBeds ?? 0,
                  (value) => _restArea.numDoubleBeds = value),
              _buildNumberInputChip(
                  'أسرة مفردة',
                  Icons.single_bed,
                  _restArea.numSingleBeds ?? 0,
                  (value) => _restArea.numSingleBeds = value),
              _buildNumberInputChip(
                  'دورات مياه داخلية',
                  Icons.bathtub,
                  _restArea.numBathroomsIndoor ?? 0,
                  (value) => _restArea.numBathroomsIndoor = value),
              _buildNumberInputChip(
                  'دورات مياه خارجية',
                  Icons.water,
                  _restArea.numBathroomsOutdoor ?? 0,
                  (value) => _restArea.numBathroomsOutdoor = value),
            ],
          ),
          _buildSectionTitle('المرافق الداخلية'),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
            _buildFeatureChip(
            'مطبخ',
            Icons.kitchen,
            (_restArea.kitchenAvailable == 'true'), // تحويل النص إلى bool
                (value) {
              // تعيين القيمة كـ bool
              _restArea.kitchenAvailable = value ? true : false; // تعيينها كنص
            },
          ),
              _buildFeatureChip(
                  'تكييف/تدفئة',
                  Icons.ac_unit,
                  _restArea.hasAcHeating ?? false,
                  (value) => _restArea.hasAcHeating = value),
              _buildFeatureChip(
                  'تلفزيون',
                  Icons.tv,
                  _restArea.tvScreens ?? false,
                  (value) => _restArea.tvScreens = value),
              _buildFeatureChip(
                  'واي فاي',
                  Icons.wifi,
                  _restArea.freeWifi ?? false,
                  (value) => _restArea.freeWifi = value),
            ],
          ),
          if (_restArea.kitchenAvailable ?? false) ...[
            _buildTextFormField(
              'ادخل محتويات المطبخ',
              Icons.kitchen, // أي رمز مناسب هنا
              (value) {
                _restArea.kitchenContents =
                    value as List<String>; // تخزين تفاصيل الألعاب
              },
              validator: _requiredValidator,
            ),
          ],
        ],
      ),
    );
  }

  bool _hasPool = false;
  Step _buildOutdoorFeaturesStep() {
    return Step(
      title:
          Text('المرافق الخارجية', style: TextStyle(color: MyColors.TealColor)),
      content: Column(
        children: [
          _buildSectionTitle('المسبح'),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              // خيار يوجد مسبح
              _buildFeatureChip('يوجد مسبح', Icons.pool, _hasPool, (value) {
                setState(() {
                  _hasPool = value; // تحديث المتغير عند التحديد
                  if (!value) {
                    _restArea.poolType = ""; // إعادة تعيين نوع المسبح
                    _restArea.poolSpace = 0; // إعادة تعيين مساحة المسبح
                    _restArea.poolHeating = false; // إعادة تعيين حالة التدفئة
                    _restArea.poolFilter = false; // إعادة تعيين حالة الفلتر
                  } else {
                    _restArea.poolType = 'عادي'; // تعيين نوع المسبح عند التحديد
                  }
                });
              }),

              // إذا كان هناك مسبح، عرض الخيارات الإضافية
              if (_hasPool) ...[
                _buildNumberInputChip(
                  'مساحة المسبح',
                  Icons.square_foot,
                  (_restArea.poolSpace ?? 0).toInt(), // تحويل إلى int
                  (value) => _restArea.poolSpace =
                      value.toInt(), // تحويل القيمة المدخلة إلى double
                ),
                _buildFeatureChip(
                    'تدفئة', Icons.thermostat, _restArea.poolHeating ?? false,
                    (value) {
                  _restArea.poolHeating = value; // تحديث حالة التدفئة
                }),
                _buildFeatureChip(
                    'فلتر', Icons.filter_alt, _restArea.poolFilter ?? false,
                    (value) {
                  _restArea.poolFilter = value; // تحديث حالة الفلتر
                }),
              ],
            ],
          ),

          _buildSectionTitle('مرافق أخرى'),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildFeatureChip(
                'جلسات خارجية',
                Icons.chair,
                _restArea.outdoorSeating ?? false,
                (value) => _restArea.outdoorSeating = value,
              ),
              _buildFeatureChip(
                'مساحة خارجية',
                Icons.nature    , // أيقونة شرفة/مساحة خارجية
                _restArea.outdoorSpace ?? false,
                    (value) => _restArea.outdoorSpace = value,
              ),
              _buildFeatureChip(
                'مساحة عشب',
                Icons.yard  ,
                _restArea.grassSpace ?? false,
                    (value) => _restArea.grassSpace = value,
              ),

              _buildFeatureChip(
                'بئر',
                Icons.water,
                _restArea.well ?? false,
                (value) => _restArea.well = value,
              ),
              _buildFeatureChip(
                'مولد كهربائي',
                Icons.power,
                _restArea.powerGenerator ?? false,
                (value) => _restArea.powerGenerator = value,
              ),
              _buildFeatureChip(
                'مكان للذبح',
                Icons.local_hospital,
                _restArea.slaughterPlace ?? false,
                (value) => _restArea.slaughterPlace = value,
              ),
              _buildFeatureChip(
                'ألعاب أطفال',
                Icons.child_friendly,
                _restArea.childrenGames ?? false,
                (value) => _restArea.childrenGames = value,
              ),
              _buildFeatureChip(
                'لوح للقفز',
                Icons.sports_kabaddi,
                _restArea.jumpAvailable ?? false,
                    (value) => _restArea.jumpAvailable = value,
              ),
              _buildFeatureChip(
                'مطبخ خارجي',
                Icons.outdoor_grill,
                _restArea.outdoorKitchen ?? false,
                (value) => _restArea.outdoorKitchen = value,
              ),
              _buildFeatureChip(
                'كراج',
                Icons.garage,
                _restArea.garage ?? false,
                (value) => _restArea.garage = value,
              ),
              _buildFeatureChip(
                'حفرة بورديم',
                Icons.panorama_photosphere_outlined,
                _restArea.boardPitAvailable ?? false,
                    (value) => _restArea.boardPitAvailable = value,
              ),
              _buildFeatureChip(
                'فسكية',
                Icons.anchor ,
                _restArea.fishingAvailable ?? false,
                    (value) => _restArea.fishingAvailable = value,
              ),
            ],
          ),

// حقل إدخال الألعاب إذا كان هناك ألعاب أطفال
          if (_restArea.childrenGames ?? false) ...[
            _buildTextFormField(
              'ادخل نوع  الالعاب',
              Icons.gamepad, // أي رمز مناسب هنا
              (value) {
                _restArea.gamesdetails = value; // تخزين تفاصيل الألعاب
              },
              validator: _requiredValidator,
            ),
          ],
        ],
      ),
    );
  }

  Step _buildImagesStep() {
    return Step(
      title: Text('الصور', style: TextStyle(color: MyColors.TealColor)),
      content: Column(
        children: [
          Center(
            child: _buildImageCard(
              'الصورة الرئيسية',
              _mainImage,
              (image) => setState(() => _mainImage = image),
              required: true,
            ),
          ),
          SizedBox(height: 20),
          _buildImageCard(
            'صور التفاصيل',
            null,
            (image) => setState(() => _detailsImages.add(image!)),
            multiSelect: true,
          ),
          if (_detailsImages.isNotEmpty) ...[
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _detailsImages.map((image) {
                return Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(File(image.path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.close, size: 18, color: Colors.red),
                        onPressed: () =>
                            setState(() => _detailsImages.remove(image)),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextFormField(
      String label, IconData icon, Function(String) onSaved,
      {String? Function(String?)? validator}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        onChanged: (value) => onSaved(value ?? ''),
        onSaved: (value) => onSaved(value ?? ''),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: MyColors.textPaymentInfo),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: MyColors.primaryColor),
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildNumberField(
      String label, IconData icon, Function(double) onChanged,
      {String? Function(String?)? validator}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        onSaved: (value) => onChanged(double.tryParse(value ?? '0') ?? 0),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: MyColors.textPaymentInfo),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: MyColors.primaryColor),
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    IconData icon,
    List<String> items,
    String? value,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        onSaved: (value) => onChanged(value),
        value: items.contains(value)
            ? value
            : null, // تعيين القيمة إلى null إذا لم تكن موجودة
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: MyColors.textPaymentInfo),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: MyColors.primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeRow() {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.login, color: MyColors.primaryColor),
          title: Text('وقت الدخول: ${_restArea.checkInTime}'),
          onTap: () => _selectTime(true),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.logout, color: MyColors.primaryColor),
          title: Text('وقت الخروج: ${_restArea.checkOutTime}'),
          onTap: () => _selectTime(false),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: MyColors.TealColor,
        ),
      ),
    );
  }

  Widget _buildNumberInputChip(
      String label, IconData icon, int value, Function(int) onChanged) {
    return InputChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: MyColors.TealColor),
          SizedBox(width: 5),
          Text('$value'),
        ],
      ),
      backgroundColor: Colors.teal[50],
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            int tempValue = value;
            return AlertDialog(
              title: Text('تعديل $label'),
              content: TextField(
                keyboardType: TextInputType.number,
                onChanged: (v) => tempValue = int.tryParse(v) ?? 0,
                decoration: InputDecoration(
                  hintText: 'أدخل العدد',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('إلغاء'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() => onChanged(tempValue));
                    Navigator.pop(context);
                  },
                  child: Text('حفظ'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildFeatureChip(
      String label, IconData icon, bool value, Function(bool) onChanged) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 18, color: value ? Colors.white : MyColors.TealColor),
          SizedBox(width: 5),
          Text(label,
              style: TextStyle(color: value ? Colors.white : Colors.black)),
        ],
      ),
      selected: value,
      onSelected: (selected) {
        onChanged(selected); // استدعاء onChanged
        setState(() {}); // تحديث الحالة
      },
      selectedColor: MyColors.TealColor,
      checkmarkColor: Colors.white,
      backgroundColor: Colors.teal[50],
      shape: StadiumBorder(side: BorderSide(color: Colors.teal)),
    );
  }

  Widget _buildImageCard(
    String title,
    XFile? image,
    Function(XFile?) onImageSelected, {
    bool required = false,
    bool multiSelect = false,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                title + (required ? ' *' : ''),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: MyColors.TealColor,
                ),
              ),
            ),
            SizedBox(height: 10),
            if (image != null || (multiSelect && _detailsImages.isNotEmpty))
              SizedBox(
                height: 100,
                child: (image != null)
                    ? _buildImagePreview(image, onImageSelected)
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _detailsImages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: _buildImagePreview(_detailsImages[index],
                                (img) {
                              setState(() => _detailsImages.removeAt(index));
                            }),
                          );
                        },
                      ),
              ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // محاذاة الزر إلى المنتصف
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final picker = ImagePicker();
                    if (multiSelect) {
                      final images = await picker.pickMultiImage();
                      if (images != null) {
                        setState(() => _detailsImages.addAll(images));
                      }
                    } else {
                      final img =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (img != null) {
                        onImageSelected(img);
                      }
                    }
                  },
                  icon: Icon(Icons.photo_library, size: 25),
                  label: Text(multiSelect ? 'اختر صور متعددة' : 'اختر صورة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.TealColor,
                    textStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'Tajawal',
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                if (image != null) ...[
                  SizedBox(width: 10),
                  TextButton.icon(
                    onPressed: () => onImageSelected(null),
                    icon: Icon(Icons.delete, color: Colors.red, size: 20),
                    label: Text('إزالة', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(XFile image, Function(XFile?) onRemove) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(image.path),
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: Icon(Icons.close, size: 18, color: Colors.red),
            onPressed: () => onRemove(null),
          ),
        ),
      ],
    );
  }

  Future<void> _selectTime(bool isCheckIn) async {
    final currentTime =
        isCheckIn ? _restArea.checkInTime : _restArea.checkOutTime;
    final parts = currentTime.split(':');
    final initialTime =
        TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        final timeStr =
            '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
        if (isCheckIn) {
          _restArea.checkInTime = timeStr;
        } else {
          _restArea.checkOutTime = timeStr;
        }
      });
    }
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_mainImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('الصورة الرئيسية مطلوبة')),
        );
        return;
      }
/*
      try {
        await _sendDataToServer();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تمت إضافة الاستراحة بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _sendDataToServer() async {
    var uri = Uri.parse('https://your-api-url/rest-areas');
    var request = http.MultipartRequest('POST', uri);

    // إضافة الحقول النصية
    // request.fields.addAll(_restArea.toJson());

    // إضافة الصورة الرئيسية
    if (_mainImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'main_image',
        _mainImage!.path,
      ));
    }

    // إضافة صور التفاصيل
    for (var image in _detailsImages) {
      request.files.add(await http.MultipartFile.fromPath(
        'details_images[]',
        image.path,
      ));
    }

    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('فشل في إرسال البيانات: ${response.statusCode}');
    }
  }
  */
    }
}
}
