package com.example.water_tracker;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.widget.Toast;

class SystemIntentReceiver extends BroadcastReceiver {

    public static boolean wasScreenOn = true;
    private int doublePressThreshold = 800; // in ms
    static long prevTime = 0;
    static long currTime = 0;
    private int count = 0;

    @Override
    public void onReceive(Context context, Intent intent) {

        if (intent.getAction().equals(Intent.ACTION_SCREEN_OFF)) {
            // do whatever you need to do here
            prevTime = System.currentTimeMillis();
            Log.d("CHECK IN RECIVE WHEN ON", "CHECK IN RECIVER WHEN ON");
            wasScreenOn = false;
        } else if (intent.getAction().equals(Intent.ACTION_SCREEN_ON)) {
            // and do whatever you need to do here
            Log.d("CHECK IN RECIVE WHEN ON", "CHECK IN RECIVER WHEN OFF");
            currTime = System.currentTimeMillis();
            wasScreenOn = true;
        }
        if (currTime > 0 && prevTime > 0) {
            if ((currTime - prevTime) < doublePressThreshold && (currTime - prevTime) > -doublePressThreshold) {
                count++;
                Toast.makeText(context, "double Clicked power button", Toast.LENGTH_LONG).show();
                Log.e("eciver ", "double Clicked power button");
                currTime = 0;
                prevTime = 0;
            }
        }
    }

    public int getCount() {
        int tmp = count;
        count = 0;
        return tmp;
    }
}