package com.github.airext.notifications.functions;

import android.app.Activity;
import android.util.Log;
import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.github.airext.Notifications;
import com.github.airext.notifications.NotificationCenter;

/**
 * Created by max on 12/3/17.
 */

public class RemovePendingNotificationRequestsFunction implements FREFunction {
    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        Log.d(Notifications.TAG, "RemovePendingNotificationRequestsFunction");

        Activity activity = context.getActivity();

        try {
            FREArray identifiers = (FREArray) args[0];
            for (long i = 0; i < identifiers.getLength(); i++) {
                NotificationCenter.removePendingNotificationWithId(activity, identifiers.getObjectAt(i).getAsInt());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
