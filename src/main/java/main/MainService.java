package main;

import java.util.LinkedList;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

import org.apache.commons.lang3.RandomUtils;
import org.springframework.context.SmartLifecycle;
import org.springframework.stereotype.Component;

import ff.Ff14Util;
import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2022/5/12 02:14
 */

@Slf4j
//@Component
public class MainService implements SmartLifecycle {
    /**
     * 业务最大对象
     */
    private static final int MAX_OBJECT_NUM = 15000;

    private long cd;

    private ThreadLocal<LinkedList<TestObject>> threadLocal = ThreadLocal.withInitial(LinkedList::new);

    @Override
    public void start() {
        try {
            Ff14Util.generateScript();
        } catch (Exception e) {
            e.printStackTrace();
        }

        new Thread(() -> {
            ExecutorService executorService = Executors.newFixedThreadPool(8);
            while (true) {
                for (int i = 0; i < 1000; i++) {
                    executorService.submit(() -> {

                        LinkedList<TestObject> linkedList = threadLocal.get();
                        linkedList.removeIf(t -> System.currentTimeMillis() >= t.endAt);

                        if (linkedList.size() < MAX_OBJECT_NUM) {
                            TestObject testObject = muckClientRequest();
                            linkedList.add(testObject);
                        }

                        if (System.currentTimeMillis() >= cd) {
                            log.info("线程:{} 当前对象个数:{}", Thread.currentThread().getName(), linkedList.size());
                            cd = System.currentTimeMillis() + TimeUnit.SECONDS.toMillis(5);
                        }
                    });

                }

                try {
                    Thread.sleep(1000L);
                } catch (Exception e) {
                    e.printStackTrace();
                }

            }
        }, "test-thread").start();

    }

    @Override
    public void stop() {

    }

    @Override
    public boolean isRunning() {
        return false;
    }

    // 模拟业务对象存活在1min ~ 5min 左右
    private TestObject muckClientRequest() {
        TestObject testObject = new TestObject();
        testObject.endAt = System.currentTimeMillis() + TimeUnit.SECONDS.toMillis(RandomUtils.nextInt(120, 300));
        testObject.bytes = new byte[1024 * 20];
        return testObject;
    }

    @Getter
    @Setter
    private class TestObject {
        private long endAt;
        private byte[] bytes;

    }
}
