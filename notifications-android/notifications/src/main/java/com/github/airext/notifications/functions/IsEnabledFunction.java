package com.github.airext.notifications.functions;

import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;
import com.github.airext.notifications.NotificationCenter;

/**
 * Created by max on 12/6/17.
 */

public class IsEnabledFunction implements com.adobe.fre.FREFunction {
    private static final String TAG = "NotificationCenter";

    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        Log.d(TAG, "IsEnabledFunction");

        try {
            return FREObject.newObject(NotificationCenter.isEnabled(context.getActivity()));
        } catch (FREWrongThreadException e) {
            e.printStackTrace();
        }
        return null;
    }
}
