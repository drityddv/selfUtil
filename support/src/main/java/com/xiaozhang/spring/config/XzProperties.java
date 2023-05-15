package com.xiaozhang.spring.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

import lombok.Getter;
import lombok.Setter;

/**
 * @author : xiaozhang
 * @since : 2022/10/14 10:39
 */

@Getter
@Setter
@ConfigurationProperties(prefix = "xiaozhang.common")
public class XzProperties {

    private String path;

}
