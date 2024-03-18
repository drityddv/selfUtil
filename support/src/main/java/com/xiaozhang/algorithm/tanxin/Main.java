package com.xiaozhang.algorithm.tanxin;

import java.util.*;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2024/3/11 21:13
 */

@Slf4j
public class Main {

    public static final Main main = new Main();

    public static void main(String[] args) {
        String str = "abc";
        Object result = main.validPalindrome(str);
        log.info("{}", result);
    }


    public boolean validPalindrome(String s) {
        return validPalindrome1(s.toCharArray(), 0, s.length() - 1, true);
    }
    
    public boolean validPalindrome1(char[] charArray, int leftIndex, int rightIndex, boolean canReplace) {
        while (leftIndex < rightIndex) {
            if (charArray[leftIndex] == charArray[rightIndex]) {
                leftIndex++;
                rightIndex--;
                continue;
            }

            if (!canReplace) {
                return false;
            }

            return validPalindrome1(charArray, leftIndex + 1, rightIndex, false)
                || validPalindrome1(charArray, leftIndex, rightIndex - 1, false);
        }
        return true;
    }

    public int arrayPairSum(int[] nums) {
        int result = 0;
        Arrays.sort(nums);
        for (int i = 0; i < nums.length; i += 2) {
            result += nums[i];
        }
        return result;
    }

    public int longestPalindrome(String s) {
        Map<Character, Integer> map = new HashMap<>(128);
        for (char c : s.toCharArray()) {
            map.merge(c, 1, Integer::sum);
        }
        int pairCount = 0;
        int singleCount = 0;

        for (Integer charCount : map.values()) {
            pairCount += charCount / 2;
            singleCount = Math.max(singleCount, charCount % 2);
        }

        return pairCount * 2 + singleCount;
    }

    public boolean canPlaceFlowers(int[] flowerbed, int n) {

        for (int i = 0; i < flowerbed.length;) {
            // 有花 跳2格
            if (flowerbed[i] == 1) {
                i += 2;
                continue;
            }

            // 下一格有花 跳3格
            if (i + 1 < flowerbed.length && flowerbed[i + 1] == 1) {
                i += 3;
                continue;
            }

            // 没花种花 跳格
            if (flowerbed[i] == 0) {
                i += 2;
                n--;
                continue;
            }

            i++;
        }

        return n <= 0;
    }

    public int findContentChildren(int[] g, int[] s) {
        Arrays.sort(g);
        Arrays.sort(s);

        int result = 0;
        int gIndex = 0;

        for (int i = 0; i < s.length; i++) {
            if (gIndex >= g.length) {
                break;
            }
            int requiredSize = g[gIndex];
            if (s[i] < requiredSize) {
                continue;
            }
            result++;
            gIndex++;
        }

        return result;
    }

}
