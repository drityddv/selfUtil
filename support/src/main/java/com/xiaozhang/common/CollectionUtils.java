package com.xiaozhang.common;

import java.util.*;

import lombok.extern.slf4j.Slf4j;

/**
 * @author xiaozhang
 * @date 2021-08-25 22:06
 */
@Slf4j
public class CollectionUtils {

    public static boolean isEmpty(Collection<?> collection) {
        return collection == null || collection.size() == 0;
    }

    public static boolean isNotEmpty(Collection<?> collection) {
        return !isEmpty(collection);
    }

    public static List<?> sublist(List<?> originList, int startIndex, int endIndex) {
        if (isEmpty(originList)) {
            return Collections.emptyList();
        }
        if (startIndex < 0 || endIndex < 0 || startIndex > endIndex) {
            return Collections.emptyList();
        }

        if (startIndex > originList.size()) {
            return Collections.emptyList();
        }

        if (endIndex > originList.size()) {
            endIndex = originList.size();
        }
        return originList.subList(startIndex, endIndex);
    }

    public static void main(String[] args) {
        List<Integer> list = new ArrayList<>();

        for (int i = 0; i < 10; i++) {
            list.add(i);
        }

        // log.info("0 0 {}", list.subList(0, 0));
        // log.info("0 1 {}", list.subList(0, 1));
        // log.info("1 1 {}", list.subList(1, 1));
        // log.info("0 10 {}", list.subList(0, 10));
        // log.info("0 11 {}", list.subList(0, 11));

        log.info("0 100 {}", sublist(list, 9, 11));
    }

}
