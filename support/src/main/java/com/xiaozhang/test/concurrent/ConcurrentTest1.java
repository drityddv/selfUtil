package com.xiaozhang.test.concurrent;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2022/9/5 17:33
 */

@Getter
@Setter
@Slf4j
public class ConcurrentTest1 {

    private long count = 0;

    private long refreshAt = 0;

    public static void main(String[] args) {
        test2();
    }

    private static void test2() {
        int a = Integer.MAX_VALUE;
        while (true) {
            log.info(" a {}", a++);
        }
    }

    private static void test1() {
        ConcurrentTest1 countTest1 = new ConcurrentTest1();
        ExecutorService executorService = Executors.newFixedThreadPool(36);
        while (true) {
            executorService.submit(() -> {
                long oldCount = countTest1.count;
                countTest1.count++;
                if (countTest1.count - oldCount != 1) {
                    log.info("old {} new {}", oldCount, countTest1.count);
                }
                // if (System.currentTimeMillis() - countTest1.refreshAt > 5000) {
                // log.info("current {} and {}", newCount,countTest1.count);
                // countTest1.refreshAt = System.currentTimeMillis();
                // }

            });
        }
    }
}
