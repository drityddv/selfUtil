package com.xiaozhang.util;

import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import sun.misc.Unsafe;

import java.lang.reflect.Field;

/**
 * @author : xiaozhang
 * @since : 2023/7/5 16:10
 */
@Getter
@Slf4j
public class UnSafeUtil {

    public static Unsafe getUnsafe() {
        try {
            Field field = Unsafe.class.getDeclaredField("theUnsafe");
            field.setAccessible(true);
            return (Unsafe) field.get(null);
        } catch (Exception e) {
            log.error(e.getMessage(), e);
            return null;
        }
    }

}
