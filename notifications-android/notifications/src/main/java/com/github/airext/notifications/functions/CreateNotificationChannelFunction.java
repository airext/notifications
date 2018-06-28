package com.github.airext.notifications.functions;

import android.app.Activity;
import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;
import com.github.airext.Notifications;
import com.github.airext.notifications.NotificationCenter;
import com.github.airext.notifications.utils.ConversionRoutines;

public class CreateNotificationChannelFunction implements FREFunction {

    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        Log.d(Notifications.TAG, "CreateNotificationChannelFunction");

        String id;
        String name;
        int importance;
        boolean enableLights;
        int lightColor;
        boolean enableVibration;
        long[] vibrationPattern;

        try {
            FREObject channel = args[0];
            id               = channel.getProperty("id").getAsString();
            name             = channel.getProperty("name").getAsString();
            importance       = channel.getProperty("importance").getAsInt();
            enableLights     = channel.getProperty("enableLights").getAsBool();
            lightColor       = channel.getProperty("lightColor").getAsInt();
            enableVibration  = channel.getProperty("enableVibration").getAsBool();
            vibrationPattern = ConversionRoutines.convertFREObjectToLongs(channel.getProperty("vibrationPattern"));
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }

        Activity activity = context.getActivity();

        boolean result = NotificationCenter.createNotificationChannel(activity, id, name, importance, enableLights, lightColor, enableVibration, vibrationPattern);

        try {
            return FREObject.newObject(result);
        } catch (FREWrongThreadException e) {
            e.printStackTrace();
            return null;
        }
    }
}
