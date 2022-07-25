package test.proxy.cglib;

import java.lang.reflect.Method;

import lombok.extern.slf4j.Slf4j;
import net.sf.cglib.proxy.MethodInterceptor;
import net.sf.cglib.proxy.MethodProxy;

/**
 * @author : xiaozhang
 * @since : 2022/7/4 17:22
 */
@Slf4j
public class CglibProxyDefine implements MethodInterceptor {

    @Override
    public Object intercept(Object o, Method method, Object[] objects, MethodProxy methodProxy) throws Throwable {
        log.info("start...");
        if (o != null) {
            methodProxy.invokeSuper(o, objects);
        }
        log.info("end...");
        return null;
    }
}
