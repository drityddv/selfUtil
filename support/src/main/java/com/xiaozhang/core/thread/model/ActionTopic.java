package com.xiaozhang.core.thread.model;

import com.xiaozhang.core.thread.model.action.QueueAction;
import com.xiaozhang.util.current.CasLock;

import java.util.concurrent.ConcurrentLinkedQueue;

/**
 * 
 * @author : xiaozhang
 * @since : 2024/6/24 17:35
 */

public class ActionTopic {

    // 队列id
    private String id;
    // 锁 
    private CasLock casLock = new CasLock();
    // 任务队列
    private ConcurrentLinkedQueue<QueueAction> queue = new ConcurrentLinkedQueue();

    public void offer(QueueAction queueAction) {
        casLock.exec(() -> queue.offer(queueAction));
    }
    
    public void consumeAction() {
        if(queue.isEmpty()) {
            return;
        }

        QueueAction poll = queue.poll();
    }
    
}
