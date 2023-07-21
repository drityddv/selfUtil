package com.xiaozhang.lf.config;

import com.xiaozhang.lf.demo.AbstractConfig;
import lombok.extern.slf4j.Slf4j;

import java.util.HashMap;
import java.util.Map;

/**
 * @author : xiaozhang
 * @since : 2023/7/21 11:08
 */

@Slf4j
public class ConfigDataBox {

    /**
     * 所有配置解析结果
     */
    private Map<Class<? extends AbstractConfig>,ConfigHolder> allConfigHolderMap = new HashMap<>();
    
    
}
