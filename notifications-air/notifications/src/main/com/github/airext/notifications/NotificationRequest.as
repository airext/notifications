/**
 * Created by max.rozdobudko@gmail.com on 12/3/17.
 */
package com.github.airext.notifications {
public class NotificationRequest {

    // Constructor

    public function NotificationRequest(identifier: int, content: NotificationContent, trigger: NotificationTrigger) {
        super();

        _identifier = identifier;
        _content = content;
        _trigger = trigger;
    }

    private var _identifier: int;
    public function get identifier(): int {
        return _identifier;
    }

    private var _content: NotificationContent;
    public function get content(): NotificationContent {
        return _content;
    }

    private var _trigger: NotificationTrigger;
    public function get trigger(): NotificationTrigger {
        return _trigger;
    }

    private var _channelId: String;
    public function get channelId(): String {
        return _channelId;
    }
    public function setChannelId(value: String): void {
        _channelId = value;
    }

    public function toString(): String {
        return '[NotificationRequest(identifier="'+identifier+'", content="'+content+'", trigger="'+trigger+'", channelId="'+channelId+'")]';
    }
}
}
