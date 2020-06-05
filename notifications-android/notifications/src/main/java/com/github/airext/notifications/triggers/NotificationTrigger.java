package com.github.airext.notifications.triggers;

import com.adobe.fre.*;
import com.github.airext.notifications.utils.ConversionRoutines;

public abstract class NotificationTrigger {

    public static NotificationTrigger fromFREObject(FREObject object) {
        try {
            int type = object.getProperty("type").getAsInt();
            switch (type) {
                case 1:
                    return new CalendarNotificationTrigger(object);
                default:
                    return new TimeIntervalNotificationTrigger(object);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    NotificationTrigger(FREObject object) {
        this(
            ConversionRoutines.readBooleanPropertyFrom(object, "repeats", false),
            ConversionRoutines.readBooleanPropertyFrom(object, "exactTime", false)
        );
    }

    NotificationTrigger(boolean repeats, boolean exactTime) {
        this.repeats   = repeats;
        this.exactTime = exactTime;
    }

    private boolean repeats;
    public boolean shouldRepeat() {
        return repeats;
    }

    private boolean exactTime;
    public boolean isExactTime() {
        return exactTime;
    }

    public abstract long getTriggerAt();

    public abstract long getTriggerInterval();
}
