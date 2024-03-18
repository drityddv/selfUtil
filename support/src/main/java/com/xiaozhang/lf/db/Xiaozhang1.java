package com.xiaozhang.lf.db;

import java.io.*;
import java.util.*;

import org.apache.commons.io.FileUtils;

/**
 * @author : xiaozhang
 * @since : 2024/3/15 20:35
 */

public class Xiaozhang1 {

    public static void main(String[] args) throws IOException {
        List<String> strings = FileUtils.readLines(
            new File("/Users/xiaozhang/workspace/java/utils/support/src/main/java/com/xiaozhang/lf/db/xiaozhang.txt"));

        Map<String, Integer> result = new HashMap<>();
        for (String string : strings) {
            String uid = string.split(";")[0];
            int score = Integer.parseInt(string.split(";")[1]);
            result.put(uid, score);
        }
        // uid2ScoreAdd.put("128764002000568", 1);
        List<String> lines = new ArrayList<>();
        File resultFile = new File("gvText.txt");
        result.forEach((s, integer) -> {
            String line = "uid2ScoreAdd.put(" + '"' + s + '"' + "," + integer + ");";
            lines.add(line);
        });

        FileUtils.writeLines(resultFile, lines, false);

    }

}
