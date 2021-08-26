package main;

import common.FileUtils;
import lombok.extern.slf4j.Slf4j;

import java.io.File;
import java.io.IOException;
import java.util.List;

@Slf4j
public class CopyFilesMain {

    public static void main(String[] args) throws IOException {
        String filePath = CopyFilesMain.class.getClassLoader().getResource("").getFile();
        List<File> files = FileUtils.scanFileDepth(new File(filePath));
        files = FileUtils.filter(files, file -> file.getName().endsWith(".jpg"));
        for (File file : files) {
            org.apache.commons.io.FileUtils.copyFileToDirectory(file, new File("C:\\Users\\ddv\\Desktop\\out"));
        }

        log.debug("debug");
        log.info("info");
        log.warn("warn");
        log.error("error");
    }

}
