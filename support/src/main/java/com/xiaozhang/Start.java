package com.xiaozhang;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

import com.xiaozhang.spring.config.XzProperties;

/**
 * @author : xiaozhang
 * @since : 2022/5/12 00:02
 */

@SpringBootApplication
@EnableConfigurationProperties(XzProperties.class)
public class Start {
    public static void main(String[] args) {
        SpringApplication application = new SpringApplication(Start.class);
        application.run(args);
    }
}
