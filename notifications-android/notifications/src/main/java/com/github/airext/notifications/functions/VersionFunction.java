package com.github.airext.notifications.functions;

import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;
import com.github.airext.Notifications;

public class VersionFunction implements FREFunction {
    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        Log.d(Notifications.TAG, "RequestAuthorizationFunction");
        try {
            return FREObject.newObject("12");
        } catch (FREWrongThreadException e) {
            e.printStackTrace();
        }
        return null;
    }
}
