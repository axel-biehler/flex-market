import 'dart:async';
import 'dart:math';
import 'package:flex_market/utils/constants.dart';
import 'package:flex_market/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A widget that displays the product form to add and edit items.
///
/// A form to add or edit items.
class AdminItemFormWidget extends StatefulWidget {
  /// Creates a [AdminItemFormWidget].
  const AdminItemFormWidget({required this.navigatorKey, required this.isEdit, super.key});

  /// Key used for custom navigation flow inside each app section
  final GlobalKey<NavigatorState> navigatorKey;

  /// Boolean indicating if the form is in add or edit mode
  final bool isEdit;

  @override
  State<AdminItemFormWidget> createState() => _AdminItemFormWidgetState();
}

class _AdminItemFormWidgetState extends State<AdminItemFormWidget> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late Map<ItemSize, TextEditingController> _stockControllers;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _stockControllers = <ItemSize, TextEditingController>{
      ItemSize.xs: TextEditingController(),
      ItemSize.s: TextEditingController(),
      ItemSize.m: TextEditingController(),
      ItemSize.l: TextEditingController(),
      ItemSize.xl: TextEditingController(),
      ItemSize.xxl: TextEditingController(),
    };
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    for (final TextEditingController controller in _stockControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      // final Map<ItemSize, int?> stocks = _stockControllers.map((ItemSize key, TextEditingController value) {
      //   return MapEntry<ItemSize, int?>(key, int.tryParse(value.text));
      // });
      // final model = productFormToModel(_nameController.text, _descriptionController.text, stocks);
      formKey.currentState!.reset();
    }
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
                              child: SvgPicture.asset('assets/arrow.svg', height: 20),
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
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: margin * 2),
            child: ElevatedButton(
              onPressed: submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF247100),
                fixedSize: const Size(100, 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'SAVE',
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
