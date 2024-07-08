package com.xiaozhang.spring.service.test;

import lombok.extern.slf4j.Slf4j;
import org.springframework.context.SmartLifecycle;
import org.springframework.stereotype.Component;

/**
 * @author : xiaozhang
 * @since : 2024/6/24 14:33
 */

@Slf4j
@Component
public class TestService implements SmartLifecycle {

    @Override
    public void start() {
        
    }

    @Override
    public void stop() {

    }

    @Override
    public boolean isRunning() {
        return false;
    }
}
