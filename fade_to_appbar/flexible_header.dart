import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'bloc.dart';

class FlexibleHeader extends StatefulWidget {
  final bool allowBlocStateUpdates;
  final bool innerBoxIsScrolled;
  final Function onBackPressed;
  const FlexibleHeader({@required this.allowBlocStateUpdates, @required this.innerBoxIsScrolled, this.onBackPressed});
  @override
  _FlexibleHeaderState createState() => _FlexibleHeaderState();
}

class _FlexibleHeaderState extends State<FlexibleHeader> {
  FlexibleHeaderBloc bloc = FlexibleHeaderBloc();

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: bloc.initial(),
      stream: bloc.stream,
      builder: (BuildContext context, AsyncSnapshot<FlexibleHeaderState> stream) {
        FlexibleHeaderState _state = stream.data;
        return SliverOverlapAbsorber(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          sliver: SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.401,
            pinned: true,
            primary: true,
            centerTitle: true,
            backgroundColor: Colors.black,
            leading: Opacity(
              opacity: _state.opacityAppBar,
              child: _state.opacityAppBar > 0.01 // Otherwise the button would be selectable while being not shown
                  ? IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: widget.onBackPressed,
                      padding: EdgeInsets.all(0),
                      splashRadius: 16.0,
                    )
                  : null,
            ),
            title: Opacity(
              opacity: _state.opacityAppBar,
              child: Text('MyAppBar'),
            ),
            forceElevated: widget.innerBoxIsScrolled,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if (widget.allowBlocStateUpdates) bloc.update(_state, constraints.maxHeight);
                return Opacity(
                  opacity: _state.opacityFlexible,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text("MyHeader", style: TextStyle(color: Colors.white, fontSize: 40)),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: _state.opacityFlexible > 0.01 // Otherwise the button would be selectable while being not shown
                            ? IconButton(
                                  icon: Icon(Icons.arrow_back, color: Colors.white),
                                  onPressed: widget.onBackPressed,
                                  padding: EdgeInsets.all(0),
                                  splashRadius: 16.0,
                                )
                            : null,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
