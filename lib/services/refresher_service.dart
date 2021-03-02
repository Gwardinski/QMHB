import 'dart:async';

class RefresherService {
  StreamController<bool> _controller = StreamController<bool>();
  Stream refreshListener;

  RefresherService() {
    refreshListener = _controller.stream;
  }

  callRefresh() {
    _controller.add(true);
  }
}
