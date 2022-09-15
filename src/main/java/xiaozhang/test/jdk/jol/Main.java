package xiaozhang.test.jdk.jol;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;

import org.openjdk.jol.info.ClassLayout;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2022/7/8 11:43
 */

@Slf4j
public class Main {

    public static void main(String[] args) {
//        System.out.println(VM.current().details());
//		System.out.println(ClassLayout.parseClass(HashMap.class).toPrintable());
//		System.out.println(ClassLayout.parseClass(ConcurrentHashMap.class).toPrintable());
		HashMap hashMap = new HashMap();
		ConcurrentHashMap concurrentHashMap = new ConcurrentHashMap();
		for (int i = 0; i < 10000; i++) {
			hashMap.put(i,i);
			concurrentHashMap.put(i,i);
		}
		log.info("hashMap:{}",ClassLayout.parseInstance(hashMap).toPrintable());
		log.info("concurrent:{}",ClassLayout.parseInstance(concurrentHashMap).toPrintable());
		log.info("arrayList:{}",ClassLayout.parseInstance(new ArrayList<>()).toPrintable());
		log.info("copyOnWriteArrayList:{}",ClassLayout.parseInstance(new CopyOnWriteArrayList<>()).toPrintable());
	}
}
