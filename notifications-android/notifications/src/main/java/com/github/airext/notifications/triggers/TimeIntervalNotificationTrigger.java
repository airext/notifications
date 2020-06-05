package com.github.airext.notifications.triggers;

import com.adobe.fre.FREObject;
import com.github.airext.notifications.utils.ConversionRoutines;

import java.util.Calendar;

public class TimeIntervalNotificationTrigger extends NotificationTrigger {

    TimeIntervalNotificationTrigger(FREObject object) {
        super(object);
        this.timeInterval = ConversionRoutines.readDoublePropertyFrom(object, "timeInterval", 0);
    }

    TimeIntervalNotificationTrigger(double timeInterval, boolean repeats, boolean exactTime) {
        super(repeats, exactTime);
        this.timeInterval = timeInterval;
    }

    private double timeInterval;
    public double getTimeInterval() {
        if (timeInterval < 0) {
            return 0;
        }
        return timeInterval;
    }

    @Override
    public long getTriggerAt() {
        Calendar calendar = Calendar.getInstance();
        long time = calendar.getTimeInMillis();
        if (shouldRepeat()) {
            return time;
        } else {
            return time + getTriggerInterval();
        }
    }

    @Override
    public long getTriggerInterval() {
        return (long)timeInterval * 1000;
    }
}
