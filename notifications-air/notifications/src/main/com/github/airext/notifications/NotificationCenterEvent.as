/**
 * Created by max.rozdobudko@gmail.com on 12/5/17.
 */
package com.github.airext.notifications {
import flash.events.Event;

public class NotificationCenterEvent extends Event {

    public static const NOTIFICATION_RECEIVED_IN_BACKGROUND: String = "notificationReceivedInBackground";
    public static const NOTIFICATION_RECEIVED_IN_FOREGROUND: String = "notificationReceivedInForeground";

    public function NotificationCenterEvent(type: String, bubbles: Boolean = false, cancelable: Boolean = false, parameters: Object = null) {
        super(type, bubbles, cancelable);
        _parameters = parameters;
    }

    private var _parameters: Object;
    public function get parameters(): Object {
        return _parameters;
    }
}
}
