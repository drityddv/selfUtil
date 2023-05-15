package com.xiaozhang.spring.service.ff.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.SmartLifecycle;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Component;

import com.xiaozhang.spring.config.XzProperties;

import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2022/5/12 02:14
 */

@Slf4j
@Component
public class FinalFantasyService implements SmartLifecycle {

    @Autowired
    private Environment environment;

    @Autowired
    private XzProperties xzProperties;

    @SneakyThrows
    @Override
    public void start() {
        log.info("ff14 service start...");
        // ClassPathResource classResource = new ClassPathResource(Ff14Util.PATH + Ff14Util.JUE_LONG_SHI);
        // PoiUtils.read(classResource.getFile());
    }

    @Override
    public void stop() {

    }

    @Override
    public boolean isRunning() {
        return false;
    }

}
