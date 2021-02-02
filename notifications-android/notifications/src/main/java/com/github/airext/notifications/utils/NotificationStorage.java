package com.github.airext.notifications.utils;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;

import java.net.URISyntaxException;

public class NotificationStorage {

    static final String preferencesName = "com.github.airext.notifications.android.preferences";

    // The application context
    private Context context;

    /**
     * Constructor
     *
     * @param context Application context
     */
    private NotificationStorage(Context context) {
        this.context = context;
    }

    /**
     * Static method to retrieve class instance.
     *
     * @param context Application context
     */
    public static NotificationStorage getInstance(Context context) {
        return new NotificationStorage(context);
    }

    public void set(Intent intent, Integer id) {
        SharedPreferences.Editor editor = getPrefs().edit();
        editor.putString(id.toString(), intent.toUri(0));
        editor.apply();
    }

    public Intent get(Integer id) {
        String uri = getPrefs().getString(id.toString(), null);
        if (uri == null) {
            return null;
        }
        try {
            return Intent.parseUri(uri, 0);
        } catch (URISyntaxException e) {
            e.printStackTrace();
            return null;
        }
    }

    public void remove(Integer id) {
        SharedPreferences.Editor editor = getPrefs().edit();
        editor.remove(id.toString());
        editor.apply();
    }

    // MARK: Private

    private SharedPreferences getPrefs () {
        return context.getSharedPreferences(preferencesName, Context.MODE_PRIVATE);
    }
}
