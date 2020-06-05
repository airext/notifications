/**
 * Created by max.rozdobudko@gmail.com on 12/3/17.
 */
package com.github.airext.notifications {
public class TimeIntervalNotificationTrigger extends NotificationTrigger {

    public function TimeIntervalNotificationTrigger(timeInterval: Number, repeats: Boolean = false) {
        super(repeats);

        _timeInterval = timeInterval;
    }

    override public function get type(): int {
        return NotificationTriggerType.timeInterval;
    }

    private var _timeInterval: Number;
    public function get timeInterval(): Number {
        return _timeInterval;
    }

    private var _exactTime: Boolean;
    public function get exactTime(): Boolean {
        return _exactTime;
    }
    public function set exactTime(value: Boolean): void {
        _exactTime = value;
    }

    override public function toString(): String {
        return '[TimeIntervalNotificationTrigger(timeInterval="'+timeInterval+'", exactTime="'+exactTime+'", repeats="'+repeats+'")]';
    }
}
}
