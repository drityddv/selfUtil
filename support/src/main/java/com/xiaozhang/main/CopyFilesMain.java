package com.xiaozhang.main;

import lombok.extern.slf4j.Slf4j;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author : ddv
 * @since : 2021/8/28 14:25
 */
@Slf4j
public class CopyFilesMain {

    public static void main(String[] args) throws IOException {
        List<Integer> collect = Arrays.asList(1, 5, 2, 9, 10, 2, 3).stream().sorted().collect(Collectors.toList());

        log.info("Collecting");
    }
}
