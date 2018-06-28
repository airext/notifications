/**
 * Created by max.rozdobudko@gmail.com on 6/28/18.
 */
package com.github.airext {
import com.github.airext.core.notifications;
import com.github.airext.notifications.NotificationChannel;
import com.github.airext.notifications.NotificationRequest;

import flash.events.EventDispatcher;
import flash.system.Capabilities;

use namespace notifications;

public class Notifications extends EventDispatcher {

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    notifications static const EXTENSION_ID:String = "com.github.airext.Notifications";

    //--------------------------------------------------------------------------
    //
    //  Class properties
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  context
    //-------------------------------------

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  isSupported
    //-------------------------------------

    public static function get isSupported(): Boolean {
        return false;
    }

    //-------------------------------------
    //  sharedInstance
    //-------------------------------------

    private static var instance: Notifications;
    public static function get shared(): Notifications {
        if (instance == null) {
            new Notifications();
        }
        return instance;
    }

    public static function get isEnabled(): Boolean {
        trace("Notifications extension is not supported for " + Capabilities.os);
        return false;
    }

    public static function get canOpenSettings(): Boolean {
        trace("Notifications extension is not supported for " + Capabilities.os);
        return false
    }

    public static function openSettings(): void {
        trace("Notifications extension is not supported for " + Capabilities.os);
    }

    public static function requestAuthorizationWithOptions(options: int, completion: Function): void {
        trace("Notifications extension is not supported for " + Capabilities.os);
    }

    public static function getNotificationSettingsWithCompletion(handler: Function): void {
        trace("Notifications extension is not supported for " + Capabilities.os);
    }

    //-------------------------------------
    //  extensionVersion
    //-------------------------------------

    public static function get extensionVersion(): String {
        trace("Notifications extension is not supported for " + Capabilities.os);
        return null;
    }

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function Notifications() {
        super();
        instance = this;
    }
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  MARK: API
    //-------------------------------------

    public function createNotificationChannel(channel: NotificationChannel): void {
        trace("Notifications extension is not supported for " + Capabilities.os);
    }

    public function add(request: NotificationRequest, callback: Function): void {
        trace("Notifications extension is not supported for " + Capabilities.os);
    }

    public function removePendingNotificationRequests(identifiers: Vector.<int>): void {
        trace("Notifications extension is not supported for " + Capabilities.os);
    }

    public function removeAllPendingNotificationRequests(): void {
        trace("Notifications extension is not supported for " + Capabilities.os);
    }

    //-------------------------------------
    //  MARK: Dispose
    //-------------------------------------

    public function dispose(): void {
        instance = null;
    }
}
}