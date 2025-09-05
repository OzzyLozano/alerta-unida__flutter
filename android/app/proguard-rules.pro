# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# SLF4J - Para Pusher
-keep class org.slf4j.** { *; }
-keep class * implements org.slf4j.spi.SLF4JServiceProvider { *; }
-keep class org.slf4j.impl.StaticLoggerBinder { *; }

# Pusher Channels
-keep class com.pusher.** { *; }
-keep class io.flutter.plugins.pusher.** { *; }

# Otras clases necesarias
-keep class * extends java.util.logging.Logger { *; }
-keep class * extends org.slf4j.Logger { *; }
