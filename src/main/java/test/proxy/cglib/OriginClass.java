package test.proxy.cglib;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since  : 2022/7/4 18:16
 */
@Slf4j
public class OriginClass {

	public void print(String stringParams){
		log.info(stringParams);
	}
}
