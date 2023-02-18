class Event {
  String type = '';
  String url = '';
  String name = '';
  String? value;
  Map<String, String> props = {};

  Event({
    this.type = '',
    this.url = '',
    this.name = '',
    this.value,
    this.props = const {},
  });

  Event addProp(String key, String value) {
    props[key] = value;
    return this;
  }

  String? removeProp(String key) {
    return props.remove(key);
  }

  String? getProp(String key) {
    return props[key];
  }
}
