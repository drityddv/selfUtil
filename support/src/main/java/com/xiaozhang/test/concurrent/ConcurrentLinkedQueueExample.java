package com.xiaozhang.test.concurrent;

import lombok.extern.slf4j.Slf4j;
import org.checkerframework.checker.units.qual.A;

import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * @author : xiaozhang
 * @since : 2024/6/24 14:30
 */
@Slf4j
public class ConcurrentLinkedQueueExample {

    public static void main(String[] args) throws InterruptedException {
        ConcurrentLinkedQueue<Integer> queue = new ConcurrentLinkedQueue<>();

        AtomicInteger pollCount = new AtomicInteger();
        
        int testCount = 10000* 10;
        ExecutorService executorService = Executors.newFixedThreadPool(32);
        for (int i = 1; i <= 10; i++) {
            int finalI = i;
            executorService.submit(() -> {
                queue.offer(finalI);
            });
        }

        for (int i = 1; i <= testCount; i++) {
            executorService.submit(() -> {
                Integer poll = queue.poll();
                log.info("poll:{}", poll);
                pollCount.incrementAndGet();
            });
        }

        executorService.shutdown();
        executorService.awaitTermination(Integer.MAX_VALUE, TimeUnit.SECONDS);
        log.info("pollCount:{}", pollCount.get());

    }

}
