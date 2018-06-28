package com.github.airext.notifications;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.github.airext.notifications.functions.*;

import java.util.HashMap;
import java.util.Map;

public class ExtensionContext extends FREContext {

    @Override
    public Map<String, FREFunction> getFunctions() {
        Map<String, FREFunction> functions = new HashMap<>();

        functions.put("isSupported", new IsSupportedFunction());
        functions.put("getNotificationSettings", new GetNotificationSettingsFunction());
        functions.put("requestAuthorization", new RequestAuthorizationFunction());
        functions.put("addRequest", new AddRequestFunction());
        functions.put("removePendingNotificationRequests", new RemovePendingNotificationRequestsFunction());
        functions.put("removeAllPendingNotificationRequests", new RemoveAllPendingNotificationRequestsFunction());
        functions.put("inBackground", new InBackgroundFunction());
        functions.put("inForeground", new InForegroundFunction());
        functions.put("isEnabled", new IsEnabledFunction());
        functions.put("canOpenSettings", new CanOpenSettingsFunction());
        functions.put("openSettings", new OpenSettingsFunction());
        functions.put("createNotificationChannel", new CreateNotificationChannelFunction());

        return functions;
    }

    @Override
    public void dispose() {

    }
}
