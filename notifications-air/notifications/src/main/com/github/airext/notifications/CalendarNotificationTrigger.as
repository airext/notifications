/**
 * Created by max.rozdobudko@gmail.com on 5/26/20.
 */
package com.github.airext.notifications {
public class CalendarNotificationTrigger extends NotificationTrigger {

    public function CalendarNotificationTrigger(dateComponents: DateComponents, repeats: Boolean = false) {
        super(repeats);
        _dateComponents = dateComponents;
    }

    override public function get type(): int {
        return NotificationTriggerType.calendar;
    }

    private var _dateComponents: DateComponents;
    [Bindable(event="dateComponentsChanged")]
    public function get dateComponents(): DateComponents {
        return _dateComponents;
    }

    private var _exactTime: Boolean;
    public function get exactTime(): Boolean {
        return _exactTime;
    }
    public function set exactTime(value: Boolean): void {
        _exactTime = value;
    }

    override public function toString(): String {
        return '[CalendarNotificationTrigger(dateComponents="'+dateComponents+'", repeats="'+repeats+'")]';
    }
}
}
