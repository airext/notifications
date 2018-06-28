package com.github.airext.notifications.functions;

import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;
import com.github.airext.Notifications;
import com.github.airext.notifications.NotificationCenter;

/**
 * Created by max on 12/3/17.
 */

public class IsSupportedFunction implements FREFunction {
    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        Log.d(Notifications.TAG, "IsSupportedFunction");

        try {
            return FREObject.newObject(NotificationCenter.isSupported());
        } catch (FREWrongThreadException e) {
            e.printStackTrace();
        }
        return null;
    }
}
