import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nibuichi/providers/hub_provider.dart';
import 'hubs.dart';

////////////////////////////////////////////////////////////////////////////////

class HubScreen extends ConsumerWidget{
  const HubScreen({super.key});

  @override
  Widget build(context, ref){
    final itemIndex = ref.watch(indexProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Home")),
        backgroundColor: Colors.green[400],
      ),
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
          ref.read(indexProvider.notifier).state = index;
          },
        backgroundColor: Colors.green[400],
        style: TabStyle.react,
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

const footerItemList = [HomeUI(), RankingUI(), ItemShopUI(), SettingUI()];