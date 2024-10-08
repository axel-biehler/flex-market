import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flex_market/components/image_viewer.dart';
import 'package:flex_market/components/picture_preview.dart';
import 'package:flex_market/models/add_pics_response.dart';
import 'package:flex_market/models/item.dart';
import 'package:flex_market/providers/image_management_provider.dart';
import 'package:flex_market/providers/item_provider.dart';
import 'package:flex_market/utils/constants.dart';
import 'package:flex_market/utils/enums.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

/// Convert the form specs list to a map of [Map<String, dynamic>]
Map<String, dynamic> specsToMap(
  List<Map<String, TextEditingController>> specs,
) {
  final Map<String, dynamic> specsMap = <String, dynamic>{};

  for (final Map<String, TextEditingController> spec in specs) {
    final String key = spec['name']!.text;
    final dynamic value = spec['value']!.text;
    specsMap[key] = value;
  }

  return specsMap;
}

/// Get the stock value of an item for a given [ItemSize]
String getItemStockValue(Item? item, ItemSize size) {
  if (item != null && item.stock[size.name.toUpperCase()] != null) {
    return item.stock[size.name.toUpperCase()].toString();
  } else {
    return '0';
  }
}

/// A widget that displays the product form to add and edit items.
///
/// A form to add or edit items.
class AdminItemFormWidget extends StatefulWidget {
  /// Creates a [AdminItemFormWidget].
  const AdminItemFormWidget({
    required this.navigatorKey,
    required this.isEdit,
    this.item,
    super.key,
  });

  /// Key used for custom navigation flow inside each app section
  final GlobalKey<NavigatorState> navigatorKey;

  /// Boolean indicating if the form is in add or edit mode
  final bool isEdit;

  /// Boolean indicating if the form is in add or edit mode
  final Item? item;

  @override
  State<AdminItemFormWidget> createState() => _AdminItemFormWidgetState();
}

