import 'package:flutter/material.dart';
import 'package:flutter_structure/components/widgets.dart';
import 'package:flutter_structure/models/order.dart';
import 'package:flutter_structure/models/user.dart';
import 'package:flutter_structure/screens/order_details/order_details.dart';
import 'package:flutter_structure/services/constants.dart';
import 'package:flutter_structure/services/localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:intl/intl.dart';

class OrderList extends StatefulWidget {

  @override
  _OrderListState createState() {
    return _OrderListState();
  }

}

class _OrderListState extends State<OrderList> {

  double width;
  List<Order> orders = [];
  RefreshController _refreshController = RefreshController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initOrders();
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  initOrders() {
    setState(() {
      isLoading = true;
    });
    Order.getLatestOrders(UserItem.currentUser.userId, 10).then((value) {
      _completeOrdersInitialization(value);
    });
  }

  _completeOrdersInitialization(List<Order> ordersList) {
    setState(() {
      orders = ordersList;
      isLoading = false;
    });
    _refreshController.refreshCompleted();
  }

  loadOrders() {
    if (orders.length > 0) {
      Order.getLatestOrders(UserItem.currentUser.userId, 10, lastOrderDoc: orders.last.documentSnapshot).then((value) {
        _onCompleteOrderAddition(value);
      });
    }
    else {
      _refreshController.loadComplete();
    }
  }

  _onCompleteOrderAddition(List<Order> orderList) {
    setState(() {
      orders.addAll(orderList);
    });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: app_background,
      appBar: AppBar(
        title: Text(
          MyLocalizations.of(context).localization['orders']
        ),
        backgroundColor: colorPrimary,
      ),
      body: (isLoading)?
      Center(
          child: CircularProgressIndicator()
      ):
      Container(
        padding: EdgeInsets.all(spacing_middle),
        child: SmartRefresher(
          controller: _refreshController,
          header: WaterDropMaterialHeader(
            backgroundColor: Theme.of(context).primaryColor,
          ),
          footer: CustomFooter(
            builder: (BuildContext context,LoadStatus mode){
              Widget body ;
              if(mode==LoadStatus.loading){
                body =  CircularProgressIndicator();
              }
              else{
                body = Container();
              }
              return Container(
                height: 55.0,
                child: Center(child:body),
              );
            },
          ),
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: initOrders,
          onLoading: loadOrders,
          child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: mTitle(
                          width,
                          Icons.expand_less,
                          'ORDER ${index+1}',
                              (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                              return OrderDetails(orders[index].id);
                            }));
                          },
                          DateFormat('yyyy MMM d h:m a').format(orders[index].dateTime),
                          colorPrimary,
                          showIcon: false
                      ),
                      margin: EdgeInsets.all(5.0),
                      padding: EdgeInsets.all(spacing_control),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: color_white,
                      ),
                    )
                  ],
                );
              }
          ),
        ),
      )
    );
  }

}