enum BuildMode {
  DEBUG,
  PROFILE,
  RELEASE,
}

class DeviceUtils {
  static BuildMode currentBuildMode() {
    if (const bool.fromEnvironment('dart.vm.product')) {
      return BuildMode.RELEASE;
    }
    var result = BuildMode.PROFILE;
    assert(() {
      result = BuildMode.DEBUG;
      return true;
    }());
    return result;
  }
}
