/**
 * Created by max.rozdobudko@gmail.com on 6/28/18.
 */
package com.github.airext.notifications {
public class NotificationChannel {

    // Constructor

    public function NotificationChannel() {
        super();
    }

    // Properties

    public var id: String;

    public var name: String;

    public var importance: NotificationImportance = NotificationImportance.normal;

    public var enableLights: Boolean;

    public var lightColor: int;

    public var enableVibration: Boolean;

    public var vibrationPattern: Vector.<int>;
}
}
