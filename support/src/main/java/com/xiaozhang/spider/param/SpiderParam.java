package com.xiaozhang.spider.param;

import java.util.*;

import lombok.Builder;

/**
 * @author : xiaozhang
 * @since : 2024/3/19 17:29
 */

@Builder
public class SpiderParam {
    // 需要爬的url 可由模板渲染
    private String baseUrl;
    // cookie域名
    private String domain;
    // cookie
    private Map<String, String> cookie;
    // 占位符字符 比如www.steam/page/$ $->{1,2,3} $会用数字渲染出N个url [www.steam/page/1,www.steam/page/2,www.steam/page/3]
    private Map<String, List<String>> placeHoldMap;

    public Set<String> calcUrl() {
        Set<String> urls = new LinkedHashSet<>();
        
        if(Objects.isNull(placeHoldMap)){
            urls.add(baseUrl);
            return urls;
        }

        placeHoldMap.forEach((placeHolder, strings) -> strings.forEach(replaceParam -> {
            urls.add(baseUrl.replace(placeHolder, replaceParam));
        }));
        
        return urls;
    }

    public String getBaseUrl() {
        return baseUrl;
    }

    public String getDomain() {
        return domain;
    }

    public Map<String, String> getCookie() {
        return cookie;
    }

    public Map<String, List<String>> getPlaceHoldMap() {
        return placeHoldMap;
    }
}
