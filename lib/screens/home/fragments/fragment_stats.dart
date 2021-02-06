import 'package:flutter/material.dart';
import 'package:flutter_structure/components/widgets.dart';
import 'package:flutter_structure/models/city_sales.dart';
import 'package:flutter_structure/screens/map_stats/map_stats.dart';
import 'package:flutter_structure/services/constants.dart';
import 'package:flutter_structure/services/localizations.dart';

class FragmentStats extends StatefulWidget {

  @override
  _FragmentStatsState createState() {
    return _FragmentStatsState();
  }

}

class _FragmentStatsState extends State<FragmentStats> {

  double width;
  List<CitySales> stats = [];
  bool isLoading = true;

  List<String> cities = [];
  List<Item> items = [];

  Map<String, Item> salesByCities = {};

  @override
  void setState(fn) {
    if (mounted)
      super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    CitySales.getAllSales().then((value) {
      setState(() {
        isLoading = false;
        stats = value;
        if (stats != null) {
          stats.forEach((element) {
            //group sales by cities
            if (! cities.contains(element.city)) {
              cities.add(element.city);
              Item item = Item();
              item.sales = List<CitySales>();
              salesByCities[element.city] = item;
            }
            salesByCities[element.city].sales.add(element);
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: app_background,
      body: SafeArea(
        child: (isLoading)?
        Center(
          child: CircularProgressIndicator(),
        ):
        Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                Container(
                  decoration: boxDecoration(showShadow: true),
                  padding: EdgeInsets.all(spacing_middle),
                  margin: EdgeInsets.only(
                      right: spacing_standard_new,
                      left: spacing_standard_new,
                      bottom: spacing_standard_new),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      mTitle(
                          width,
                          Icons.map,
                          MyLocalizations.of(context).localization['view_map'],
                              (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                              return MapStats(this.stats);
                            }));
                          },
                          MyLocalizations.of(context).localization['view_stats_on_map'],
                          colorPrimary
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: ListView.builder(
                        itemCount: cities.length,
                        itemBuilder: (context, index) {
                          Item _item = salesByCities[cities[index]];
                          return InkWell(
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      text(
                                        cities[index],
                                        fontSize: textSizeMedium,
                                      ),
                                      Icon(
                                        (_item.isExpanded)?
                                        Icons.expand_less:
                                        Icons.expand_more
                                      )
                                    ],
                                  ),
                                  Divider(
                                    color: textColorSecondary,
                                  ),
                                  (_item.isExpanded)?
                                  Column(
                                    children: List.generate(
                                    _item.sales.length,
                                    (_index) {
                                      return Row(
                                        children: [
                                          Container(
                                            child: Image.network(
                                              _item.sales[_index].category.urlImage
                                            ),
                                            width: 80,
                                            height: 80,
                                          ),
                                          SizedBox(width: 10.0,),
                                          Column(
                                            children: [
                                              text(
                                                  _item.sales[_index].category.name
                                              ),
                                              text(
                                                '${_item.sales[_index].sales.toString()} ${MyLocalizations.of(context).localization['sales']}',
                                                textColor: textColorSecondary
                                              )
                                            ],
                                          )
                                        ],
                                      );
                                    }),
                                  ): Container()
                                ],
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _item.isExpanded = ! _item.isExpanded;
                              });
                            },
                          );
                        }
                    ),
                    decoration: BoxDecoration(
                      color: color_white,
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    margin: EdgeInsets.all(spacing_standard_new),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget mIcon() {
    return Row(
      children: <Widget>[
        Container(
            width: 0.5,
            height: width * 0.1,
            color: view_color,
            margin: EdgeInsets.only(left: width * 0.06)),
        Container(
            height: 0.5,
            color: view_color,
            margin: EdgeInsets.only(
                left: width * 0.1,
                top: spacing_control,
                bottom: spacing_control)),
      ],
    );
  }

}

class Item {

  List<CitySales> sales;
  bool isExpanded = false;

}