package com.github.airext.notifications.triggers;

import android.app.AlarmManager;
import android.util.Log;
import com.adobe.fre.*;

import java.util.Calendar;

public class CalendarNotificationTrigger extends NotificationTrigger {

    private static final String TAG = "ANX";

    private static final long INTERVAL_YEAR      = (long)(AlarmManager.INTERVAL_DAY * 365);

    private static final long INTERVAL_DAY       = AlarmManager.INTERVAL_DAY;

    private static final long INTERVAL_WEEK      = INTERVAL_DAY * 7;

    private static final long INTERVAL_HOUR      = AlarmManager.INTERVAL_HOUR;

    private static final long INTERVAL_MINUTE    = 60 * 1000;

    CalendarNotificationTrigger(FREObject object) {
        super(object);
        try {
            this.dateComponents = new DateComponents(object.getProperty("dateComponents"));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    CalendarNotificationTrigger(DateComponents dateComponents, boolean repeats, boolean exactTime) {
        super(repeats, exactTime);
        this.dateComponents = dateComponents;
    }

    private DateComponents dateComponents;
    public DateComponents getDateComponents() {
        return dateComponents;
    }

    @Override
    public long getTriggerAt() {
        Calendar calendar = Calendar.getInstance();

        if (dateComponents.getYear() instanceof Integer) {
            calendar.add(Calendar.YEAR, (int)dateComponents.getYear());
        }

        if (dateComponents.getMonth() instanceof  Integer) {
            calendar.set(Calendar.MONTH, (int)dateComponents.getMonth());
        }

        if (dateComponents.getWeekday() instanceof Integer) {
            calendar.set(Calendar.DAY_OF_WEEK, (int)dateComponents.getWeekday());
        }

        if (dateComponents.getHour() instanceof Integer) {
            calendar.set(Calendar.HOUR_OF_DAY, (int)dateComponents.getHour());
        }

        if (dateComponents.getMinute() instanceof Integer) {
            calendar.set(Calendar.MINUTE, (int)dateComponents.getMinute());
        }

        if (dateComponents.getSecond() instanceof Integer) {
            calendar.set(Calendar.SECOND, (int)dateComponents.getSecond());
        }

        return calendar.getTimeInMillis();
    }

    @Override
    public long getTriggerInterval() {
        long interval = 0;

        if (dateComponents.getMonth() instanceof Integer) {
            interval = INTERVAL_YEAR;
        } else if (dateComponents.getWeekday() instanceof Integer) {
            interval = INTERVAL_WEEK;
        } else if (dateComponents.getHour() instanceof Integer) {
            interval = INTERVAL_DAY;
        } else if (dateComponents.getMinute() instanceof Integer) {
            interval = INTERVAL_HOUR;
        } else if (dateComponents.getSecond() instanceof Integer) {
            interval = INTERVAL_MINUTE;
        }

        Log.d(TAG, "Interval to return: " + interval);

        return interval;
    }
}
