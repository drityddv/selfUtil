package com.xiaozhang.spider.utils;

import java.util.*;

import com.xiaozhang.spider.param.SpiderParam;
import com.xiaozhang.spider.param.SpiderParam.SpiderParamBuilder;
import org.apache.commons.lang3.StringUtils;
import us.codecraft.webmagic.Spider;

/**
 * @author : xiaozhang
 * @since : 2024/3/19 16:48
 */

public class SpiderUtil {
    
    public static void initSpider(SpiderParamBuilder paramBuilder, Spider spider){
        SpiderParam spiderParam = paramBuilder.build();

        for (String s : spiderParam.calcUrl()) {
            spider.addUrl(s);
        }

        String domain = spiderParam.getDomain();
        if (StringUtils.isNotEmpty(domain)) {
            spider.getSite().setDomain(domain);
        }
        
        Map<String, String> cookie = spiderParam.getCookie();
        if (cookie != null) {
            cookie.forEach((key, value) -> spider.getSite().addCookie(key, value));
        }

    }

    public static  Map<String, String> parseCookie(String cookieString) {
        Map<String, String> map = new HashMap<>();

        if (StringUtils.isEmpty(cookieString)) {
            return map;
        }

        String[] eachCookieString = cookieString.split(";");
        for (String eachCookie : eachCookieString) {
            String[] cookie = eachCookie.split("=");
            map.put(cookie[0], cookie[1]);
        }

        return map;
    }

}
