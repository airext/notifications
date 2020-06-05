/**
 * Created by max.rozdobudko@gmail.com on 5/26/20.
 */
package com.github.airext.data {
public class Int {

    public function Int(value: int) {
        super();
        _value = value;
    }

    private var _value: int;
    public function get value(): int {
        return _value;
    }

    public function toString(): String {
        return String(value);
    }
}
}
