package redis;

import com.alibaba.fastjson.JSONObject;

import lombok.extern.slf4j.Slf4j;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.Transaction;
import redis.mq.ExtendJedisPubSub;

/**
 * @author : xiaozhang
 * @since : 2022/3/24 12:58
 */

@Slf4j
public class JedisConn {

    public static Jedis jedis;

    static {
        jedis = new Jedis("127.0.0.1", 6379);
        log.info("jedis连接成功 :{}", jedis.ping());
    }

    public static void main(String[] args) {
        test3();
    }

    private static void test3() {
        // jedis.subscribe(,"c1");
//        jedis.subscribe(new ExtendJedisPubSub(), "c1");
//        jedis.subscribe(new ExtendJedisPubSub(), "c2", "c3");

        Runnable run = new Runnable() {
			@Override
			public void run() {
				log.info("attack...");
			}
		};
        run.run();
    }

    private static void test2() {
        for (int i = 0; i < 10000 * 100; i++) {
            jedis.setex("k" + i, 180, "v" + i);
        }
        long start = System.currentTimeMillis();
        jedis.save();
        log.info("耗时:{}", System.currentTimeMillis() - start);
        jedis.bgsave();
    }

    private static void test1() {
        Transaction transaction = jedis.multi();
        try {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("1", "v1");
            jsonObject.put("2", "v2");

            transaction.set("k1", jsonObject.toJSONString());
            int b = 0;
            int a = 10 / b;
            transaction.exec();
        } catch (Exception e) {
            transaction.discard();
            log.error("transaction exec failed", e);
        } finally {
            jedis.close();
        }
    }
}
