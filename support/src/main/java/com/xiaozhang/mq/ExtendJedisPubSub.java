package com.xiaozhang.mq;

import lombok.extern.slf4j.Slf4j;
import redis.clients.jedis.JedisPubSub;

/**
 * @author : xiaozhang
 * @since : 2022/4/1 13:57
 */

@Slf4j
public class ExtendJedisPubSub extends JedisPubSub {

    @Override
    public void onMessage(String channel, String message) {
        super.onMessage(channel, message);
        log.info("收到消息:{}",message);
    }
}
