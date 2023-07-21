package com.xiaozhang.test.concurrent;

import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.CompletableFuture;
import java.util.concurrent.CountDownLatch;

/**
 * @author : xiaozhang
 * @since : 2023/7/7 16:24
 */

@Slf4j
public class CompletableFutureTest {

    private static CountDownLatch countDownLatch = new CountDownLatch(1);

    public static void main(String[] args) throws InterruptedException {
        CompletableFuture<Object> completableFuture = CompletableFuture.supplyAsync(() -> {
            log.info("任务执行... 预计耗时10s");
            try {
                Thread.sleep(1000 * 50);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            return null;
        });

        CompletableFuture<Void> thenAccept = completableFuture.thenAccept(o -> {
            log.info("任务完成...");
            countDownLatch.countDown();
        });

        countDownLatch.await();
        log.info("主线程完毕...");

    }

}
