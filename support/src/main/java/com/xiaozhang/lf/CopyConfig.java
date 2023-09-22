package com.xiaozhang.lf;

import java.io.*;
import java.util.*;
import java.util.stream.Collectors;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.math3.util.Pair;

import com.xiaozhang.util.JsonUtil;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2023/9/6 17:10
 */

@Slf4j
public class CopyConfig extends LfUtil {

     private static String branceName = "联盟BP配置";
//    private static String branceName = "";
    
    public static Set<String> skipFiles  = new HashSet<>();
    
    static {
        skipFiles.add("activity_panel.xml");
    }

    private static String svnPath = "/Users/xiaozhang/workspace/im30/lf/cehua/LastFortress/resource_t";

    public static void main(String[] args) throws IOException {
//        copyConfigs(1);
//        copyConfigs(2);
         copyConfigs(3);
//        copyConfigs(4);
    }

    private static void copyConfigs(int workSpaceId) throws IOException {
        if (!StringUtils.isEmpty(branceName)) {
            svnPath = svnPath + "/" + branceName + "/";
        }
        File configFolder = new File(svnPath);
        if (!configFolder.exists() || !configFolder.isDirectory()) {
            log.error("configFolder path error :{}", svnPath);
            return;
        }

        Iterator<File> iterateFiles = FileUtils.iterateFiles(configFolder, new String[] {"xml"}, false);
        List<File> xmlFiles = new ArrayList<>();
        iterateFiles.forEachRemaining(xmlFiles::add);
        Collections.sort(xmlFiles);
        log.info("{}", xmlFiles.stream().map(File::getName).collect(Collectors.toList()));

        Pair<String, String> resourcePath = LfUtil.getWorkSpaceResourcePath(workSpaceId);
        log.info("即将copy配置到目录:{}", JsonUtil.object2String(resourcePath));
        for (File xmlFile : xmlFiles) {
            if(skipFiles.contains(xmlFile.getName())) {
                continue;
            }
            // 删除xmlFile文件
            String resourcePathFirst = resourcePath.getFirst();
            File desFile = new File(resourcePathFirst + xmlFile.getName());
            FileUtils.copyFile(xmlFile, desFile);
            // 删除desFile文件

            log.info("拷贝完成 :{}", desFile.getAbsolutePath());
        }

    }

}
