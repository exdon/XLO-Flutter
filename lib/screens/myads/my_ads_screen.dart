import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:xlo_mobx/components/empty_card.dart';
import 'package:xlo_mobx/components/empty_card.dart';
import 'package:xlo_mobx/components/empty_card.dart';
import 'package:xlo_mobx/stores/my_ads_store.dart';

import 'components/active_tile.dart';
import 'components/pending_tile.dart';
import 'components/sold_tile.dart';

class MyAdsScreen extends StatefulWidget {
  const MyAdsScreen({super.key, this.initialPage = 0});

  final int initialPage;

  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen>
    with SingleTickerProviderStateMixin {
  final MyAdsStore store = MyAdsStore();

  late TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController =
        TabController(length: 3, vsync: this, initialIndex: widget.initialPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Meus Anúncios',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        bottom: TabBar(
          tabs: const [
            Tab(child: Text('ATIVOS', style: TextStyle(color: Colors.white))),
            Tab(
                child:
                    Text('PENDENTES', style: TextStyle(color: Colors.white))),
            Tab(child: Text('VENDIDOS', style: TextStyle(color: Colors.white))),
          ],
          controller: tabController,
          indicatorColor: Colors.orange,
        ),
      ),
      body: Observer(builder: (_) {
        if (store.loading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          );
        }
        return TabBarView(
          controller: tabController,
          children: [
            Observer(builder: (_) {
              if (store.activeAds.isEmpty) {
                return const EmptyCard(
                    text: 'Você não possui nenhum anúncio ativo');
              }
              return ListView.builder(
                itemBuilder: (_, index) {
                  return ActiveTile(ad: store.activeAds[index], store: store);
                },
                itemCount: store.activeAds.length,
              );
            }),
            Observer(builder: (_) {
              if (store.pendingAds.isEmpty) {
                return const EmptyCard(
                    text: 'Você não possui nenhum anúncio pendente');
              }
              return ListView.builder(
                itemBuilder: (_, index) {
                  return PendingTile(ad: store.pendingAds[index]);
                },
                itemCount: store.pendingAds.length,
              );
            }),
            Observer(builder: (_) {
              if (store.soldAds.isEmpty) {
                return const EmptyCard(
                    text: 'Você não possui nenhum anúncio vendido');
              }
              return ListView.builder(
                itemBuilder: (_, index) {
                  return SoldTile(ad: store.soldAds[index], store: store);
                },
                itemCount: store.soldAds.length,
              );
            }),
          ],
        );
      }),
    );
  }
}
