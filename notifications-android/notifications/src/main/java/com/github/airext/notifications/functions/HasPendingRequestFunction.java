package com.github.airext.notifications.functions;

import android.util.Log;
import com.adobe.fre.*;
import com.github.airext.Notifications;
import com.github.airext.bridge.Bridge;
import com.github.airext.bridge.Call;
import com.github.airext.notifications.NotificationCenter;

public class HasPendingRequestFunction implements FREFunction {

    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        Log.d(Notifications.TAG, "HasPendingRequestFunction");

        final Call call = Bridge.call(context);

        try {
            int identifier = args[0].getAsInt();
            call.result(FREObject.newObject(NotificationCenter.hasPendingNotificationRequestWithId(context.getActivity(), identifier)));
        } catch (Exception e) {
            call.reject(e.getMessage());
            e.printStackTrace();
        }

        return call.toFREObject();
    }
}