class _AdminItemFormWidgetState extends State<AdminItemFormWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late Map<ItemSize, TextEditingController> _stockControllers;
  List<String> imagesUrl = <String>[];
  ItemCategory? selectedCategory;
  ItemGender? selectedGender;
  List<Map<String, TextEditingController>> specs = <Map<String, TextEditingController>>[];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    selectedCategory = stringToItemCategory(widget.item?.category);
    selectedGender = stringToGender(widget.item?.gender);
    _nameController = TextEditingController(text: widget.item?.name);
    _descriptionController = TextEditingController(text: widget.item?.description);
    _priceController = TextEditingController(text: widget.item?.price.toString());
    _stockControllers = <ItemSize, TextEditingController>{
      ItemSize.xs: TextEditingController(
        text: getItemStockValue(widget.item, ItemSize.xs),
      ),
      ItemSize.s: TextEditingController(
        text: getItemStockValue(widget.item, ItemSize.s),
      ),
      ItemSize.m: TextEditingController(
        text: getItemStockValue(widget.item, ItemSize.m),
      ),
      ItemSize.l: TextEditingController(
        text: getItemStockValue(widget.item, ItemSize.l),
      ),
      ItemSize.xl: TextEditingController(
        text: getItemStockValue(widget.item, ItemSize.xl),
      ),
      ItemSize.xxl: TextEditingController(
        text: getItemStockValue(widget.item, ItemSize.xxl),
      ),
    };
    widget.item?.specs.forEach((String key, dynamic value) {
      specs.add(<String, TextEditingController>{
        'name': TextEditingController(text: key),
        'value': TextEditingController(text: value),
      });
    });
    if (widget.isEdit && widget.item != null) {
      imagesUrl = widget.item!.imagesUrl.isNotEmpty ? widget.item!.imagesUrl : <String>[];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    for (final TextEditingController controller in _stockControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void addSpec() {
    setState(() {
      specs.add(<String, TextEditingController>{
        'name': TextEditingController(),
        'value': TextEditingController(),
      });
    });
  }

  void removeSpec(int index) {
    setState(() {
      specs.removeAt(index);
    });
  }

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Capture the providers before the async gap
      final ItemProvider itemProvider = context.read<ItemProvider>();
      final ImageManagementProvider imageManagementProvider = context.read<ImageManagementProvider>();

      final Map<String, int?> stocks = _stockControllers.map((ItemSize key, TextEditingController value) {
        return MapEntry<String, int?>(
          key.name.toUpperCase(),
          int.tryParse(value.text),
        );
      });

      final Map<String, dynamic> formattedSpecs = specsToMap(specs);
      final Item model = Item.formForm(
        _nameController.text,
        selectedCategory!,
        _descriptionController.text,
        stocks,
        formattedSpecs,
        double.tryParse(_priceController.text)!,
        selectedGender!,
        imagesUrl,
        widget.item?.id,
      );

      bool status = false;
      List<dynamic> urls = <dynamic>[];

      if (widget.isEdit) {
        status = await itemProvider.updateItem(model);
      } else {
        urls = await itemProvider.createItem(model);
        final List<XFile> files = imageManagementProvider.imageFiles;
        for (int i = 0; i < imagesUrl.length; i++) {
          await imageManagementProvider.uploadXFileToS3(files[i], urls[i]);
        }
      }

      // Check if the widget is still in the tree
      if (mounted) {
        if (status || urls.length == imagesUrl.length) {
          showDialogBoxAdd();
        }
        setState(() {
          _isSubmitting = false;
        });
      }
      imageManagementProvider.clearImages();
    }
  }

  void showDialogBoxAdd() {
    unawaited(
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Success',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            content: Text(
              'Item ${widget.isEdit ? 'updated' : 'created'} successfully.',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  formKey.currentState!.reset();
                  widget.navigatorKey.currentState?.pop();
                },
                child: Text(
                  'OK',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0xFF247100)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void showDialogBoxDelete() {
    unawaited(
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Success',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            content: Text(
              'Item deleted successfully.',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  formKey.currentState!.reset();
                  widget.navigatorKey.currentState?.pop();
                },
                child: Text(
                  'OK',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0xFF247100)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> deleteItem() async {
    setState(() {
      _isSubmitting = true;
    });

    final bool status = await context.read<ItemProvider>().deleteItem(widget.item!);

    if (status) {
      showDialogBoxDelete();
    }
    setState(() {
      _isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = kIsWeb ? MediaQuery.of(context).size.width * 0.6 : MediaQuery.of(context).size.width;
    final double horizontalPadding = kIsWeb ? MediaQuery.of(context).size.width * 0.2 : 40;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: screenHeight * 0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: kIsWeb ? MediaQuery.of(context).size.width * 0.2 : margin,
                      right: kIsWeb ? MediaQuery.of(context).size.width * 0.2 : 0,
                    ),
                    child: Row(
                      children: <Widget>[
                        DecoratedBox(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color(0xFF3D3D3B),
                          ),
                          child: IconButton(
                            icon: Transform.rotate(
                              angle: pi,
                              child: SvgPicture.asset(
                                'assets/arrow.svg',
                                height: 20,
                              ),
                            ),
                            onPressed: () => widget.navigatorKey.currentState?.pop(),
                            highlightColor: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: margin),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${widget.isEdit ? "MODIFY" : "ADD"} AN ITEM',
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  left: kIsWeb ? MediaQuery.of(context).size.width * 0.2 : 40,
                  right: kIsWeb ? MediaQuery.of(context).size.width * 0.2 : 40,
                  bottom: margin,
                ),
                child: Text(
                  'Information',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 24,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ),
            ],
          ),
          Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: margin),
                    child: SizedBox(
                      height: kIsWeb ? screenWidth * 0.3 : screenWidth - 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          if (widget.isEdit && widget.item != null)
                            ...imagesUrl.map((String url) {
                              return Padding(
                                padding: const EdgeInsets.only(right: margin),
                                child: Stack(
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(23),
                                      child: SizedBox(
                                        width: kIsWeb ? screenWidth * 0.3 : screenWidth * 0.9,
                                        height: kIsWeb ? screenWidth * 0.3 : screenWidth - 120,
                                        child: ImageViewerWidget(
                                          url: url,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 3,
                                      left: 3,
                                      child: IconButton(
                                        icon: const Icon(Icons.delete),
                                        color: Colors.white,
                                        onPressed: () {
                                          setState(() {
                                            imagesUrl.remove(url);
                                          });
                                        },
                                        highlightColor: Theme.of(context).colorScheme.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          if (!widget.isEdit)
                            ...context.watch<ImageManagementProvider>().imageFiles.map((XFile file) {
                              return Padding(
                                padding: const EdgeInsets.only(right: margin),
                                child: Stack(
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(23),
                                      child: SizedBox(
                                        width: kIsWeb ? screenWidth * 0.3 : screenWidth * 0.9,
                                        height: kIsWeb ? screenWidth * 0.3 : screenWidth - 120,
                                        child: Image.file(
                                          File(file.path),
                                          width: kIsWeb ? screenWidth * 0.3 : screenWidth - 120,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 3,
                                      left: 3,
                                      child: IconButton(
                                        icon: const Icon(Icons.delete),
                                        color: Colors.white,
                                        onPressed: () {
                                          context.read<ImageManagementProvider>().removeImage(file);
                                        },
                                        highlightColor: Theme.of(context).colorScheme.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          SizedBox(
                            height: kIsWeb ? screenWidth * 0.3 : screenWidth - 120,
                            width: kIsWeb ? screenWidth * 0.3 : screenWidth - 120,
                            child: DecoratedBox(
                              decoration: const BoxDecoration(
                                color: Color(0xFF3D3D3B),
                                borderRadius: BorderRadius.all(Radius.circular(23)),
                              ),
                              child: IconButton(
                                iconSize: 100,
                                icon: SvgPicture.asset('assets/plus.svg'),
                                color: Theme.of(context).colorScheme.secondary,
                                onPressed: () async {
                                  await widget.navigatorKey.currentState?.push(
                                    MaterialPageRoute<Widget>(
                                      builder: (BuildContext context) => PicturePreviewPage(
                                        navigatorKey: widget.navigatorKey,
                                        maxPictures: 5,
                                        callback: (List<XFile> pics) async {
                                          if (!widget.isEdit) {
                                            setState(() {
                                              imagesUrl = pics.map((XFile e) => e.name).toList();
                                            });
                                            if (kDebugMode) {
                                              print(imagesUrl);
                                              print(pics);
                                            }
                                          } else if (widget.isEdit && widget.item != null && widget.item!.id != null) {
                                            final ImageManagementProvider imageManagementProvider = context.read<ImageManagementProvider>();
                                            final AddPicsResponse addPicsResponse =
                                                await context.read<ItemProvider>().getPresignedUrls(pics, widget.item!.id!);
                                            for (int i = 0; i < pics.length; i++) {
                                              await imageManagementProvider.uploadXFileToS3(pics[i], addPicsResponse.presignedUrls[i]);
                                            }
                                            setState(() {
                                              imagesUrl.addAll(addPicsResponse.imageUrls);
                                            });
                                            imageManagementProvider.clearImages();
                                            if (kDebugMode) {
                                              print(addPicsResponse.presignedUrls);
                                              print(addPicsResponse.imageUrls);
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Name:',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: SizedBox(
                            height: 50,
                            child: TextFormField(
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                              enabled: !_isSubmitting,
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          top: margin * 2,
                          bottom: margin,
                        ),
                        child: Text(
                          'Description:',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ),
                      TextFormField(
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                        enabled: !_isSubmitting,
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.multiline,
                        minLines: 5,
                        maxLines: 5,
                        scrollPhysics: const BouncingScrollPhysics(),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: margin),
                    child: TextFormField(
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                      enabled: !_isSubmitting,
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Enter a valid number';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: margin),
                    child: DropdownButtonFormField<ItemCategory>(
                      value: selectedCategory,
                      onChanged: (ItemCategory? newValue) {
                        setState(() {
                          if (!_isSubmitting) {
                            selectedCategory = newValue;
                          }
                        });
                      },
                      items: ItemCategory.values.map((ItemCategory category) {
                        return DropdownMenuItem<ItemCategory>(
                          value: category,
                          child: Text(
                            category.name,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      validator: (ItemCategory? value) {
                        if (value == null) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                      dropdownColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: margin),
                    child: DropdownButtonFormField<ItemGender>(
                      value: selectedGender,
                      onChanged: (ItemGender? newValue) {
                        setState(() {
                          if (!_isSubmitting) {
                            selectedGender = newValue;
                          }
                        });
                      },
                      items: ItemGender.values.map((ItemGender gender) {
                        return DropdownMenuItem<ItemGender>(
                          value: gender,
                          child: Text(
                            gender.name,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(),
                      ),
                      validator: (ItemGender? value) {
                        if (value == null) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                      dropdownColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: margin * 2,
                      bottom: margin,
                    ),
                    child: Text(
                      'Stocks',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 24,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ),
                  Column(
                    children: _stockControllers.keys.map((ItemSize size) {
                      return Padding(
                        padding: const EdgeInsets.only(top: margin),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '${size.name.toUpperCase()}:',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                            ),
                            SizedBox(
                              height: 50,
                              width: screenWidth * 0.5,
                              child: TextFormField(
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                enabled: !_isSubmitting,
                                controller: _stockControllers[size],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: size.name.toUpperCase(),
                                  border: const OutlineInputBorder(),
                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter stock';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'Invalid number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: margin),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        for (int i = 0; i < specs.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(top: margin),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: TextFormField(
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                    enabled: !_isSubmitting,
                                    controller: specs[i]['name'],
                                    decoration: const InputDecoration(
                                      labelText: 'Name',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                    enabled: !_isSubmitting,
                                    controller: specs[i]['value'],
                                    decoration: const InputDecoration(
                                      labelText: 'Value',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle),
                                  onPressed: () => removeSpec(i),
                                ),
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top: margin),
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : addSpec,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF247100),
                              fixedSize: const Size(150, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Add spec',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: margin * 2),
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF247100),
                fixedSize: const Size(100, 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
          if (widget.isEdit)
            Padding(
              padding: const EdgeInsets.only(bottom: margin * 2),
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : deleteItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
                  fixedSize: const Size(100, 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
