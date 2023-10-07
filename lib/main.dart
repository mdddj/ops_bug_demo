import 'package:flutter/material.dart';
import 'package:loading_more_list_fast/loading_more_list_fast.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:extended_list/src/rendering/sliver_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _s = ScrollController();
  late final _ss = ListObserverController(controller: _s);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: ListViewObserver(
                controller: _ss,
                customTargetRenderSliverType: (p0) => p0 is ExtendedRenderSliverList,
                child: LoadingMoreList<String>(ListConfig(
                    itemBuilder: (context, item, index) {
                      return Container(
                        margin: const EdgeInsets.all(12),
                        width: 100,
                        height: double.infinity,
                        color: Colors.grey,
                        child: Text(item),
                      );
                    },
                    sourceList: _SourceRepository(),
                    scrollDirection: Axis.horizontal,
                    controller: _s),onScrollNotification: (notification) => true,),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  _ss.jumpTo(index: 40);
                },
                child: const Text('滚动到 40'))
          ],
        ),
      ),
    );
  }
}

class _SourceRepository extends LoadingModel<String> {
  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    addAll(List.generate(100, (index) => "$index"));
    return true;
  }
}
