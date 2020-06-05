/**
 * Created by max.rozdobudko@gmail.com on 12/3/17.
 */
package com.github.airext.notifications {
import flash.events.EventDispatcher;

public class NotificationTrigger extends EventDispatcher {

    public function NotificationTrigger(repeats: Boolean = false) {
        super();
        _repeats = repeats;
    }

    public function get type(): int {
        throw new Error("NotificationTrigger is an abstract class.");
    }

    private var _repeats: Boolean;
    public function get repeats(): Boolean {
        return _repeats;
    }
}
}
