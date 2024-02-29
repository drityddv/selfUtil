package com.xiaozhang.common;

import java.io.*;
import java.util.*;
import java.util.function.Predicate;
import java.util.stream.*;

import org.apache.commons.io.FileUtils;

import lombok.extern.slf4j.Slf4j;

/**
 * @author xiaozhang
 * @date 2021-08-25 21:16
 */
@Slf4j
public class XZFileUtils {

    public static void copyFile(String source, String target, Predicate<File> filter) throws Exception {
        File sourceFile = new File(source);
        File targetFile = new File(target);

        if (!targetFile.exists()) {
            targetFile.mkdir();
        }

        if (!sourceFile.isDirectory() || !targetFile.isDirectory()) {
            log.warn("文件夹路径有误! {} {}", source, target);
            return;
        }

        List<File> allFiles = scanFileDepth(sourceFile);
        List<File> result = filterFiles(allFiles, filter);

        if (CollectionUtils.isEmpty(result)) {
            log.warn("没有符合要求的文件需要被拷贝!");
            return;
        }

        if (!targetFile.exists()) {
            targetFile.mkdirs();
        }

        result.stream().parallel().forEach(file -> {
            try {
                FileUtils.copyFileToDirectory(file, targetFile);
            } catch (IOException e) {
                log.error("copy file failed:{}", file.getName(), e);
            }
            log.info("拷贝文件:{}完成", file.getName());
        });

    }

    public static List<File> scanFileDepth(File scanFile) {
        List<File> result = new ArrayList<>();
        if (scanFile == null) {
            return result;
        }
        if (!scanFile.isDirectory()) {
            result.add(scanFile);
        }
        File[] currentFiles = scanFile.listFiles();
        if (currentFiles == null) {
            return result;
        }
        for (File currentFile : currentFiles) {
            result.addAll(scanFileDepth(currentFile));
        }
        return result;
    }

    public static List<File> filterFiles(Collection<File> files, Predicate<? super File>... predicate) {
        if (CollectionUtils.isEmpty(files)) {
            return Collections.emptyList();
        }
        Stream<File> fileStream = files.stream();
        if (predicate != null) {
            for (Predicate<? super File> predicate1 : predicate) {
                fileStream = fileStream.filter(predicate1);
            }
        }
        return fileStream.collect(Collectors.toList());
    }

    public static void readFile(String file) throws IOException {
        List<String> readLines = FileUtils.readLines(new File(file));
        List<String> create_table_sql_lines =
            readLines.stream().filter(s -> s.contains("CREATE TABLE")).collect(Collectors.toList());
        for (String tableSqlLine : create_table_sql_lines) {
            String tableName =
                tableSqlLine.toLowerCase().replaceAll("create table", "").replaceAll("\\(", "").replaceAll(" ", "");
            log.info("drop table if exist {} ", tableName);
            String line = "drop table if exists " + tableName + ";";
            FileUtils.writeLines(new File("result.txt"), Collections.singleton(line), true);
        }
    }

    public static void main(String[] args) throws IOException {
        readFile("/Users/xiaozhang/Documents/草稿纸3.txt");
    }
}
