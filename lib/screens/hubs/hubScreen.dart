import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nibuichi/providers/hub_provider.dart';
import 'package:nibuichi/screens/common_uis/appbar.dart';
import 'hubs.dart';

////////////////////////////////////////////////////////////////////////////////

class HubScreen extends ConsumerWidget{
  const HubScreen({super.key});

  @override
  Widget build(context, ref){
    final itemIndex = ref.watch(hubIndexProvider);

    return Scaffold(
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
        onTap: (index){
          ref.read(hubIndexProvider.notifier).state = index;
          },
        backgroundColor: Colors.green[400],
        style: TabStyle.react,
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

const footerItemList = [HomeUI(), RankingUI(), ItemShopUI(), SettingUI()];

////////////////////////////////////////////////////////////////////////////////