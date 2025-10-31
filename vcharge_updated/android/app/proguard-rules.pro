# --- RAZORPAY FIX ---
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**
-keep class proguard.annotation.Keep
-keep class proguard.annotation.KeepClassMembers
# --- FIX FOR MISSING GOOGLE PLAY CORE CLASSES ---
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.play.core.splitcompat.SplitCompatApplication { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallManager { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallManagerFactory { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallRequest { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallRequest$Builder { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallSessionState { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallException { *; }
-keep class com.google.android.play.core.tasks.** { *; }


# --- FLUTTER CORE CLASSES ---
-keep class io.flutter.app.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }

# --- ANDROIDX ---
-keep class androidx.** { *; }
-dontwarn androidx.**

# --- FIREBASE (if present) ---
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# --- GSON / JSON reflection (if used) ---
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**

# --- Prevent removing model/data classes ---
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}
