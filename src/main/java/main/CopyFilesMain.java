package main;

import java.io.IOException;

import com.google.common.hash.BloomFilter;
import com.google.common.hash.Funnels;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : ddv
 * @since : 2021/8/28 14:25
 */
@Slf4j
public class CopyFilesMain {

    public static void main(String[] args) throws IOException {
        BloomFilter<Integer> bloomFilter = BloomFilter.create(Funnels.integerFunnel(), Integer.MAX_VALUE);

        long lastInsertAt = 0L;
        int totalSize = 10000 * 100;
        for (int i = 0; i < totalSize; i = i + 2) {
            bloomFilter.put(i);
            log.info("添加:{} 耗时:{}", i, System.currentTimeMillis() - lastInsertAt);
            lastInsertAt = System.currentTimeMillis();
        }

        for (int i = 0; i < totalSize; i++) {
            boolean contain = bloomFilter.mightContain(i);
            if (contain && i % 2 == 1) {
                log.info("number:{} hit", i);
            }
        }
    }
}
