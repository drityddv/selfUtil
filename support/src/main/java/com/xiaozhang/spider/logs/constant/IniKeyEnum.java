package com.xiaozhang.spider.logs.constant;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author : xiaozhang
 * @since : 2023/6/30 17:22
 */

public enum IniKeyEnum {

    startUrl,
    webDriver,
    selenuim_config,
    threadNum,
    use_cache_html,
    ;

    public static List<String> getIniKeys() {
        return Arrays.stream(IniKeyEnum.values()).map(Enum::name).collect(Collectors.toList());
    }
}
