package com.xiaozhang.util;

import java.io.File;
import java.util.*;
import java.util.stream.Collectors;

import org.apache.commons.io.FileUtils;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2023/9/4 21:29
 */

@Slf4j
public class LfUtil {

    // 实际代码位置
    private static final Map<Integer, String> workSpaceCodePath = new HashMap<>();
    // 生成代码位置
    private static final Map<Integer, String> workSpaceGenCodePath = new HashMap<>();
    private static final String[] FILE_ENDS;
    private static final String JAVA_FILE_EXTENSION = ".java";
    private static final String XML_FILE_EXTENSION = ".xml";

    static {
        FILE_ENDS = new String[] {JAVA_FILE_EXTENSION, XML_FILE_EXTENSION};
        for (int i = 0; i < 5; i++) {
            workSpaceCodePath.put(i,
                "/Users/xiaozhang/workspace/im30/lf2/s$/TZServer/server/LastFortressProject/lf-game/src/main/java/"
                    .replaceAll("\\$", String.valueOf(i)));
            workSpaceGenCodePath.put(i, "/Users/xiaozhang/workspace/im30/lf2/s$/TZServer/server/LastFortressProject/src"
                .replaceAll("\\$", String.valueOf(i)));
        }
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
            handleJavaFiles(codePath, javaBeanFile);
        }

        // 处理mapper类
        List<File> javaMapperFiles = files.stream()
            .filter(
                file -> file.getName().endsWith(JAVA_FILE_EXTENSION) && file.getName().toLowerCase().contains("mapper"))
            .collect(Collectors.toList());
        log.info("java mappers:{}", javaMapperFiles.stream().map(File::getName).collect(Collectors.toList()));
        for (File javaMapperFile : javaMapperFiles) {
            handleJavaFiles(codePath, javaMapperFile);
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
        String desPath = codePath.replaceAll("java","resources") + substring + "/";
        replaceFiles(resourceFile, desPath);
    }

    private static void replaceFiles(File file, String desPath) {
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

    public static void main(String[] args) {
        if (args != null && args.length > 0) {
            int workSpaceId = Integer.parseInt(args[0]);
            copyLfMappers(workSpaceId);
            return;
        }
        copyLfMappers(3);

    }
}
