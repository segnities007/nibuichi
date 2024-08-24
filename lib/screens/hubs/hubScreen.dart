import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nibuichi/providers/hub_provider.dart';
import '../commons/appbar.dart';
import 'hubs.dart';

////////////////////////////////////////////////////////////////////////////////

final footerItemList = [
  const HomeUI(),
  const RankingUI(),
  const ItemShopUI(),
  const SettingUI()
];

////////////////////////////////////////////////////////////////////////////////

class HubScreen extends ConsumerWidget{
  const HubScreen({super.key});

  @override
  Widget build(context, ref){
    final itemIndex = ref.watch(hubIndexProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: commonAppBar,
      body: footerItemList[itemIndex],
      bottomNavigationBar: ConvexAppBar(
        items: const [
          TabItem(icon: Icons.home,title: "Home"),
          TabItem(icon: Icons.bar_chart_rounded, title: "Ranking"),
          TabItem(icon: Icons.shopping_bag_outlined, title: "Shop" ),
          TabItem(icon: Icons.settings, title: "Setting")
        ],
        initialActiveIndex: itemIndex,
        onTap: (index) {
          ref.read(hubIndexProvider.notifier).state = index;
          if (index == 3) {
            ref.read(settingKeyProvider.notifier).state = "SettingHomeUI";
          }
        },
        backgroundColor: Colors.green[400],
        style: TabStyle.react,
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////