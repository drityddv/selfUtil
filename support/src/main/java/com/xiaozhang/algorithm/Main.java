package com.xiaozhang.algorithm;

/**
 * @author : xiaozhang
 * @since : 2024/5/17 15:25
 */

import java.util.ArrayList;
import java.util.List;

public class Main {
    public static List<int[]> divideXAxis(int totalLength, int numPartitions, boolean increasing) {
        int baseLength = totalLength / numPartitions; // 每份的基础长度
        int extraLength = totalLength % numPartitions; // 多出来的长度
        List<int[]> partitions = new ArrayList<>();
        int start;
        int end;
        if (increasing) {
            start = 0;
            end = baseLength;
            for (int i = 0; i < numPartitions; i++) {
                // 如果还有多余的长度，则将其分配给当前分段
                if (extraLength > 0) {
                    end += 1;
                    extraLength -= 1;
                }
                partitions.add(new int[] {start, end});
                start = end;
                end += baseLength;
            }
        } else {
            start = totalLength;
            end = start - baseLength;
            for (int i = 0; i < numPartitions; i++) {
                // 如果还有多余的长度，则将其分配给当前分段
                if (extraLength > 0) {
                    end -= 1;
                    extraLength -= 1;
                }
                partitions.add(new int[] {end, start});
                start = end;
                end -= baseLength;
            }
        }
        return partitions;
    }

    public static void main(String[] args) {
        int totalLength = 9;
        int numPartitions = 4;

        // 从 0 开始递增处理
        List<int[]> xPartitionsIncreasing = divideXAxis(totalLength, numPartitions, true);
        System.out.println("From 0:");
        for (int i = 0; i < xPartitionsIncreasing.size(); i++) {
            int[] partition = xPartitionsIncreasing.get(i);
            System.out.println("Partition " + (i + 1) + ": [" + partition[0] + ", " + partition[1] + "]");
        }

        // 从 9 开始递减处理
        List<int[]> xPartitionsDecreasing = divideXAxis(totalLength, numPartitions, false);
        System.out.println("\nFrom 9:");
        for (int i = 0; i < xPartitionsDecreasing.size(); i++) {
            int[] partition = xPartitionsDecreasing.get(i);
            System.out.println("Partition " + (i + 1) + ": [" + partition[0] + ", " + partition[1] + "]");
        }
    }
}
