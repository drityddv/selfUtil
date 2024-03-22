package com.xiaozhang.spider.steam.mysubscriptions;

import java.util.regex.*;

import lombok.extern.slf4j.Slf4j;
import us.codecraft.webmagic.*;
import us.codecraft.webmagic.processor.PageProcessor;
import us.codecraft.webmagic.selector.*;

/**
 * 解析我的订阅 获取模组id
 * 
 * @author : xiaozhang
 * @since : 2023/6/29 12:16
 */

@Slf4j
public class SteamMySubscriptionProcessor implements PageProcessor {

    @Override
    public void process(Page page) {
        Html html = page.getHtml();
        // 总界面所有的战斗简要信息
        Selectable select = html.select(new ModHrefSelector());
        for (String nodeUrl : select.all()) {
            Pattern pattern = Pattern.compile("\\?id=(\\d+)");
            Matcher matcher = pattern.matcher(nodeUrl);
            matcher.find();
            String modId = matcher.group(1);
//            if (CatchMySubStart.subIds.add(modId)) {
//                log.info("解析订阅模组id:{} 模组数量:{}", modId, CatchMySubStart.subIds.size());
//            }
        }

        Selectable eachSubDiv = html.xpath("//div[@class='workshopItemSubscriptionDetails']");
        for (Selectable selectable : eachSubDiv.nodes()) {
            String modName = selectable.xpath("//div[@class='workshopItemTitle']/text()").get();
            String url = selectable.xpath("//a/@href").get();
            Pattern pattern = Pattern.compile("\\?id=(\\d+)");
            Matcher matcher = pattern.matcher(url);
            matcher.find();
            String modId = matcher.group(1);
            if(!CatchMySubStart.subIds.add(modId)){
                log.info("解析订阅模组:[{}] modId:[{}] 已存在 忽略", modName, modId);
            }
            log.info("解析订阅模组:[{}] modId:[{}] 模组数量:{}", modName, modId, CatchMySubStart.subIds.size());
        }
    }

    @Override
    public Site getSite() {
        return Site.me().setRetryTimes(Integer.MAX_VALUE).setSleepTime(10);
    }
}
