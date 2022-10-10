package com.xiaozhang.test.proxy.cglib;

import lombok.extern.slf4j.Slf4j;
import net.sf.cglib.proxy.Enhancer;

/**
 * @author : xiaozhang
 * @since : 2022/7/3 20:36
 */
@Slf4j
public class TestMain2 {

    public static void main(String[] args) {

        Enhancer enhancer = new Enhancer();
        enhancer.setSuperclass(OriginClass.class);
        enhancer.setCallback(new CglibProxyDefine());

        OriginClass o = (OriginClass)enhancer.create();
        o.print(TestMain2.class.getSimpleName());
        log.info("");

    }

}
