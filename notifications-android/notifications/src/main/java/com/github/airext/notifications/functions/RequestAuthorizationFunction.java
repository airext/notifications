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

/**
 * Created by max on 12/3/17.
 */

public class RequestAuthorizationFunction implements FREFunction {

    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        Log.d(Notifications.TAG, "RequestAuthorizationFunction");

        final Activity activity = context.getActivity();

        final Call call = Bridge.call(context);

        int options = 0;

        if (args.length > 0) {
            try {
                options = args[0].getAsInt();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        NotificationCenter.requestAuthorizationWithOptions(activity, options, new NotificationCenter.AuthorizationStatusListener() {
            @Override
            public void onStatus(String status) {
                call.result(status);
            }
        });

        return call.toFREObject();
    }
}
