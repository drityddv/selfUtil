package com.xiaozhang.lf.config;

import com.xiaozhang.lf.demo.AbstractConfig;

import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/**
 * @author : xiaozhang
 * @since : 2023/7/21 11:10
 */

public class ConfigHolder {

    /**
     * 某一类配置实例
     */
    private Map<Object, AbstractConfig> configMap = new HashMap<>();
    
    public AbstractConfig getById(Object id){
        return configMap.get(id);
    }
    
    public Collection<AbstractConfig> getAllConfig(){
        return Collections.unmodifiableCollection(configMap.values());
    }
    
}
