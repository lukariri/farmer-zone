import 'package:flutter/material.dart';
import 'package:flutter_structure/components/widgets.dart';
import 'package:flutter_structure/models/category.dart';
import 'package:flutter_structure/services/constants.dart';
import '../services/localizations.dart';
import 'package:nb_utils/nb_utils.dart';

import 'custom_toggle.dart';
import 'edit_text.dart';

class DialogPickProduct extends StatefulWidget {

  @override
  _DialogPickProductState createState() {
    return _DialogPickProductState();
  }

}

class _DialogPickProductState extends State<DialogPickProduct> {

  TextEditingController _editingControllerCategoryName = TextEditingController();

  ToggleType selectFromCategories = ToggleType.TOGGLE_TYPE_1, selectFromOthers = ToggleType.TOGGLE_TYPE_2;
  ToggleType selectedToggle = ToggleType.TOGGLE_TYPE_1;

  _DialogPickProductState();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              MyLocalizations.of(context).localization['categories'],
              style: boldTextStyle(color: textPrimaryColor)
          ),
          20.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomToggle(
                    (selected) {
                  setState(() {
                    selectedToggle = selected;
                  });
                },
                MyLocalizations.of(context).localization['categories'],
                MyLocalizations.of(context).localization['others'],
              )
            ],
          ),
          10.height,
          (selectedToggle == selectFromOthers)?
          Column(
            children: [
              EditText(
                text: MyLocalizations.of(context).localization['category_name'],
                fontSize: textSizeLargeMedium,
                mController: _editingControllerCategoryName,
                isPassword: false,
              ),
              8.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RaisedButton(
                    onPressed: () {
                      if (_editingControllerCategoryName.text.isNotEmpty) {
                        Category category = Category.otherCategory;
                        category.name = _editingControllerCategoryName.text;
                        Navigator.of(context).pop(category);
                      }
                    },
                    color: colorPrimary,
                    child: Text(
                      MyLocalizations.of(context).localization['save'],
                      style: TextStyle(
                        color: color_white
                      ),
                    ),
                  )
                ],
              )
            ],
          ).paddingAll(spacing_standard_new):
          Expanded(
            child: ListView.builder(
                itemBuilder: (context, index) {
                  String id = Category.categoriesIds[index];
                  return InkWell(
                    child: Container(
                      child: Row(
                        children: [
                          Image.network(
                            Category.allCategories[id].urlImage,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 10.0,),
                          Container(
                            child: Text(
                              Category.allCategories[id].name,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: textSizeLargeMedium
                              ),
                            ),
                            width: MediaQuery.of(context).size.width * 0.45,
                          )
                        ],
                      ),
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: textColorSecondary, width: 1.0))
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop(Category.allCategories[id]);
                    },
                  );
                },
              itemCount: Category.categoriesIds.length,
            ),
          ),
          16.height,
        ],
      ),
      contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomLeft: Radius.circular(50))),
    );
  }

}