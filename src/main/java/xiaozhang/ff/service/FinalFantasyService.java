package xiaozhang.ff.service;

import org.springframework.context.SmartLifecycle;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;

import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import xiaozhang.common.PoiUtils;
import xiaozhang.ff.util.Ff14Util;

/**
 * @author : xiaozhang
 * @since : 2022/5/12 02:14
 */

@Slf4j
@Component
public class FinalFantasyService implements SmartLifecycle {

    @SneakyThrows
    @Override
    public void start() {
        ClassPathResource classResource = new ClassPathResource(Ff14Util.PATH + Ff14Util.JUE_LONG_SHI);
        PoiUtils.read(classResource.getFile());
    }

    @Override
    public void stop() {

    }

    @Override
    public boolean isRunning() {
        return false;
    }

}
