/**
 * Created by max.rozdobudko@gmail.com on 6/28/18.
 */
package com.github.airext {
import com.github.airext.bridge.bridge;
import com.github.airext.core.notifications;
import com.github.airext.notifications.NotificationCenterEvent;
import com.github.airext.notifications.NotificationRequest;

import flash.desktop.NativeApplication;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.permissions.PermissionStatus;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

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

    private static var _context: ExtensionContext;
    notifications static function get context(): ExtensionContext {
        if (_context == null) {
            _context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
        }
        return _context;
    }

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  isSupported
    //-------------------------------------

    public static function get isSupported(): Boolean {
        return context != null && context.call("isSupported");
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
        trace("Notifications.isEnabled");
        return context.call("isEnabled");
    }

    public static function get canOpenSettings(): Boolean {
        trace("Notifications.canOpenSettings");
        return context.call("canOpenSettings");
    }

    public static function openSettings(): void {
        trace("Notifications.openSettings");
        context.call("openSettings");
    }

    public static function requestAuthorizationWithOptions(options: int, completion: Function): void {
        trace("Notifications.requestAuthorizationWithCompletion");
        bridge(context).call("requestAuthorization", options).callback(function (error: Error, value: Object): void {
            if (error) {
                if (completion.length == 2) {
                    completion(PermissionStatus.UNKNOWN, error);
                } else {
                    completion(PermissionStatus.UNKNOWN);
                }
            } else {
                completion(value as String);
            }
        });
    }

    public static function getNotificationSettingsWithCompletion(handler: Function): void {
        bridge(context).call("getNotificationSettings").callback(function (error: Error, value: Object): void {
            if (error) {
                if (handler.length == 2) {
                    handler(null, error);
                } else {
                    handler(null);
                }
            } else {
                handler(value);
            }
        });
    }

    //-------------------------------------
    //  extensionVersion
    //-------------------------------------

    private static var _extensionVersion: String = null;

    /**
     * Returns version of extension
     * @return extension version
     */
    public static function get extensionVersion(): String
    {
        if (_extensionVersion == null) {
            try {
                var extension_xml: File = ExtensionContext.getExtensionDirectory(EXTENSION_ID).resolvePath("META-INF/ANE/extension.xml");
                if (extension_xml.exists) {
                    var stream:FileStream = new FileStream();
                    stream.open(extension_xml, FileMode.READ);

                    var extension:XML = new XML(stream.readUTFBytes(stream.bytesAvailable));
                    stream.close();

                    var ns:Namespace = extension.namespace();

                    _extensionVersion = extension.ns::versionNumber;
                }
            } catch (error:Error) {
                // ignore
            }
        }

        return _extensionVersion;
    }

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function Notifications() {
        super();
        instance = this;

        NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, activateHandler);
        NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, deactivateHandler);

        context.addEventListener(StatusEvent.STATUS, statusHandler);

        var timeoutId: uint = setTimeout(function(): void {
            clearTimeout(timeoutId);
            inForeground();
        }, 30);
    }

    // Sending Notifications

    public function add(request: NotificationRequest, callback: Function): void {
        trace("NotificationCenter", "adding notification request");
        bridge(context).call("addRequest", request).callback(function (error: Error, value: Object): void {
            callback(error);
        });
        trace("NotificationCenter", "notification request added");
    }

    public function removePendingNotificationRequests(identifiers: Vector.<int>): void {
        trace("NotificationCenter.removePendingNotificationRequests");
        context.call("removePendingNotificationRequests", identifiers);
    }

    public function removeAllPendingNotificationRequests(): void {
        trace("NotificationCenter.notificationCenterRemoveAllPendingNotificationRequests");
        context.call("removeAllPendingNotificationRequests");
    }

    // Work with background

    notifications function inForeground(): void {
        context.call("inForeground");
    }

    notifications function inBackground(): void {
        context.call("inBackground");
    }

    //  StatusEvent handler

    private function statusHandler(event:StatusEvent):void {
        switch (event.code) {
            case "Notifications.Notification.ReceivedInForeground" :
                var params: Object = parseParams(event.level);
                dispatchEvent(new NotificationCenterEvent(NotificationCenterEvent.NOTIFICATION_RECEIVED_IN_FOREGROUND, false, false, params));
                break;
            case "Notifications.Notification.ReceivedInBackground" :
                var params: Object = parseParams(event.level);
                dispatchEvent(new NotificationCenterEvent(NotificationCenterEvent.NOTIFICATION_RECEIVED_IN_BACKGROUND, false, false, params));
                break;
        }
    }

    private function parseParams(raw: String): Object {
        var params: Object = null;
        try {
            params = JSON.parse(raw);
        } catch (e: Error) {
            params = raw;
        }
        return params;
    }

    // NativeApplication handlers

    private function deactivateHandler(event: Event): void {
        inBackground();
    }

    private function activateHandler(event: Event): void {
        inForeground();
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  MARK: API
    //-------------------------------------

    //-------------------------------------
    //  MARK: Dispose
    //-------------------------------------

    public function dispose(): void {
        if (_context) {
            _context.dispose();
        }
        instance = null;
    }
}
}