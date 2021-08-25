import common.FileUtils;
import lombok.extern.slf4j.Slf4j;

import java.io.File;
import java.util.List;

@Slf4j
public class Main {

    public static void main(String[] args) {
        String filePath = Main.class.getClassLoader().getResource("").getFile();
        List<File> files = FileUtils.scanFileDepth(new File(filePath));
        files = FileUtils.filter(files, file -> file.getName().endsWith(".jpg"));
        log.info("down");
    }

}
