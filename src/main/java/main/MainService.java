package main;

import org.springframework.context.SmartLifecycle;
import org.springframework.stereotype.Component;

import ff.Ff14Util;
import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2022/5/12 02:14
 */

@Slf4j
@Component
public class MainService implements SmartLifecycle {
    @Override
    public void start() {
        try {
            Ff14Util.generateScript();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void stop() {

    }

    @Override
    public boolean isRunning() {
        return false;
    }
}
