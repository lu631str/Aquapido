package com.example.water_tracker;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;

public class WaterAddService extends Service {

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        return super.onStartCommand(intent, flags, startId);
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
