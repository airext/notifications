package com.github.airext.notifications.receivers;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import com.github.airext.notifications.NotificationCenter;

/**
 * Created by max on 12/3/17.
 */

public class LocalNotificationBroadcastReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        NotificationCenter.handleAlarmReceived(context, intent);
    }
}
