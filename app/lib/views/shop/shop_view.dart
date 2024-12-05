import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:routine/views/shop/tabs/supermarket_tab.dart';

import '../../config/design_system.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';

class ShopView extends StatefulWidget {
  final int initialIndex;

  const ShopView({super.key, this.initialIndex = 0});

  @override
  ShopViewState createState() => ShopViewState();
}

class ShopViewState extends State<ShopView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialIndex,
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'shop',
          bottom: TabBar(
            labelColor: AppColors.onPrimary,
            tabs: [
              Tab(child: Text('supermarket'.tr())),
              Tab(child: Text('wishlist'.tr())),
            ],
          ),
        ),
        drawer: CustomDrawer(currentRoute: "/shop"),
        body: TabBarView(
          children: [
            SupermarketTab(),
          ],
        ),
      ),
    );
  }
}
