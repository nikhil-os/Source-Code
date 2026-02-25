package com.webtimemovieocean.app;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
// COMPLETE: Import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.android.FlutterFragmentActivity;


// COMPLETE: Import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin;

public class MainActivity extends FlutterFragmentActivity{

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        // TODO: Register the ListTileNativeAdFactory
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "listTile",
                new com.webtimemovieocean.app.ListTileNativeAdFactory(this));
    }

    @Override
    public void cleanUpFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine);

        // TODO: Unregister the ListTileNativeAdFactory
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "listTile");
    }

    @Override
    public void onPointerCaptureChanged(boolean hasCapture) {
        super.onPointerCaptureChanged(hasCapture);
    }
}

