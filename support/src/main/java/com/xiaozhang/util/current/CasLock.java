package com.xiaozhang.util.current;

import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.atomic.AtomicInteger;

/**
 * @author : xiaozhang
 * @since : 2024/6/24 17:40
 */
@Slf4j
public class CasLock {
    // 不用锁了,用cas来做进程内的并发限制
    private AtomicInteger atomicInteger = new AtomicInteger(0);

    public void exec(Runnable runnable) {
        while (true) {
            if (!atomicInteger.compareAndSet(0, 1)) {
                // 先释放一下,避免本地debug占用cpu过高的问题
                Thread.yield();
                continue;
            }
            try {
                runnable.run();
            } finally {
                atomicInteger.set(0);
            }
            return;
        }
    }

}
