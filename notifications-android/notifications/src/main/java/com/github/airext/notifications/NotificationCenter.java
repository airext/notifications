package com.github.airext.notifications;

import android.Manifest;
import android.app.*;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;
import android.util.Log;
import com.github.airext.Notifications;
import com.github.airext.notifications.data.NotificationCenterSettings;
import com.github.airext.notifications.receivers.LocalNotificationBroadcastReceiver;
import com.github.airext.notifications.triggers.NotificationTrigger;
import com.github.airext.notifications.utils.*;

import java.io.File;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Calendar;
import java.util.Date;

import static android.content.Context.ALARM_SERVICE;

/**
 * Created by max on 12/4/17.
 */

public class NotificationCenter {

    private static final String TAG = "ANXNotifications";

    // Keys

    private static final String identifierKey = "com.github.airext.notifications.NotificationCenter.identifier";
    private static final String titleKey      = "com.github.airext.notifications.NotificationCenter.title";
    private static final String bodyKey       = "com.github.airext.notifications.NotificationCenter.body";
    private static final String soundKey      = "com.github.airext.notifications.NotificationCenter.sound";
    private static final String colorKey      = "com.github.airext.notifications.NotificationCenter.color";
    private static final String userInfoKey   = "com.github.airext.notifications.NotificationCenter.params";
    private static final String channelIdKey  = "com.github.airext.notifications.NotificationCenter.channelId";
    private static final String triggerAtKey  = "com.github.airext.notifications.NotificationCenter.triggerAt";
    private static final String intervalKey   = "com.github.airext.notifications.NotificationCenter.timeInterval";
    private static final String repeatsKey    = "com.github.airext.notifications.NotificationCenter.repeats";

    private static final int REQUEST_PERMISSIONS_CODE = 42;

    // Availability & Permissions

    public static Boolean isSupported() {
        return true;
    }

    public static String permissionStatus(Context context) {
        Log.w(TAG, "Please use com.github.airext.Permissions ANE to check permission status on Android.");
        return "unknown";
    }

    public static void requestAuthorizationWithOptions(final Activity activity, int options, final AuthorizationStatusListener listener) {
        Log.w(TAG, "Please use com.github.airext.Permissions ANE to request permission status on Android.");

        if (listener != null) {
            listener.onStatus("unknown");
        }
    }

    public static Boolean isEnabled(Context context) {
        Log.d(TAG, "isEnabled");

        if (Build.VERSION.SDK_INT >= 24) {
            NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
            if (notificationManager != null) {
                return notificationManager.areNotificationsEnabled();
            } else {
                return false;
            }
        } else if (Build.VERSION.SDK_INT >= 19) {
            AppOpsManager appOps = (AppOpsManager) context.getSystemService(Context.APP_OPS_SERVICE);
            ApplicationInfo appInfo = context.getApplicationInfo();
            String pkg = context.getApplicationContext().getPackageName();
            int uid = appInfo.uid;
            try {
                Class<?> appOpsClass = Class.forName(AppOpsManager.class.getName());
                Method checkOpNoThrowMethod = appOpsClass.getMethod("checkOpNoThrow", Integer.TYPE, Integer.TYPE, String.class);
                Field opPostNotificationValue = appOpsClass.getDeclaredField("OP_POST_NOTIFICATION");
                int value = (Integer) opPostNotificationValue.get(Integer.class);
                return ((Integer) checkOpNoThrowMethod.invoke(appOps, value, uid, pkg) == AppOpsManager.MODE_ALLOWED);
            } catch (ClassNotFoundException | NoSuchMethodException | NoSuchFieldException | InvocationTargetException | IllegalAccessException | RuntimeException e) {
                return true;
            }
        } else {
            return true;
        }
    }

    public static Boolean canOpenSettings(Context context) {
        Log.d(TAG, "canOpenSettings");

        Intent intent = new Intent(Settings.ACTION_CHANNEL_NOTIFICATION_SETTINGS);
        Uri uri = Uri.fromParts("package", context.getPackageName(), null);
        intent.setData(uri);
        return intent.resolveActivity(context.getPackageManager()) != null;
    }

