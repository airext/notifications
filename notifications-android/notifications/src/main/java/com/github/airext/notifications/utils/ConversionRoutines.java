package com.github.airext.notifications.utils;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREObject;

/**
 * Created by max on 12/5/17.
 */

public class ConversionRoutines {
    public static String toString(FREObject object) {
        try {
            if (object != null) {
                return object.getAsString();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static String readStringPropertyFrom(FREObject object, String property) {
        try {
            FREObject value = object.getProperty(property);
            if (value != null) {
                return value.getAsString();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static int readIntPropertyFrom(FREObject object, String property, int defaultValue) {
        try {
            FREObject value = object.getProperty(property);
            if (value != null) {
                return value.getAsInt();
            } else {
                return defaultValue;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return defaultValue;
    }

    public static long[] convertFREObjectToLongs(FREObject object) {
        try {
            FREArray array = (FREArray) object;
            long[] result = new long[(int)array.getLength()];
            for (int i = 0; i < array.getLength(); i++) {
                result[i] = array.getObjectAt(i).getAsInt();
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new long[0];
    }
}
