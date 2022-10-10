package com.xiaozhang.test.concurrent;

import java.util.concurrent.TimeUnit;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2022/9/7 14:35
 */
@Slf4j
public class ConcurrentTest2 {

    public static void main(String[] args) throws Exception {

        Thread t0 = new Thread(new ThreadGroup("线程0"), ConcurrentTest2::run);
        Thread t1 = new Thread(new ThreadGroup("线程1"), ConcurrentTest2::run);

        t0.start();
        t1.start();
        Thread.sleep(TimeUnit.SECONDS.toMillis(10));

        t0.interrupt();
        Thread.sleep(Integer.MAX_VALUE);

    }

    private static void run() {
        while (true) {
            // if (Thread.currentThread().isInterrupted()) {
            // break;
            // }
            if (Thread.interrupted()) {
                break;
            }
            // try {
            // Thread.sleep(1000);
            // } catch (InterruptedException e) {
            // e.printStackTrace();
            // Thread.currentThread().interrupt();
            // }
            long sum = 0;
            for (int i = 0; i < Integer.MAX_VALUE; i++) {
                sum += i;
            }
            log.info("{} isInterrupted {} {}", Thread.currentThread().getName(), Thread.currentThread().isInterrupted(),
                sum);
        }
    }
}
