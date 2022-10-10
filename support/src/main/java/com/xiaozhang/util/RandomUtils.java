package com.xiaozhang.util;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * @author : xiaozhang
 * @since : 2022/9/15 15:14
 */

public class RandomUtils extends org.apache.commons.lang3.RandomUtils {

    /**
     * 随机X个不重复的元素
     */
    public static List<Integer> randomUnRepeated(int size) {
        Set<Integer> result = new HashSet<>();
        while (result.size() < size) {
            result.add(RandomUtils.nextInt(1, size + 1));
        }
        return new ArrayList<>(result);
    }

}
