package com.github.airext.notifications.functions;

import android.app.Activity;
import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.github.airext.Notifications;
import com.github.airext.bridge.Bridge;
import com.github.airext.bridge.Call;
import com.github.airext.notifications.NotificationCenter;
import com.github.airext.notifications.data.TriggerDate;
import com.github.airext.notifications.utils.DispatchQueue;

import java.util.Date;

public class NextTriggerDateForRequestFunction implements com.adobe.fre.FREFunction {

    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        Log.d(Notifications.TAG, "NextTriggerDateForRequestFunction");

        Activity activity = context.getActivity();

        final Call call = Bridge.call(context);

        try {

            int identifier = args[0].getAsInt();

            final Date result = NotificationCenter.nextTriggerDateForPendingNotification(activity, identifier);

            DispatchQueue.dispatch_async(activity, new Runnable() {
                @Override
                public void run() {
                    call.result(new TriggerDate(result));
                }
            });

        } catch (Exception e) {
            e.printStackTrace();
        }

        return call.toFREObject();
    }
}
