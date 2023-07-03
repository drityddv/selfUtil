package com.xiaozhang.spider.films;

import lombok.extern.slf4j.Slf4j;
import us.codecraft.webmagic.Page;
import us.codecraft.webmagic.Site;
import us.codecraft.webmagic.processor.PageProcessor;

/**
 * @author : xiaozhang
 * @since : 2022/6/9 22:50
 */

@Slf4j
public class FilmSpider implements PageProcessor {

    @Override
    public void process(Page page) {
    }

    @Override
    public Site getSite() {
        return Site.me().setRetryTimes(3).setSleepTime(100);
    }

}
