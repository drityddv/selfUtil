package com.xiaozhang.util;

import java.time.*;
import java.time.format.DateTimeFormatter;

/**
 * @author : xiaozhang
 * @since : 2024/3/26 16:54
 */

public class TimeUtil {
    // 格式化时间
    public static String format(long timestamp) {
        // 将时间戳转换为LocalDateTime对象
        LocalDateTime dateTime = LocalDateTime.ofInstant(Instant.ofEpochMilli(timestamp), ZoneId.systemDefault());
        // 定义时间格式
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        // 格式化时间
        return dateTime.format(formatter);
    }
}
