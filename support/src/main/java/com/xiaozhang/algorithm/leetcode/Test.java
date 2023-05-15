package com.xiaozhang.algorithm.leetcode;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2023/3/26 14:20
 */
@Slf4j
public class Test {

    public static boolean isPowerOfThree(int x, int n) {
        if (x == 1) {
            return n == 0;
        } else if (x % 3 != 0) {
            return false;
        } else {
            return isPowerOfThree(x / 3, n - 1);
        }
    }

    public static void main(String[] args) {
        log.info("{}", isPowerOfThree(9, 3));
    }
}
