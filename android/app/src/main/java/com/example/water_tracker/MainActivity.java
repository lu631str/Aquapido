package com.example.water_tracker;

import java.util.Observable;

import android.content.BroadcastReceiver;
import android.os.Bundle;
import android.util.Log;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build;
import android.view.KeyEvent;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.flutter_application_1/powerBtnCount";
    private static final String STREAM = "com.example.flutter_application_1/stream";

    EventChannel.EventSink mEvents = null;
    BroadcastReceiver mReceiver;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    // Note: this method is invoked on the main thread.
                    if (call.method.equals("getPowerBtnCount")) {
                        int count = getPowerBtnCounter();
                        if (count != -1) {
                            result.success(count);
                        } else {
                            result.error(String.valueOf(-1), "Cannot get count.", null);
                        }
                    } else {
                        result.notImplemented();
                    }
                });

        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), STREAM)
                .setStreamHandler(new EventChannel.StreamHandler() {

                    @Override
                    public void onListen(Object args, EventChannel.EventSink events) {
                        Log.w("TAG", "adding listener");
                        mEvents = events;
                    }

                    @Override
                    public void onCancel(Object args) {
                        Log.w("TAG", "cancelling listener");
                    }

                });
    }

    private int getPowerBtnCounter() {
        SystemIntentReceiver receiver = (SystemIntentReceiver) mReceiver;
        return receiver.getCount();
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        IntentFilter filter = new IntentFilter(Intent.ACTION_SCREEN_ON);
        filter.addAction(Intent.ACTION_SCREEN_OFF);
        mReceiver = new SystemIntentReceiver();
        registerReceiver(mReceiver, filter);
    }

    @Override
    protected void onPause() {
        // when the screen is about to turn off
        if (SystemIntentReceiver.wasScreenOn) {
            // this is the case when onPause() is called by the system due to a screen state
            // change
            System.out.println("SCREEN TURNED OFF");

        } else {
            // this is when onPause() is called when the screen state has not changed
        }
        super.onPause();
    }

    @Override
    protected void onResume() {
        if(mEvents != null) {
            mEvents.success(getPowerBtnCounter());
        }
        // only when screen turns on
        if (!SystemIntentReceiver.wasScreenOn) {
            // this is when onResume() is called due to a screen state change
            System.out.println("SCREEN TURNED ON");
        } else {
            // this is when onResume() is called when the screen state has not changed
        }
        super.onResume();
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_POWER) {
            // Do something here...
            Log.d("onKeyDown", "KEYCODE_POWER");
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }
}
