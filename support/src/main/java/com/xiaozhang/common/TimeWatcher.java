package com.xiaozhang.common;

/**
 * 记录耗时
 *
 * @author : xiaozhang
 * @since : 2022/7/20 17:00
 */

public class TimeWatcher {

    private long startAt;
    private long stopAt;

    public static TimeWatcher of() {
        return new TimeWatcher();
    }

    public void start() {
        reset();
        this.startAt = System.currentTimeMillis();
    }

    public void stop() {
        this.stopAt = System.currentTimeMillis();
    }

    public long getCost() {
        return stopAt - startAt;
    }

    public void reset() {
        startAt = 0L;
        stopAt = 0L;
    }

}
