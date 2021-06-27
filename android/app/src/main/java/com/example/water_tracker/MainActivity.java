package com.example.water_tracker;

import android.annotation.TargetApi;
import android.app.Notification;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.SharedPreferences;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Bundle;
import android.os.VibrationEffect;
import android.util.Log;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Build;
import android.view.KeyEvent;
import android.widget.Toast;
import android.os.Vibrator;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.flutter_application_1/powerBtnCount";
    private static final String STREAM = "com.example.flutter_application_1/stream";
    private static final String CHANNEL_DEFAULT_IMPORTANCE = "MyChannel";
    private static final int ONGOING_NOTIFICATION_ID = 420;

    private EventChannel.EventSink mEvents = null;
    private BroadcastReceiver mReceiver;
    private SensorEventListener sensorEventListener;

    private SensorManager mSensorManager;
    private float mAccel; // acceleration apart from gravity
    private float mAccelCurrent; // current acceleration including gravity
    private float mAccelLast; // last acceleration including gravity
    private long lastUpdate = 0;
    private int shakeThreshold = 1000; // time between shakes in ms
    private int vibrationFeedbackDuration = 400; // ms

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
                        mEvents = events;
                    }

                    @Override
                    public void onCancel(Object args) {}

                });
    }

    private int getPowerBtnCounter() {
        SystemIntentReceiver receiver = (SystemIntentReceiver) mReceiver;
        return receiver.getCount();
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        startForegroundService();

        IntentFilter powerBtnFilter = new IntentFilter(Intent.ACTION_SCREEN_ON);
        powerBtnFilter.addAction(Intent.ACTION_SCREEN_OFF);
        mReceiver = new SystemIntentReceiver();
        registerReceiver(mReceiver, powerBtnFilter);

        mSensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
        mSensorManager.registerListener(mSensorListener, mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER),
                SensorManager.SENSOR_DELAY_NORMAL);
        mAccel = 0.00f;
        mAccelCurrent = SensorManager.GRAVITY_EARTH;
        mAccelLast = SensorManager.GRAVITY_EARTH;

    }

    @TargetApi(Build.VERSION_CODES.O)
    private void startForegroundService() {
        Intent notificationIntent = new Intent(this, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, 0);

        Notification notification = new Notification.Builder(this, CHANNEL_DEFAULT_IMPORTANCE)
                .setContentTitle("MyTitle")
                .setContentText("MyContentTest")
                .setContentIntent(pendingIntent).setTicker("MyTickerText").build();

        // Notification ID cannot be 0.
        //startForeground(ONGOING_NOTIFICATION_ID, notification);
    }

    @Override
    protected void onPause() {
        // when the screen is about to turn off
        if (SystemIntentReceiver.wasScreenOn) {
            // this is the case when onPause() is called by the system due to a screen state
            // change
            System.out.println("App onPause");

        } else {
            // this is when onPause() is called when the screen state has not changed
        }
        super.onPause();
    }

    @Override
    protected void onResume() {
        System.out.println("App onResume");
        if (mEvents != null) {
            mEvents.success("power," + getPowerBtnCounter());
        }
        // only when screen turns on
        if (!SystemIntentReceiver.wasScreenOn) {
            // this is when onResume() is called due to a screen state change
            System.out.println("SCREEN WAS OFF");
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

    private final SensorEventListener mSensorListener = new SensorEventListener() {

        @TargetApi(Build.VERSION_CODES.CUPCAKE)
        public void onSensorChanged(SensorEvent se) {
            long curTime = System.currentTimeMillis();
            if ((curTime - lastUpdate) > shakeThreshold) {
                lastUpdate = curTime;

                float x = se.values[0];
                float y = se.values[1];
                float z = se.values[2];
                mAccelLast = mAccelCurrent;
                mAccelCurrent = (float) Math.sqrt((double) (x * x + y * y + z * z));
                float delta = mAccelCurrent - mAccelLast;
                mAccel = mAccel * 0.9f + delta; // perform low-cut filter

                if (mAccel > 7) {
                    SharedPreferences prefs = getSharedPreferences("FlutterSharedPreferences", MODE_PRIVATE);
                    boolean shake = prefs.getBoolean("flutter.shake", false);//"No name defined" is the default value.
                    if(shake) {

                        vibrate();
                        if (mEvents != null) {
                            mEvents.success("shake,1");
                        } else {
                            Log.d("sensorListener", "mEvents is null");
                        }
                    }
                }
            }

        }

        public void onAccuracyChanged(Sensor sensor, int accuracy) {}

        public void vibrate() {
            Vibrator v = (Vibrator) getSystemService(Context.VIBRATOR_SERVICE);
            // Vibrate for 500 milliseconds
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                v.vibrate(VibrationEffect.createOneShot(vibrationFeedbackDuration, VibrationEffect.DEFAULT_AMPLITUDE));
            } else {
                // deprecated in API 26
                v.vibrate(vibrationFeedbackDuration);
            }
        }
    };
}
