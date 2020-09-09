typedef void _Consumer<T>(T arg);

class OnceFunction<T> {
  _Consumer<T> _function;

  void registerOnce(_Consumer<T> fn) {
    if (_function != null) print('WARN: OnceCallback _callback!=null when set');
    _function = fn;
  }

  void callAndRemove(T arg) {
    print('OnceFunction callAndRemove $arg');
    if (_function != null) print('WARN: OnceCallback _callback==null when call');
    _function?.call(arg);
    _function = null;
  }
}
