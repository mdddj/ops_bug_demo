import 'package:flutter/material.dart';
import 'package:loading_more_list_fast/loading_more_list_fast.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:extended_list/src/rendering/sliver_list.dart';

void main() {
  runApp( const MyApp(title: 'demo',));
}

class MyApp extends StatefulWidget {
  final String title;
  const MyApp({super.key, required this.title});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


 late final _state = _State(widget.title);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: ScopedModel<_State>(
          model: _state,
          child: Column(
            children: [
              SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: ScopedModelDescendant<_State>(
                  builder:(context, child, model) =>  ListViewObserver(
                    controller: model._ss,
                    customTargetRenderSliverType: (p0) =>
                        p0 is ExtendedRenderSliverList,
                    child: LoadingMoreList<String>(
                      ListConfig(
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
                          controller: model._s),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    _state.to(60);
                  },
                  child: const Text('滚动到 60')),
              ElevatedButton(
                  onPressed: () {
                    _state.to( 40);
                  },
                  child: const Text('滚动到 40'))
            ],
          ),
        ),
      ),
    );
  }
}

class _SourceRepository extends LoadingModel<String> {
  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    await Future.delayed(const Duration(seconds: 3));
    addAll(List.generate(100, (index) => "$index"));
    return true;
  }
}


class _State extends Model {
  final String title;
  _State(this.title);
  final _s = ScrollController();
  late final _ss = ListObserverController(controller: _s);
  int _index = 0;

  Future<void> to(int index) async {
    _ss.animateTo(index: index, duration: const Duration(milliseconds: 300), curve: Curves.linear);
    // 添加后不能跳转
  }
}