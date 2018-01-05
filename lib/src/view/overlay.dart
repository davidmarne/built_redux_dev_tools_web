import 'dart:html';
import 'dart:async';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';

class OverlayProps {
  VNode content;
}

class OverlayState {
  int left;
  int draggingLeft;
  bool dragging;
}

class Overlay extends Component<OverlayProps, OverlayState> {
  StreamSubscription _moveSub;
  StreamSubscription _upSub;

  Overlay(props) : super(props);

  @override
  OverlayState getInitialState() => new OverlayState()
    ..left = -1
    ..draggingLeft = -1
    ..dragging = false;

  render() {
    return new VDivElement()
      ..children = [
        new VDivElement()
          ..styleBuilder = ((CssStyleDeclaration d) => d
            ..position = 'absolute'
            ..width = state.left == -1 ? '700px' : '${state.left}px'
            ..top = '0'
            ..height = '100%'
            ..backgroundColor = '#FFFFFF'
            ..zIndex = '999998')
          ..children = [props.content, sideBar()],
        ghostBar(),
      ];
  }

  VNode sideBar() => new VSpanElement()
    ..styleBuilder = ((CssStyleDeclaration d) => d
      ..height = '100%'
      ..position = 'absolute'
      ..top = '0'
      ..left = state.left == -1 ? '100%' : '${state.left}px'
      ..backgroundColor = 'black'
      ..width = '3px'
      ..cursor = 'col-resize')
    ..onMouseDown = _mouseDown
    ..draggable = false;

  VNode ghostBar() => new VSpanElement()
    ..styleBuilder = ((CssStyleDeclaration d) => d
      ..height = '100%'
      ..position = 'absolute'
      ..backgroundColor = 'black'
      ..top = '0'
      ..width = '3px'
      ..left = state.draggingLeft == -1 ? '100%' : '${state.draggingLeft}px'
      ..opacity = '0.5'
      ..cursor = 'col-resize'
      ..zIndex = '999999');

  void _mouseDown(MouseEvent e) {
    _moveSub = document.onMouseMove.listen(_mouseMove);
    _upSub = document.onMouseUp.listen(_mouseUp);
    e.preventDefault();
    setStateOnIdle((_, s) => new OverlayState()
      ..dragging = true
      ..left = s.left
      ..draggingLeft = e.page.x + 2);
  }

  void _mouseUp(MouseEvent e) {
    _moveSub?.cancel();
    _upSub?.cancel();
    setStateOnIdle((_, s) => new OverlayState()
      ..dragging = false
      ..left = s.draggingLeft
      ..draggingLeft = -1);
  }

  void _mouseMove(MouseEvent e) {
    setStateOnIdle((_, s) => new OverlayState()
      ..dragging = s.dragging
      ..left = s.left
      ..draggingLeft = e.page.x);
  }
}
