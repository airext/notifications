package com.github.airext.notifications.functions;

import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.github.airext.Notifications;
import com.github.airext.notifications.NotificationCenter;

/**
 * Created by max on 12/5/17.
 */

public class InBackgroundFunction implements com.adobe.fre.FREFunction {
    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        Log.d(Notifications.TAG, "InBackgroundFunction");
        NotificationCenter.inBackground();
        return null;
    }
}
