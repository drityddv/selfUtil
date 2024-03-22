package com.xiaozhang.lf;

import lombok.extern.slf4j.Slf4j;
import redis.clients.jedis.Jedis;

/**
 * @author : xiaozhang
 * @since : 2023/10/9 21:27
 */

@Slf4j
public class RedisUtils {

    public static Jedis jedis;

    static {
        jedis = new Jedis("10.0.0.115", 6379);
        log.info("jedis连接成功 :{}", jedis.ping());
    }

    public static void main(String[] args) {
        double score = 60797.273265999655;
        int intScore = new Double(score).intValue();
        int scoreFix = (int)(intScore * 1.1);
        log.info("scoreFix:{}", scoreFix);
    }

    private static void clearAllianceBpRank() {
        jedis.del("alliancebp_allianceRank_670");
    }

}
