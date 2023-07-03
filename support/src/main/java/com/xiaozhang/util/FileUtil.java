package com.xiaozhang.util;

import org.apache.commons.collections.CollectionUtils;
import org.ini4j.Ini;
import org.ini4j.Profile.Section;

import java.io.File;
import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author : xiaozhang
 * @since : 2023/7/3 00:55
 */

public class FileUtil {

    public static Map<String, String> readFromIniFile(File iniFile, List<String> keys) {
        if (CollectionUtils.isEmpty(keys)) {
            return Collections.emptyMap();
        }
        Ini ini = new Ini();
        try {
            ini.load(iniFile);
        } catch (IOException e) {
            e.printStackTrace();
        }

        Map<String, String> result = new HashMap<>();
        for (String key : keys) {
            Section section = ini.get("fflogs");
            String value = section.get(key);
            result.put(key, value);
        }

        return result;
    }

}
