package com.xiaozhang.spider;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

import org.apache.commons.io.FileUtils;

import lombok.extern.slf4j.Slf4j;
import us.codecraft.webmagic.Page;
import us.codecraft.webmagic.Site;
import us.codecraft.webmagic.Spider;
import us.codecraft.webmagic.processor.PageProcessor;
import us.codecraft.webmagic.selector.Html;

/**
 * @author : xiaozhang
 * @since : 2022/6/9 22:50
 */

@Slf4j
public class FilmSpider implements PageProcessor {

    private static final String url =
        "https://www.bt-tt.com/html/9/27749.html";

    public static void main(String[] args) {
        Spider spider = Spider.create(new FilmSpider());
        spider.addUrl(url).thread(1).run();
    }

    @Override
    public void process(Page page) {
        Html html = page.getHtml();
        List<String> links = html.selectDocumentForList(new MeiJuFenSelector());
        List<String> stringList = links.stream().filter(s -> s.contains("S12")).collect(Collectors.toList());
        log.info("{}", stringList);
        try {
            FileUtils.writeLines(new File("result.txt"), stringList, false);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Site getSite() {
        return Site.me().setRetryTimes(3).setSleepTime(100);
    }
}
