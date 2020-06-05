package com.github.airext.notifications.triggers;

import com.adobe.fre.*;

public class DateComponents {

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    DateComponents(FREObject object) {
        try {
            if (object.getProperty("year") != null) {
                year    = object.getProperty("year").getProperty("value").getAsInt();
            }
            if (object.getProperty("month") != null) {
                month = object.getProperty("month").getProperty("value").getAsInt() - 1;
            }
            if (object.getProperty("weekday") != null) {
                weekday = object.getProperty("weekday").getProperty("value").getAsInt();
            }
            if (object.getProperty("weekdayOrdinal") != null) {
                weekdayOrdinal = object.getProperty("weekdayOrdinal").getProperty("value").getAsInt();
            }
            if (object.getProperty("day") != null) {
                day = object.getProperty("day").getProperty("value").getAsInt();
            }
            if (object.getProperty("hour") != null) {
                hour = object.getProperty("hour").getProperty("value").getAsInt();
            }
            if (object.getProperty("minute") != null) {
                minute = object.getProperty("minute").getProperty("value").getAsInt();
            }
            if (object.getProperty("second") != null) {
                second = object.getProperty("second").getProperty("value").getAsInt();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  year
    //-------------------------------------

    private Object year;
    public Object getYear() {
        return year;
    }
    public void setYear(Object value) {
        year = value;
    }

    //-------------------------------------
    //  month
    //-------------------------------------

    private Object month;
    public Object getMonth() {
        return month;
    }
    public void setMonth(Object value) {
        month = value;
    }

    //-------------------------------------
    //  weekday
    //-------------------------------------

    private Object weekday;
    public Object getWeekday() {
        return weekday;
    }
    public void setWeekday(Object value) {
        weekday = value;
    }

    //-------------------------------------
    //  weekdayOrdinal
    //-------------------------------------

    private Object weekdayOrdinal;
    public Object getWeekdayOrdinal() {
        return weekdayOrdinal;
    }
    public void setWeekdayOrdinal(Object value) {
        weekdayOrdinal = value;
    }

    //-------------------------------------
    //  day
    //-------------------------------------

    private Object day;
    public Object getDay() {
        return day;
    }
    public void setDay(Object value) {
        day = value;
    }

    //-------------------------------------
    //  hour
    //-------------------------------------

    private Object hour;
    public Object getHour() {
        return hour;
    }
    public void setHour(Object value) {
        hour = value;
    }

    //-------------------------------------
    //  minute
    //-------------------------------------

    private Object minute;
    public Object getMinute() {
        return minute;
    }
    public void setMinute(Object value) {
        minute = value;
    }

    //-------------------------------------
    //  second
    //-------------------------------------

    private Object second;
    public Object getSecond() {
        return second;
    }
    public void setSecond(Object value) {
        second = value;
    }
}
