package com.xiaozhang.util;

import java.io.*;
import java.util.*;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.filefilter.*;
import org.ini4j.Ini;
import org.ini4j.Profile.Section;

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

    /**
     * @see FileFilterUtils#trueFileFilter()
     */
    public static List<File> scanFiles(File srcPath, String[] extensions, List<IOFileFilter> ioFileFilter) {
        if (srcPath == null || !srcPath.isDirectory()) {
            return Collections.emptyList();
        }

        List<File> result = new ArrayList<>();

        Iterator<File> iterateFiles = FileUtils.iterateFilesAndDirs(srcPath, TrueFileFilter.TRUE, TrueFileFilter.TRUE);
        iterateFiles.forEachRemaining(file -> {
            if (file.isDirectory()) {
                return;
            }

            if (!new SuffixFileFilter(extensions).accept(file)) {
                return;
            }

            if (ioFileFilter != null) {
                for (IOFileFilter fileFilter : ioFileFilter) {
                    if (!fileFilter.accept(file)) {
                        return;
                    }
                }
            }
            result.add(file);
        });
        return result;
    }

    public static File getResourceFile(String path) {
        String file = FileUtil.class.getClassLoader().getResource(path).getFile();
        return new File(file);
    }

}
