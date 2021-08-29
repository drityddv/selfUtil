package common;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.function.Predicate;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import lombok.extern.slf4j.Slf4j;

/**
 * @author xiaozhang
 * @date 2021-08-25 21:16
 */
@Slf4j
public class FileUtils {

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

    public static List<File> filter(Collection<File> files, Predicate<? super File>... predicate) {
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
}
