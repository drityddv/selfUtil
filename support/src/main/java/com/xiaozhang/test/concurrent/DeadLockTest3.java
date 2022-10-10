package com.xiaozhang.test.concurrent;

import java.util.concurrent.locks.ReentrantLock;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2022/9/7 14:35
 */
@Slf4j
public class DeadLockTest3 {

    public static void main(String[] args) throws Exception {

        ReentrantLock lock1 = new ReentrantLock();
        ReentrantLock lock2 = new ReentrantLock();

        Thread t1 = new Thread(new ThreadGroup("线程1"), () -> reentLock(lock1, lock2));
        Thread t2 = new Thread(new ThreadGroup("线程2"), () -> reentLock(lock2, lock1));
        t1.start();
        t2.start();

    }

    private static void reentLock(ReentrantLock lock1, ReentrantLock lock2) {
        while (true) {
            try {
                lock1.lock();
                log.info("{} 获得锁 {}", Thread.currentThread().getName(), lock1.hashCode());
                lock2.lock();
                log.info("{} 获得锁 {}", Thread.currentThread().getName(), lock2.hashCode());
            } finally {
                lock1.unlock();
                lock2.unlock();
            }
        }

    }

    private static void synDeadLocks() {
        Lock a = new Lock("锁A");
        Lock b = new Lock("锁B");
        Thread t1 = new Thread(new ThreadGroup("线程1"), () -> run(a, b));
        Thread t2 = new Thread(new ThreadGroup("线程2"), () -> run(b, a));
        t1.start();
        t2.start();
    }

    private static void run(Lock lock1, Lock lock2) {
        while (true) {
            synchronized (lock1) {
                log.info("{} 获得锁 {}", Thread.currentThread().getName(), lock1.name);
                synchronized (lock2) {
                    log.info("{} 获得锁 {}", Thread.currentThread().getName(), lock2.name);
                }
            }
        }
    }

    static class Lock {
        String name;

        public Lock(String name) {
            this.name = name;
        }
    }
}
