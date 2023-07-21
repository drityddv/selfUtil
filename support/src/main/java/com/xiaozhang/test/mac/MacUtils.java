package com.xiaozhang.test.mac;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import org.apache.commons.io.FileUtils;

import com.xiaozhang.util.JsonUtil;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2022/11/11 19:06
 */

@Slf4j
public class MacUtils {

    public static void main(String[] args) throws Exception {
        exportZhouJieLun();
    }

    private static void jiHuang() throws IOException {
        String srcFilePath = "/Users/xiaozhang/workspace/java/utils/support/src/main/resources/string.txt";
        List<String> strings = FileUtils.readLines(new File(srcFilePath));
        List<String> result = new ArrayList<String>();
        for (int i = 0; i < strings.size(); i++) {
            if (strings.get(i).equals("Don't Starve Together")) {
                log.info("{}", strings.get(i - 1));
                result.add(strings.get(i - 1));
            }
        }
        FileUtils.writeLines(new File("订阅mod.txt"), result);
    }

    private static void exportZhouJieLun() {
        String endName = "mp4";
        String srcFilePath = "/Users/xiaozhang/Downloads/rick/";
        String targetFilePath = "/Users/xiaozhang/Downloads/rick/result/";
        new File(targetFilePath).mkdirs();
        Iterator<File> fileIterator = FileUtils.iterateFiles(new File(srcFilePath), new String[] {endName}, true);
        fileIterator.forEachRemaining(file -> {
            log.info("{}", file.getName());
            try {
                FileUtils.copyFile(file, new File(targetFilePath + file.getName()));
            } catch (IOException e) {
                e.printStackTrace();
            }
        });
    }

    private static void batchRenameFiles() {
        String srcFilePath = "/Users/xiaozhang/Downloads/[Kamigami] Slam Dunk [HDTV x264 960×720 AAC Sub(Cht,Jap)]";
        File sreFile = FileUtils.getFile(srcFilePath);
        File[] files = sreFile.listFiles();
        List<File> fileList =
            Arrays.stream(files).filter(file -> file.getName().endsWith(".mp4")).collect(Collectors.toList());
        fileList.sort(Comparator.comparing(File::getName));
        for (File file : fileList) {
            Pattern compile = Pattern.compile("[0-9]+");
            Matcher matcher = compile.matcher(file.getName());
            if (matcher.find()) {
                String result = matcher.group(0);
                log.info("{}", JsonUtil.object2String(result));
                String newName = srcFilePath + "/Slam Dunk - " + result + ".mp4";
                file.renameTo(new File(newName));
            }
        }
    }

}
