package com.xiaozhang.test.arthas;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.RandomUtils;

/**
 * @author : xiaozhang
 * @since : 2022/5/16 00:44
 */

public class Test1 {

    private static String param1 = "1";

    public static List<Object> muckData(long param) {
        List<Object> result = new ArrayList<>();
        for (int i = 0; i < RandomUtils.nextInt(10,1000); i++) {
			result.add(RandomUtils.nextInt(1,Integer.MAX_VALUE));
        }
		try {
			Thread.sleep(RandomUtils.nextInt(10,30));
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
        return result;
    }
}
