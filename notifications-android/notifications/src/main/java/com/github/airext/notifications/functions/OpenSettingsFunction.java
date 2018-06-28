package com.github.airext.notifications.functions;

import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.github.airext.Notifications;
import com.github.airext.notifications.NotificationCenter;

/**
 * Created by max on 12/6/17.
 */

public class OpenSettingsFunction implements com.adobe.fre.FREFunction {
    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        Log.d(Notifications.TAG, "OpenSettingsFunction");
        NotificationCenter.openSettings(context.getActivity());
        return null;
    }
}
