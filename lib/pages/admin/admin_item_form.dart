import 'dart:async';
import 'dart:math';
import 'package:flex_market/models/item.dart';
import 'package:flex_market/providers/item_provider.dart';
import 'package:flex_market/utils/constants.dart';
import 'package:flex_market/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  Category? selectedCategory;
  Gender? selectedGender;
  List<Map<String, TextEditingController>> specs =
      <Map<String, TextEditingController>>[];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    selectedCategory = stringToCategory(widget.item?.category);
    selectedGender = stringToGender(widget.item?.gender);
    _nameController = TextEditingController(text: widget.item?.name);
    _descriptionController =
        TextEditingController(text: widget.item?.description);
    _priceController =
        TextEditingController(text: widget.item?.price.toString());
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
      final Map<String, int?> stocks =
          _stockControllers.map((ItemSize key, TextEditingController value) {
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
        widget.item?.id,
      );
      bool status;
      if (widget.isEdit) {
        status = await context.read<ItemProvider>().updateItem(model);
      } else {
        status = await context.read<ItemProvider>().createItem(model);
      }
      if (status) {
        showDialogBoxAdd();
      }
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void showDialogBoxAdd() {
    unawaited(
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: Text(
              'Item ${widget.isEdit ? 'updated' : 'created'} successfully.',
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
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: const Color(0xFF247100)),
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
            title: const Text('Success'),
            content: const Text('Item deleted successfully.'),
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
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: const Color(0xFF247100)),
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

    final bool status =
        await context.read<ItemProvider>().deleteItem(widget.item!);

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
    final double screenWidth = MediaQuery.of(context).size.width;

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
                    padding: const EdgeInsets.only(left: margin),
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
                            onPressed: () =>
                                widget.navigatorKey.currentState?.pop(),
                            highlightColor:
                                Theme.of(context).colorScheme.secondary,
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
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontStyle: FontStyle.italic),
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
                padding: const EdgeInsets.only(
                  left: 40,
                  right: 40,
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
              padding: const EdgeInsets.symmetric(horizontal: 39),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Name:',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: SizedBox(
                            height: 50,
                            child: TextFormField(
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
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      TextFormField(
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
                    child: DropdownButtonFormField<Category>(
                      value: selectedCategory,
                      onChanged: (Category? newValue) {
                        setState(() {
                          if (!_isSubmitting) {
                            selectedCategory = newValue;
                          }
                        });
                      },
                      items: Category.values.map((Category category) {
                        return DropdownMenuItem<Category>(
                          value: category,
                          child: Text(category.name),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      validator: (Category? value) {
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
                    child: DropdownButtonFormField<Gender>(
                      value: selectedGender,
                      onChanged: (Gender? newValue) {
                        setState(() {
                          if (!_isSubmitting) {
                            selectedGender = newValue;
                          }
                        });
                      },
                      items: Gender.values.map((Gender gender) {
                        return DropdownMenuItem<Gender>(
                          value: gender,
                          child: Text(gender.name),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(),
                      ),
                      validator: (Gender? value) {
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
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            SizedBox(
                              height: 50,
                              width: screenWidth * 0.5,
                              child: TextFormField(
                                enabled: !_isSubmitting,
                                controller: _stockControllers[size],
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
