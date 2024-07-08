package com.xiaozhang.core.thread;

import com.xiaozhang.core.thread.model.ActionTopic;
import com.xiaozhang.core.thread.model.action.QueueAction;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.SmartLifecycle;
import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * @author : xiaozhang
 * @since : 2024/6/24 17:34
 */

@Slf4j
public class ActionCoreService {

    // id -> topic
    private Map<String, ActionTopic> actionTopicMap = new ConcurrentHashMap<>();

    public void offer(String id, QueueAction queueAction) {
        ActionTopic actionTopic = actionTopicMap.computeIfAbsent(id, k -> new ActionTopic());
        actionTopic.offer(queueAction);
        log.debug("offer id:{}, queueAction:{}", id, queueAction);
    }

}
