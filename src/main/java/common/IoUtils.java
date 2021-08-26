package common;

import lombok.extern.slf4j.Slf4j;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.Collection;

/**
 * @author xiaozhang
 * @date 2021-08-25 22:24
 */
@Slf4j
public class IoUtils {

    public static void writeFile(Collection<File> memoryFiles, String targetPath) {
        if (CollectionUtils.isEmpty(memoryFiles)) {
            return;
        }

        for (File memoryFile : memoryFiles) {
            FileReader fileReader = null;
            try {
                fileReader = new FileReader(memoryFile.getAbsolutePath());
            } catch (Exception e) {
                log.error("write file [{}] failed...", memoryFile.getName(), e);
            } finally {
                if (fileReader != null) {
                    try {
                        fileReader.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }

        }


    }
}
