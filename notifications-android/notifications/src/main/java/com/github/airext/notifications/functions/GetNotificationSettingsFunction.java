package com.github.airext.notifications.functions;

import android.app.Activity;
import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.github.airext.Notifications;
import com.github.airext.bridge.Bridge;
import com.github.airext.bridge.Call;
import com.github.airext.notifications.NotificationCenter;
import com.github.airext.notifications.data.NotificationCenterSettings;

/**
 * Created by max on 12/3/17.
 */

public class GetNotificationSettingsFunction implements FREFunction {
    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        Log.d(Notifications.TAG, "GetNotificationSettingsFunction");

        Activity activity = context.getActivity();

        final Call call = Bridge.call(context);

        NotificationCenter.getNotificationSettings(activity, new NotificationCenter.NotificationSettingsListener() {
            @Override
            public void onSettings(NotificationCenterSettings settings) {
                call.result(settings);
            }
        });

        return call.toFREObject();
    }
}