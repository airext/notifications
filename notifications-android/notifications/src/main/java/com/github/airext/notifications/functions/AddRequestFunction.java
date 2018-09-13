package com.github.airext.notifications.functions;

import android.app.Activity;
import android.app.Notification;
import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.github.airext.Notifications;
import com.github.airext.bridge.Bridge;
import com.github.airext.bridge.Call;
import com.github.airext.notifications.NotificationCenter;
import com.github.airext.notifications.utils.ConversionRoutines;
import com.github.airext.notifications.utils.DispatchQueue;

import java.util.Calendar;

/**
 * Created by max on 12/3/17.
 */

public class AddRequestFunction implements FREFunction {

    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        Log.d(Notifications.TAG, "AddRequestFunction");

        Activity activity = context.getActivity();

        int identifier      = 0;
        String title        = null;
        String body         = null;
        String soundName    = null;
        int color           = Notification.COLOR_DEFAULT;
        String userInfo     = null;
        double timeInterval = 0.0;
        String channelId    = null;
        Boolean exactTime   = false;

        try {
            FREObject request = args[0];
            FREObject content = request.getProperty("content");
            FREObject trigger = request.getProperty("trigger");

            identifier = ConversionRoutines.readIntPropertyFrom(request, "identifier", 0);
            channelId  = ConversionRoutines.readStringPropertyFrom(request, "channelId");

            title = ConversionRoutines.readStringPropertyFrom(content, "title");
            body  = ConversionRoutines.readStringPropertyFrom(content, "body");
            color = ConversionRoutines.readIntPropertyFrom(content, "color", Notification.COLOR_DEFAULT);

            FREObject sound = content.getProperty("sound");
            if (sound != null) {
                soundName = ConversionRoutines.readStringPropertyFrom(sound, "named");
            }

            FREObject userInfoAsFREObject = content.callMethod("userInfoAsJSON", null);
            if (userInfoAsFREObject != null) {
                userInfo = userInfoAsFREObject.getAsString();
            }

            if (trigger != null) {
                timeInterval = ConversionRoutines.readDoublePropertyFrom(trigger, "timeInterval", 0);
                exactTime    = ConversionRoutines.readBooleanPropertyFrom(trigger, "exactTime", false);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        final Call call = Bridge.call(context);

        if (timeInterval < 0) {
            timeInterval = 0;
        }

        Calendar calendar = Calendar.getInstance();
        long timestamp = calendar.getTimeInMillis() + (long)timeInterval * 1000;

        NotificationCenter.scheduleNotification(activity, identifier, timestamp, title, body, soundName, color, userInfo, channelId, exactTime);

        DispatchQueue.dispatch_async(activity, new Runnable() {
            @Override
            public void run() {
                call.result(true);
            }
        });

        return call.toFREObject();
    }
}
