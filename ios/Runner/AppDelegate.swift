import Flutter
import Security
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var privacyOverlay: UIVisualEffectView?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "LocalCryptoPlugin")
    let channel = FlutterMethodChannel(
      name: "malomati/local_crypto",
      binaryMessenger: registrar.messenger()
    )
    channel.setMethodCallHandler { call, result in
      guard call.method == "getHiveKey" else {
        result(FlutterMethodNotImplemented)
        return
      }
      result(FlutterStandardTypedData(bytes: LocalCrypto.getOrCreateHiveKey()))
    }
  }

  override func applicationWillResignActive(_ application: UIApplication) {
    super.applicationWillResignActive(application)
    UIPasteboard.general.items = []
    showPrivacyOverlay()
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
    super.applicationDidBecomeActive(application)
    hidePrivacyOverlay()
  }

  override func applicationDidEnterBackground(_ application: UIApplication) {
    super.applicationDidEnterBackground(application)
    UIPasteboard.general.items = []
    showPrivacyOverlay()
  }

  private func showPrivacyOverlay() {
    if privacyOverlay?.superview != nil { return }
    let windows = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
    guard let window = windows.first(where: { $0.isKeyWindow }) ?? windows.first else {
      return
    }
    let blur = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    blur.frame = window.bounds
    blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    window.addSubview(blur)
    privacyOverlay = blur
  }

  private func hidePrivacyOverlay() {
    privacyOverlay?.removeFromSuperview()
    privacyOverlay = nil
  }
}

private enum LocalCrypto {
  private static let service = "com.gov.uaq.hrm.localcrypto"
  private static let account = "hive_aes256_gcm_key"

  static func getOrCreateHiveKey() -> Data {
    if let existing = load() { return existing }
    var bytes = Data(count: 32)
    let status = bytes.withUnsafeMutableBytes { buf in
      SecRandomCopyBytes(kSecRandomDefault, 32, buf.baseAddress!)
    }
    if status != errSecSuccess {
      bytes = Data((0..<32).map { _ in UInt8.random(in: 0...255) })
    }
    save(bytes)
    return bytes
  }

  private static func load() -> Data? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account,
      kSecReturnData as String: true,
      kSecMatchLimit as String: kSecMatchLimitOne,
    ]
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    guard status == errSecSuccess else { return nil }
    return item as? Data
  }

  private static func save(_ data: Data) {
    let deleteQuery: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account,
    ]
    SecItemDelete(deleteQuery as CFDictionary)
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account,
      kSecValueData as String: data,
      kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
    ]
    SecItemAdd(query as CFDictionary, nil)
  }
}
