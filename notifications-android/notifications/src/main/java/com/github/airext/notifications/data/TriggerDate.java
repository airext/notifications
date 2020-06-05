package com.github.airext.notifications.data;

import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;
import com.github.airext.bridge.CallResultValue;
import com.github.airext.notifications.utils.ConversionRoutines;

import java.util.Date;

public class TriggerDate implements CallResultValue {

    public TriggerDate(Date date) {
        this.date = date;
    }

    private Date date;
    public Date getDate() {
        return date;
    }

    @Override
    public FREObject toFREObject() throws FRETypeMismatchException, FREInvalidObjectException, FREWrongThreadException, IllegalStateException {
        return ConversionRoutines.convertDateToFREObject(this.date);
    }
}
