package com.xiaozhang.lf.db;

import org.junit.Test;

import com.xiaozhang.lf.LfUtil;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2023/9/6 17:10
 */

@Slf4j
public class LFCopyBeanMapper extends LfUtil {

    @Test
    public void copyMapper() {
        copyLfMappers(668);
    }
}
