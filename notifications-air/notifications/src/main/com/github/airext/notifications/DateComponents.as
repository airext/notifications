/**
 * Created by max.rozdobudko@gmail.com on 5/26/20.
 */
package com.github.airext.notifications {
import com.github.airext.data.Int;

import flash.events.Event;
import flash.events.EventDispatcher;

public class DateComponents extends EventDispatcher {

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function DateComponents() {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  year
    //-------------------------------------

    private var _year: Int;
    [Bindable(event="yearChanged")]
    public function get year(): Int {
        return _year;
    }
    public function set year(value: Int): void {
        if (value == _year) return;
        _year = value;
        dispatchEvent(new Event("yearChanged"));
    }

    //-------------------------------------
    //  month
    //-------------------------------------

    private var _month: Int;
    [Bindable(event="monthChanged")]
    public function get month(): Int {
        return _month;
    }
    public function set month(value: Int): void {
        if (value == _month) return;
        _month = value;
        dispatchEvent(new Event("monthChanged"));
    }

    //-------------------------------------
    //  weekday
    //-------------------------------------

    private var _weekday: Int;
    [Bindable(event="weekdayChanged")]
    public function get weekday(): Int {
        return _weekday;
    }
    public function set weekday(value: Int): void {
        if (value == _weekday) return;
        _weekday = value;
        dispatchEvent(new Event("weekdayChanged"));
    }

    //-------------------------------------
    //  weekdayOrdinal
    //-------------------------------------

    private var _weekdayOrdinal: Int;
    [Bindable(event="weekdayOrdinalChanged")]
    public function get weekdayOrdinal(): Int {
        return _weekdayOrdinal;
    }
    public function set weekdayOrdinal(value: Int): void {
        if (value == _weekdayOrdinal) return;
        _weekdayOrdinal = value;
        dispatchEvent(new Event("weekdayOrdinalChanged"));
    }

    //-------------------------------------
    //  day
    //-------------------------------------

    private var _day: Int;
    [Bindable(event="dayChanged")]
    public function get day(): Int {
        return _day;
    }
    public function set day(value: Int): void {
        if (value == _day) return;
        _day = value;
        dispatchEvent(new Event("dayChanged"));
    }

    //-------------------------------------
    //  hour
    //-------------------------------------

    private var _hour: Int;
    [Bindable(event="hourChanged")]
    public function get hour(): Int {
        return _hour;
    }
    public function set hour(value: Int): void {
        if (value == _hour) return;
        _hour = value;
        dispatchEvent(new Event("hourChanged"));
    }

    //-------------------------------------
    //  minute
    //-------------------------------------

    private var _minute: Int;
    [Bindable(event="minuteChanged")]
    public function get minute(): Int {
        return _minute;
    }
    public function set minute(value: Int): void {
        if (value == _minute) return;
        _minute = value;
        dispatchEvent(new Event("minuteChanged"));
    }

    //-------------------------------------
    //  second
    //-------------------------------------

    private var _second: Int;
    [Bindable(event="secondChanged")]
    public function get second(): Int {
        return _second;
    }
    public function set second(value: Int): void {
        if (value == _second) return;
        _second = value;
        dispatchEvent(new Event("secondChanged"));
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    override public function toString(): String {
        return '[DateComponents(' +
                'year="'+year+'", ' +
                'month="'+month+'", ' +

                'weekday="'+weekday+'", ' +
                'weekdayOrdinal="'+weekdayOrdinal+'", ' +
                'day="'+day+'", ' +
                'hour="'+hour+'", ' +
                'minute="'+minute+'", ' +
                'second="'+second+'"' +
                ')]';
    }
}
}
