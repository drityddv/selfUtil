package spider;

import us.codecraft.webmagic.Page;
import us.codecraft.webmagic.Site;
import us.codecraft.webmagic.Spider;
import us.codecraft.webmagic.processor.PageProcessor;

/**
 * @author : xiaozhang
 * @since  : 2022/6/9 22:50
 */

public class FilmSpider implements PageProcessor {

	public static void main(String[] args){
		Spider.create(new FilmSpider()).addUrl("https://github.com/code4craft").thread(5).run();
	}

	@Override
	public void process(Page page) {

	}

	@Override
	public Site getSite() {
		return Site.me().setRetryTimes(3).setSleepTime(100);
	}
}
