package com.xiaozhang.lf.demo;

/**
 * @author : xiaozhang
 * @since : 2023/7/21 11:02
 */

public abstract class AbstractConfig {

    /**
     * 配置自我解析
     */
    public void selfParse() {
    }

    /**
     * 配置自我检查
     */
    public boolean selfCheck() {
        return true;
    }

}
