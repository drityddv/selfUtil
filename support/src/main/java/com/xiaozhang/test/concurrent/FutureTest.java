package com.xiaozhang.test.concurrent;

import com.xiaozhang.util.UnSafeUtil;
import lombok.extern.slf4j.Slf4j;
import sun.misc.Unsafe;

import java.util.concurrent.Callable;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

/**
 * @author : xiaozhang
 * @since : 2023/7/5 15:27
 */

@Slf4j
public class FutureTest {

    public static void main(String[] args) throws Exception {
        Unsafe unsafe = UnSafeUtil.getUnsafe();
        Thread[] threads = new Thread[5];
        for (int i = 0; i < threads.length; i++) {
            threads[i] = new Thread(() -> {
                log.info("{} 即将park", Thread.currentThread().getName());
                unsafe.park(false, 0);
                log.info("{}执行完成", Thread.currentThread().getName());
            }, i + "");
            threads[i].start();
        }

        Thread.sleep(1000 * 10);
        for (Thread thread : threads) {
            unsafe.unpark(thread);
        }

    }

    private static void callableTest() throws InterruptedException, ExecutionException {
        ExecutorService executor = Executors.newFixedThreadPool(4);
        // 定义任务:
        Callable<String> task = () -> {
            log.info("job started");
            Thread.sleep(5 * 1000);
            return "done";
        };
        // 提交任务并获得Future:
        Future<String> future = executor.submit(task);
        // 从Future获取异步执行返回的结果:
        String result = future.get(); // 可能阻塞
        log.info("{}", result);
        executor.shutdown();
    }

}
