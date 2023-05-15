package com.xiaozhang.test.protocol;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.xiaozhang.util.JsonUtils;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2022/7/14 14:37
 */

@Slf4j
public class Main {

    public static void main(String[] args) throws IOException {
        List<Integer> list1 = new ArrayList<>();
        for (int i = 0; i < 10; i++) {
            list1.add(i);
        }

        Collections.shuffle(list1);
        List<Integer> list2 = new ArrayList<>(list1);
        Collections.sort(list2);
        log.info("origin {}", JsonUtils.object2String(list1));
        quickSort(list1, 0, list1.size(), list1.get(0));
        log.info("after {}", JsonUtils.object2String(list1));
    }

    private static void quickSort(List<Integer> list, int leftIndex, int rightIndex, int pivot) {

    }

}
