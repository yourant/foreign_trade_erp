package com.fy.erp.common.utils;

/**
 * Created by 尹彬 on 2017/11/17.
 */
public class ArrayUtil {

    public static boolean contains(String status, String checkStatus) {
        boolean isContains = false;
        for (String checkStatu : checkStatus.split(",")) {
            if (status.equals(checkStatu)) {
                isContains = true;
                break;
            }
        }
        return isContains;
    }

}
