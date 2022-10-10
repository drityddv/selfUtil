package com.xiaozhang.test.concurrent;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2022/9/7 14:35
 */
@Slf4j
public class ConcurrentTest3 {

    public static void main(String[] args) throws Exception {

        Thread t0 = new Thread(new ThreadGroup("线程0"), () -> {
            int count = 0;
            while (count < 10) {
                log.info("thread 0 running count {}", count++);
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }

        });
        Thread t1 = new Thread(new ThreadGroup("线程1"), () -> {
            int count = 0;
            while (count < 10) {
                log.info("thread 1 running count {}", count++);
                if (count > 5) {
                    try {
                        t0.join(200);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            }

        });

        t0.start();
        t1.start();

        Thread.sleep(Integer.MAX_VALUE);

    }

}
