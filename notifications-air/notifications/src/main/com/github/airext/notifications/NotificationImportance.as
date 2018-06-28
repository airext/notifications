/**
 * Created by max.rozdobudko@gmail.com on 6/28/18.
 */
package com.github.airext.notifications {
public class NotificationImportance {

    public static var unspecified: NotificationImportance   = new NotificationImportance(-1);
    public static var none: NotificationImportance          = new NotificationImportance(0);
    public static var min: NotificationImportance           = new NotificationImportance(1);
    public static var low: NotificationImportance           = new NotificationImportance(2);
    public static var normal: NotificationImportance        = new NotificationImportance(3);
    public static var high: NotificationImportance          = new NotificationImportance(4);
    public static var max: NotificationImportance           = new NotificationImportance(5);

    public static function fromRawValue(rawValue: int): NotificationImportance {
        switch (rawValue) {
            case none.rawValue: return none;
            case min.rawValue: return min;
            case low.rawValue: return low;
            case normal.rawValue: return normal;
            case high.rawValue: return high;
            case max.rawValue: return max;
            default: return unspecified;
        }
    }

    public function NotificationImportance(rawValue: int) {
        super();
        _rawValue = rawValue;
    }

    private var _rawValue: int;
    public function get rawValue(): int {
        return _rawValue;
    }
}
}
