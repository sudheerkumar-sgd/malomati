# ---------------------------------------------------------------------------
# flutter_local_notifications (release minify strips GSON metadata otherwise)
# Scheduled notifications serialize NotificationDetails via Gson — without these
# rules, debug works and release silently fails to deliver.
# ---------------------------------------------------------------------------
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**

-keep class com.dexterous.flutterlocalnotifications.** { *; }
-dontwarn com.dexterous.flutterlocalnotifications.**

-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

-keep,allowobfuscation,allowshrinking class com.google.gson.reflect.TypeToken
-keep,allowobfuscation,allowshrinking class * extends com.google.gson.reflect.TypeToken

# Keep model fields used when restoring scheduled notifications after reboot
-keepclassmembers class com.dexterous.flutterlocalnotifications.models.** {
  <fields>;
}

# ---------------------------------------------------------------------------
# Workmanager (Android backup for work-hours notification)
# ---------------------------------------------------------------------------
-keep class androidx.work.** { *; }
-keep class com.google.common.util.concurrent.** { *; }
-dontwarn androidx.work.**

# ---------------------------------------------------------------------------
# Flutter
# ---------------------------------------------------------------------------
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# ---------------------------------------------------------------------------
# Play Core (deferred components) — referenced by Flutter embedding but not
# shipped unless you use Play Feature Delivery. R8 fails release without these.
# From build/app/outputs/mapping/*/missing_rules.txt
# ---------------------------------------------------------------------------
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task
