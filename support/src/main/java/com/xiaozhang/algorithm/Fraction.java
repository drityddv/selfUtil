package com.xiaozhang.algorithm;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

import com.xiaozhang.common.TimeWatcher;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2023/3/26 14:18
 */
@Slf4j
public class Fraction {

    public static int test1(int n) {
        int result = n;
        result--; // 将result减1，这将把result和最接近的2的幂次方的差转换为1的位
        result |= result >> 1; // 将相邻位的值合并，即将差转换为2的位
        result |= result >> 2; // 将相邻的2位的值合并
        result |= result >> 4; // 将相邻的4位的值合并
        result |= result >> 8; // 将相邻的8位的值合并
        result |= result >> 16; // 将相邻的16位的值合并
        result++; // 最接近的2的幂次方是比n大的最小值
        log.info("{} {}", n, result);
        return result;
    }

    public static void main(String[] args) {
        int total = 10000 * 1000;
        List<Integer> list1 = new ArrayList<>(total);
        List<Integer> list2 = new LinkedList<>();
        for (int i = 0; i < total; i++) {
            list1.add(i);
            list2.add(i);
        }

        TimeWatcher timeWatcher1 = new TimeWatcher();
        timeWatcher1.start();
        list1.remove(total / 2);
        timeWatcher1.stop();

        TimeWatcher timeWatcher2 = new TimeWatcher();
        timeWatcher2.start();
        list2.remove(total / 2);
        timeWatcher2.stop();

        log.info("{}", timeWatcher1.getCost());
        log.info("{}", timeWatcher2.getCost());
    }
}
