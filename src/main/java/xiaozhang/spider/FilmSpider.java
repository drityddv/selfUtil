package xiaozhang.spider;

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
        // "https://www.70meiju.com/%e9%a9%ac%e7%94%b7%e6%b3%a2%e6%9d%b0%e5%85%8b%e7%ac%ac%e4%ba%94%e5%ad%a3.html";
        // "http://www.mjf2020.com/jianjie/10898266.html";
        // "https://www.bilibili.com/";
        "https://www.70meiju.com/%E7%BB%9D%E5%91%BD%E5%BE%8B%E5%B8%88%E7%AC%AC%E5%9B%9B%E5%AD%A3.html";

    static {
        // System.setProperty("https.protocols", "TLSv1");
    }

    public static void main(String[] args) {
		String jmx1 = System.getProperty("com.sun.management.jmxremote");
		String jmx2 = System.getProperty("com.sun.management.jmxremote.port");
		String jmx3 = System.getProperty("com.sun.management.jmxremote.authenticate");
		String jmx4 = System.getProperty("com.sun.management.jmxremote.ssl");
		String jmx5 = System.getProperty("java.rmi.server.hostname");
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
