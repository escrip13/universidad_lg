import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universidad_lg/Home/pages/home_page.dart';
import 'package:universidad_lg/Ranking/bloc/ranking_bloc.dart';
import 'package:universidad_lg/Ranking/models/ranking_model.dart';
import 'package:universidad_lg/Ranking/services/ranking_service.dart';
import 'package:universidad_lg/User/models/user.dart';
import 'package:universidad_lg/widgets/drawer_menu_left.dart';
import 'package:universidad_lg/widgets/drawer_menu_right.dart';

import '../../constants.dart';

class PageRanking extends StatelessWidget {
  final User user;
  const PageRanking({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Center(
          child: InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (_) {
                return HomePage(
                  user: user,
                );
              }), (route) => false);
            },
            child: Image(
              image: AssetImage('assets/img/new_logo.png'),
              height: 35,
            ),
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: Icon(Icons.person),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      drawer: DrawerMenuLeft(
        user: user,
      ),
      endDrawer: DrawerMenuRight(
        user: user,
        currenPage: 'ranking',
      ),
      body: BlocProvider<RankingBloc>(
        create: (context) => RankingBloc(service: IsRankingService()),
        child: _ContentRankingPage(user: user),
      ),
    );
  }
}

class _ContentRankingPage extends StatefulWidget {
  final User user;

  const _ContentRankingPage({Key key, this.user}) : super(key: key);
  @override
  State<StatefulWidget> createState() => __ContentRankingPage();
}

class __ContentRankingPage extends State<_ContentRankingPage> {
  // final scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getRankingData();

    // scrollController.addListener(_scrollListener);
  }

  // _scrollListener() {
  //   if (scrollController.offset >= scrollController.position.maxScrollExtent &&
  //       !scrollController.position.outOfRange) {
  //     setState(() {
  //       debugPrint("reach the bottom");
  //     });
  //   }
  //   if (scrollController.offset <= scrollController.position.minScrollExtent &&
  //       !scrollController.position.outOfRange) {
  //     setState(() {
  //       debugPrint("reach the top");
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: BlocBuilder<RankingBloc, RankingState>(builder: (context, state) {
        return SingleChildScrollView(
          // controller: scrollController,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                margin: EdgeInsets.only(bottom: 10.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        'RANKING',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 50,
                            child: Icon(
                              Icons.emoji_events,
                              color: Color(0xFFfbeb39),
                              size: 50.0,
                              textDirection: TextDirection.ltr,
                            ),
                          ),
                          Container(
                            width: 50,
                            child: Icon(
                              Icons.emoji_events,
                              color: Color(0xFFe4e4e4),
                              size: 50.0,
                            ),
                          ),
                          Container(
                            width: 50,
                            child: Icon(
                              Icons.emoji_events,
                              color: Color(0xFFf8ac2f),
                              size: 50.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (state is RankingSuccess)
                for (var item in state.data.status.data)
                  ItemListRanking(
                    item: item,
                  )
              else
                Container(
                  height: MediaQuery.of(context).size.height - 300,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: mainColor,
                    ),
                  ),
                )
            ],
          ),
        );
      }),
    );
  }

  void getRankingData() {
    final blocRanking = BlocProvider.of<RankingBloc>(context);
    blocRanking.add(GetRanking(widget.user.userId, widget.user.token));
  }
}

class ItemListRanking extends StatelessWidget {
  final Datum item;

  const ItemListRanking({Key key, this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      width: double.infinity,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10.0),
            width: MediaQuery.of(context).size.width / 2,
            child: Row(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    width: 50,
                    height: 50,
                    imageUrl: item.uri,
                    placeholder: (context, url) => CircularProgressIndicator(
                      color: mainColor,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10.0),
                    child: Text(
                      item.nombre,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 50,
                  alignment: Alignment.center,
                  child: Text(item.oro.toString()),
                ),
                Container(
                  width: 50,
                  alignment: Alignment.center,
                  child: Text(item.plata.toString()),
                ),
                Container(
                  width: 50,
                  alignment: Alignment.center,
                  child: Text(item.bronce.toString()),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
