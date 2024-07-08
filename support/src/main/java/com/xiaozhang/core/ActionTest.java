package com.xiaozhang.core;

import com.xiaozhang.util.current.CasLock;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.mutable.MutableInt;
import org.junit.Test;

import java.util.concurrent.*;

/**
 * @author : xiaozhang
 * @since : 2024/6/24 17:52
 */
@Slf4j
public class ActionTest {

    @Test
    public void test() throws InterruptedException {
        MutableInt mutableInt = new MutableInt(0);
        CasLock casLock = new CasLock();

        ExecutorService executorService = Executors.newFixedThreadPool(32);

        for (int i = 0; i < 1000; i++) {
            executorService.submit(() -> casLock.exec(() -> {
                Integer old = mutableInt.getValue();
                int newValue = mutableInt.addAndGet(1);
                log.info("old :{} new:{}", old, newValue);
            }));
        }
        
        executorService.shutdown();
        executorService.awaitTermination(Integer.MAX_VALUE, TimeUnit.SECONDS);
        log.info("mutableInt:{}", mutableInt.getValue());

    }
}
