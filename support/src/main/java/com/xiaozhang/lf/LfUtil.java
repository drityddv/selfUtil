package com.xiaozhang.lf;

import java.io.File;
import java.util.*;
import java.util.stream.Collectors;

import org.apache.commons.io.FileUtils;

import com.xiaozhang.util.FileUtil;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.math3.util.Pair;

/**
 * @author : xiaozhang
 * @since : 2023/9/4 21:29
 */

@Slf4j
public class LfUtil {

    // 实际代码位置
    public static final Map<Integer, String> workSpaceCodePath = new HashMap<>();
    public static final Map<Integer, Integer> workSpace2ServerId = new HashMap<>();
    // 生成代码位置
    private static final Map<Integer, String> workSpaceGenCodePath = new HashMap<>();
    private static final String[] FILE_ENDS;
    public static final String JAVA_FILE_EXTENSION = ".java";
    public static final String XML_FILE_EXTENSION = ".xml";

    static {
        FILE_ENDS = new String[] {JAVA_FILE_EXTENSION, XML_FILE_EXTENSION};
        for (int i = 1; i <= 5; i++) {
            workSpaceCodePath.put(i,
                "/Users/xiaozhang/workspace/im30/lf2/s$/TZServer/server/LastFortressProject/lf-game/src/main/"
                    .replaceAll("\\$", String.valueOf(i)));
            workSpaceGenCodePath.put(i, "/Users/xiaozhang/workspace/im30/lf2/s$/TZServer/server/LastFortressProject/src"
                .replaceAll("\\$", String.valueOf(i)));
        }

        workSpace2ServerId.put(1, 668);
        workSpace2ServerId.put(2, 669);
        workSpace2ServerId.put(3, 670);
        workSpace2ServerId.put(4, 671);
    }

    public static void copyLfMappers(int workSpaceId) {
        String codePath = workSpaceCodePath.get(workSpaceId);
        File genCodePath = new File(workSpaceGenCodePath.get(workSpaceId));
        log.info("工作空间 id:[lf{}] 路径:[{}]", workSpaceId, genCodePath.getAbsolutePath());
        List<File> files = FileUtil.scanFiles(genCodePath, FILE_ENDS, null);

        // 处理bean类
        List<File> javaBeanFiles = files.stream().filter(file -> file.getName().endsWith(JAVA_FILE_EXTENSION)
            && file.getAbsolutePath().toLowerCase().contains("beans")).collect(Collectors.toList());
        log.info("java beans:{}", javaBeanFiles.stream().map(File::getName).collect(Collectors.toList()));
        for (File javaBeanFile : javaBeanFiles) {
            handleJavaFiles(codePath + "java/", javaBeanFile);
        }

        // 处理mapper类
        List<File> javaMapperFiles = files.stream()
            .filter(
                file -> file.getName().endsWith(JAVA_FILE_EXTENSION) && file.getName().toLowerCase().contains("mapper"))
            .collect(Collectors.toList());
        log.info("java mappers:{}", javaMapperFiles.stream().map(File::getName).collect(Collectors.toList()));
        for (File javaMapperFile : javaMapperFiles) {
            handleJavaFiles(codePath + "java/", javaMapperFile);
        }

        // 处理xx_mapper.xml
        List<File> xmlMapperFiles =
            files.stream().filter(file -> file.getName().endsWith("Mapper.xml")).collect(Collectors.toList());
        log.info("mapper xml:{}", xmlMapperFiles.stream().map(File::getName).collect(Collectors.toList()));
        for (File xmlMapperFile : xmlMapperFiles) {
            handleResourceFiles(codePath, xmlMapperFile);
        }

    }

    private static void handleJavaFiles(String codePath, File javaFile) {
        log.info("copy file:{}", javaFile.getName());
        String fileFullName = javaFile.getAbsolutePath();
        int indexOfJava = fileFullName.indexOf("com/lf");
        String substring = fileFullName.substring(indexOfJava).replaceAll(javaFile.getName(), "");
        String desPath = codePath + substring + "/";
        replaceFiles(javaFile, desPath);
    }

    private static void handleResourceFiles(String codePath, File resourceFile) {
        log.info("copy file:{}", resourceFile.getName());
        String fileFullName = resourceFile.getAbsolutePath();
        int indexOfJava = fileFullName.indexOf("mapper");
        String substring = fileFullName.substring(indexOfJava).replaceAll(resourceFile.getName(), "");
        String desPath = codePath + "resources/" + substring + "/";
        replaceFiles(resourceFile, desPath);
    }

    public static void replaceFiles(File file, String desPath) {
        try {
            File checkExists = new File(desPath + file.getName());
            if (checkExists.exists() && file.getName().contains("ExtendEntity")) {
                log.info("skip extend entity :{}", file.getName());
                return;
            }
            FileUtils.copyFile(file, checkExists);
            file.delete();
        } catch (Exception e) {
            log.error("copy file failed name:{}", file.getName());
        }

    }

    public static Pair<String,String> getWorkSpaceResourcePath(int workSpaceId) {
        String workSpacePath = workSpaceCodePath.get(workSpaceId);
        Integer serverId = workSpace2ServerId.get(workSpaceId);
        String finalResourcePath =
            workSpacePath.replaceAll("src/main/", "") + "extra/extensions/" + "LF" + serverId + "/" + "resource/";
        return Pair.create(finalResourcePath,finalResourcePath.replace("resource","worldCity"));
    }

}
