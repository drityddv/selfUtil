package main;

import java.io.File;
import java.io.IOException;
import java.util.List;

import common.FileUtils;
import lombok.extern.slf4j.Slf4j;

/**
 * @author : ddv
 * @since : 2021/8/28 14:25
 */
@Slf4j
public class CopyFilesMain {

    public static void main(String[] args) throws IOException {

        String filePath = CopyFilesMain.class.getClassLoader().getResource("").getFile();
        List<File> files = FileUtils.scanFileDepth(new File(filePath));

        files = FileUtils.filter(files, file -> file.getName().endsWith(".lrtemplate"));

        for (File file : files) {
            // log.info("file {}", file.getAbsolutePath());
            org.apache.commons.io.FileUtils.copyFileToDirectory(file, new File("/Users/ddv/Desktop/out/"));
        }
    }
}
