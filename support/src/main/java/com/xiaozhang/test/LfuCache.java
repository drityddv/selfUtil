package com.xiaozhang.test;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

/**
 * @author : xiaozhang
 * @since : 2023/3/13 10:23
 */

public class LfuCache {

    private int capacity;
    private Map<Integer, Integer> cacheMap; // 存储key和value的map
    private Map<Integer, Integer> freqMap; // 存储key和访问次数的map
    private Map<Integer, LinkedHashSet<Integer>> freqKeysMap; // 存储访问次数和key的map
    private int minFreq; // 当前最小的访问次数

    public LfuCache(int capacity) {
        this.capacity = capacity;
        cacheMap = new HashMap<>();
        freqMap = new HashMap<>();
        freqKeysMap = new HashMap<>();
        minFreq = 0;
    }

    public int get(int key) {
        if (!cacheMap.containsKey(key)) {
            return -1;
        }

        // 更新访问次数和对应的key集合
        int freq = freqMap.get(key);
        freqMap.put(key, freq + 1);
        freqKeysMap.get(freq).remove(key);
        if (freqKeysMap.get(freq).isEmpty()) {
            freqKeysMap.remove(freq);
            if (freq == minFreq) {
                minFreq++;
            }
        }
        freqKeysMap.putIfAbsent(freq + 1, new LinkedHashSet<>());
        freqKeysMap.get(freq + 1).add(key);

        return cacheMap.get(key);
    }

    public void put(int key, int value) {
        if (capacity <= 0) {
            return;
        }

        // 如果key已存在，则更新value和访问次数
        if (cacheMap.containsKey(key)) {
            cacheMap.put(key, value);
            get(key);
            return;
        }

        // 如果缓存已满，则删除最不常用的缓存块
        if (cacheMap.size() >= capacity) {
            int leastFreqKey = freqKeysMap.get(minFreq).iterator().next();
            freqKeysMap.get(minFreq).remove(leastFreqKey);
            if (freqKeysMap.get(minFreq).isEmpty()) {
                freqKeysMap.remove(minFreq);
            }
            cacheMap.remove(leastFreqKey);
            freqMap.remove(leastFreqKey);
        }

        // 插入新的key和value，并将访问次数设置为1，加入freqKeysMap
        cacheMap.put(key, value);
        freqMap.put(key, 1);
        freqKeysMap.putIfAbsent(1, new LinkedHashSet<>());
        freqKeysMap.get(1).add(key);
        minFreq = 1;
    }

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        int capacity = scanner.nextInt();
        scanner.nextLine();
        String input = scanner.nextLine();
        String[] nums = input.split(" ");

        LfuCache lfuCache = new LfuCache(capacity);

        StringBuilder sb = new StringBuilder();
        for (String num : nums) {
            int n = Integer.parseInt(num);
            lfuCache.put(n, n);
            sb.append(lfuCache.get(n)).append(" ");
        }

        System.out.println(sb);

        // 输出被淘汰的系列
        List<Integer> removedKeys = new ArrayList<>(lfuCache.cacheMap.keySet());
        Collections.sort(removedKeys);
        int sum = 0;
        for (int key : removedKeys) {
            sum += key;
        }
        System.out.println(sum);
    }
}