    public static void openSettings(Context context) {
        Log.d(TAG, "openSettings");

        Intent intent = new Intent(Settings.ACTION_CHANNEL_NOTIFICATION_SETTINGS);
        Uri uri = Uri.fromParts("package", context.getPackageName(), null);
        intent.setData(uri);
        context.startActivity(intent);
    }

    // Background / Foreground

    private static Boolean _isInForeground = false;
    public static Boolean isInForeground() {
        return _isInForeground;
    }

    public static void inForeground(Context context, Intent intent) {
        Log.d(TAG, "inForeground");

        _isInForeground = true;

        notifyAppWithDataIfAvailable(context, intent, false);
    }
    public static void inBackground() {
        Log.d(TAG, "inBackground");

        _isInForeground = false;
    }

    // API: Settings

    public static void getNotificationSettings(Activity activity, final NotificationSettingsListener listener) {
        Log.d(TAG, "getNotificationSettings");

        final String authorizationStatus = permissionStatus(activity);
        if (listener != null) {
            DispatchQueue.dispatch_async(activity, new Runnable() {
                @Override
                public void run() {
                    listener.onSettings(new NotificationCenterSettings(authorizationStatus));
                }
            });
        }
    }

    // API: Notifications

    // MARK: Notification channel

    public static boolean createNotificationChannel(Context context, String id, String name) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N) {
            return false;
        }

        return createNotificationChannel(context, id, name, NotificationManager.IMPORTANCE_DEFAULT, true, Color.YELLOW, true, new long[]{100, 200, 300, 400, 500, 400, 300, 200, 400});
    }

    public static boolean createNotificationChannel(Context context, String id, String name, int importance, boolean enableLights, int lightColor, boolean enableVibration, long[] vibrationPattern) {
        if (android.os.Build.VERSION.SDK_INT < android.os.Build.VERSION_CODES.O) {
            return false;
        }

        if (vibrationPattern == null || vibrationPattern.length == 0) {
            vibrationPattern = new long[]{100, 200, 300, 400, 500, 400, 300, 200, 400};
        }

        NotificationChannel channel = new NotificationChannel(id, name, importance);
        channel.enableLights(enableLights);
        channel.setLightColor(lightColor);
        channel.enableVibration(enableVibration);
        channel.setVibrationPattern(vibrationPattern);

        NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        notificationManager.createNotificationChannel(channel);

        return true;
    }

    // MARK: Schedule notification

    public static void scheduleNotification(Context context, int identifier, NotificationTrigger trigger, String title, String body, String sound, int color, String userInfo, String channelId) {
        Log.d(TAG, "scheduleNotification(" + identifier + ", " + trigger + ", " + title + ", " + body + ", " + sound + ", " + color + ", " + userInfo + ", " + channelId + ")");

        // cancel already scheduled reminders
        removePendingNotificationWithId(context, identifier);

        // Enable a receiver

        ComponentName receiver = new ComponentName(context, LocalNotificationBroadcastReceiver.class);
        PackageManager pm = context.getPackageManager();

        pm.setComponentEnabledSetting(receiver, PackageManager.COMPONENT_ENABLED_STATE_ENABLED, PackageManager.DONT_KILL_APP);

        long triggerAt = trigger.getTriggerAt();
        long interval  = trigger.getTriggerInterval();

        Intent intent = new Intent(context, LocalNotificationBroadcastReceiver.class);
        intent.putExtra(identifierKey, identifier);
        intent.putExtra(titleKey, title);
        intent.putExtra(bodyKey, body);
        intent.putExtra(soundKey, sound);
        intent.putExtra(colorKey, color);
        intent.putExtra(userInfoKey, userInfo);
        intent.putExtra(channelIdKey, channelId);
        intent.putExtra(triggerAtKey, triggerAt);
        intent.putExtra(intervalKey, interval);
        intent.putExtra(repeatsKey, trigger.shouldRepeat());

        PendingIntent pendingIntent = PendingIntent.getBroadcast(context, identifier, intent, PendingIntent.FLAG_UPDATE_CURRENT);

        AlarmManager alarmManager = (AlarmManager) context.getSystemService(ALARM_SERVICE);
        if (alarmManager == null) {
            Log.e(TAG, "Can't get AlarmManager");
            return;
        }

        if (trigger.shouldRepeat()) {
            if (trigger.isExactTime()) {
                alarmManager.setRepeating(AlarmManager.RTC_WAKEUP, triggerAt, interval, pendingIntent);
            } else {
                alarmManager.setInexactRepeating(AlarmManager.RTC_WAKEUP, triggerAt, interval, pendingIntent);
            }
        } else {
            if (trigger.isExactTime()) {
                alarmManager.setExact(AlarmManager.RTC_WAKEUP, triggerAt, pendingIntent);
            } else {
                alarmManager.set(AlarmManager.RTC_WAKEUP, triggerAt, pendingIntent);
            }
        }

        NotificationStorage storage = NotificationStorage.getInstance(context);
        storage.set(intent, identifier);

        Log.d(TAG, "Scheduled notification with id: '"+identifier+"', triggerAt: " + triggerAt + ", interval: " + interval);
    }

    public static void removePendingNotificationWithId(Context context, int identifier) {
        Log.d(TAG, "removePendingNotificationWithId");

        NotificationStorage storage = NotificationStorage.getInstance(context);
        storage.remove(identifier);

        ComponentName receiver = new ComponentName(context, LocalNotificationBroadcastReceiver.class);
        PackageManager pm = context.getPackageManager();

        pm.setComponentEnabledSetting(receiver, PackageManager.COMPONENT_ENABLED_STATE_DISABLED, PackageManager.DONT_KILL_APP);

        Intent intent = new Intent(context, LocalNotificationBroadcastReceiver.class);

        PendingIntent pendingIntent = PendingIntent.getBroadcast(context, identifier, intent, PendingIntent.FLAG_NO_CREATE);
        if (pendingIntent == null) {
            Log.w(TAG, "Can't find PendingIntent instance with identifier '" + identifier + "'" );
            return;
        }

        AlarmManager am = (AlarmManager) context.getSystemService(ALARM_SERVICE);
        if (am == null) {
            Log.e(TAG, "Can't get AlarmManager");
            return;
        }

        am.cancel(pendingIntent);
        pendingIntent.cancel();
    }

    public static boolean hasPendingNotificationRequestWithId(Context context, int identifier) {
        Intent intent = new Intent(context, LocalNotificationBroadcastReceiver.class);
        PendingIntent pendingIntent = PendingIntent.getBroadcast(context, identifier, intent, PendingIntent.FLAG_NO_CREATE);
        return pendingIntent != null;
    }

    public static Date nextTriggerDateForPendingNotification(Context context, int identifier) {
        Log.d(TAG, "nextTriggerDateForPendingNotification");

        NotificationStorage storage = NotificationStorage.getInstance(context);
        Intent intent = storage.get(identifier);
        if (intent == null) {
            return null;
        }

        long triggerAtInMilliseconds = intent.getLongExtra(triggerAtKey, 0);
        long intervalInMilliseconds  = intent.getLongExtra(intervalKey, 0);

        Log.d(TAG, "triggerAt: " + triggerAtInMilliseconds + ", interval: " + intervalInMilliseconds);

        Calendar triggerAt = Calendar.getInstance();
        triggerAt.setTimeInMillis(triggerAtInMilliseconds);

        Calendar now = Calendar.getInstance();

        if (now.getTimeInMillis() > triggerAt.getTimeInMillis()) {
            triggerAt.setTimeInMillis(triggerAt.getTimeInMillis() + intervalInMilliseconds);
        }

        return triggerAt.getTime();
    }

    public static void removeAllPendingNotificationRequests(Context context) {
        // TODO: seems to be unsupported on Android
    }

    public static void showNotification(Context context, Intent intent) {
        Log.d(TAG, "showNotification");

        int identifier   = intent.getIntExtra(identifierKey, 0);
        String title     = intent.getStringExtra(titleKey);
        String content   = intent.getStringExtra(bodyKey);
        String sound     = intent.getStringExtra(soundKey);
        int color        = intent.getIntExtra(colorKey, Notification.COLOR_DEFAULT);
        String userInfo  = intent.getStringExtra(userInfoKey);
        String channelId = intent.getStringExtra(channelIdKey);

        Intent notificationIntent = null;
        try {
            notificationIntent = new Intent(context, Class.forName(context.getPackageName() + ".AppEntry"));
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            return;
        }
        notificationIntent.putExtra(userInfoKey, userInfo);
        notificationIntent.putExtra(identifierKey, identifier);

        PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT);

        int smallIconId = Resources.getResourseIdByName(context.getPackageName(), "drawable", "ic_stat_notify");
        int largeIconId = Resources.getResourseIdByName(context.getPackageName(), "mipmap", "icon");

        Uri soundUri = null;
        if (sound != null && context.checkSelfPermission(Manifest.permission.READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED) {
            File audioFile = AssetsUtil.copyAssetToTempFileIfNeeded(context, sound);
            if (audioFile != null) {
                soundUri = ContentProviderUtil.getAudioContentUri(context, audioFile);
            }
        }

        if (soundUri == null) {
            soundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
        }

        Notification.Builder builder = new Notification.Builder(context)
            .setSmallIcon(smallIconId)
            .setLargeIcon(BitmapFactory.decodeResource(context.getResources(), largeIconId))
            .setContentTitle(title)
            .setContentText(content)
            .setAutoCancel(true)
            .setWhen(System.currentTimeMillis())
            .setSound(soundUri)
            .setColor(color)
            .setContentIntent(pendingIntent);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            builder.setChannelId(channelId);
        }

        Notification notification = builder.build();

        NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        notificationManager.notify(identifier, notification);
    }

    private static void notifyAppWithDataIfAvailable(Context context, Intent intent, Boolean notifyForForeground) {
        Log.d(TAG, "notifyAppWithDataIfAvailable");

        if (intent.hasExtra(identifierKey) && intent.hasExtra(userInfoKey)) {
            int identifier = intent.getIntExtra(identifierKey, 0);
            intent.removeExtra(identifierKey);
            String params  = intent.getStringExtra(userInfoKey);
            intent.removeExtra(userInfoKey);

            if (notifyForForeground) {
                Notifications.dispatch("Notifications.Notification.ReceivedInForeground", params);
            } else {
                Notifications.dispatch("Notifications.Notification.ReceivedInBackground", params);
            }
        }
    }

    public static void handleAlarmReceived(Context context, Intent intent) {
        int identifier  = intent.getIntExtra(identifierKey, -1);
        long triggerAt  = intent.getLongExtra(triggerAtKey, -1);
        long interval   = intent.getLongExtra(intervalKey, -1);
        boolean repeats = intent.getBooleanExtra(repeatsKey, false);

        Log.d(TAG, "handleAlarmReceived id: '"+ identifier +"', triggerAt: "+ triggerAt +", interval: " + interval);

        if (isInForeground()) {
            notifyAppWithDataIfAvailable(context, intent, true);
        } else {
            showNotification(context, intent);
        }

        if (!repeats && identifier != -1) {
            NotificationStorage storage = NotificationStorage.getInstance(context);
            storage.remove(identifier);
        }
    }

    // Callbacks

    public interface AuthorizationStatusListener {
        void onStatus(String status);
    }

    public interface NotificationSettingsListener {
        void onSettings(NotificationCenterSettings settings);
    }
}
