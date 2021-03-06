package com.github.airext.notifications.utils;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;

import java.util.Date;

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

    public static double readDoublePropertyFrom(FREObject object, String property, int defaultValue) {
        try {
            FREObject value = object.getProperty(property);
            if (value != null) {
                return value.getAsDouble();
            } else {
                return defaultValue;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return defaultValue;
    }

    public static boolean readBooleanPropertyFrom(FREObject object, String property, boolean defaultValue) {
        try {
            FREObject value = object.getProperty(property);
            if (value != null) {
                return value.getAsBool();
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
            long length = array != null ? array.getLength() : 0;
            long[] result = new long[(int)length];
            for (int i = 0; i < length; i++) {
                result[i] = array.getObjectAt(i).getAsInt();
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new long[0];
    }

    public static FREObject convertDateToFREObject(Date date) {
        try {
            FREObject time = FREObject.newObject(date.getTime());
            FREObject converted = FREObject.newObject("Date", null);
            converted.setProperty("time", time);
            return converted;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

}
