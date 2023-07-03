package com.xiaozhang.spider.logs.webmagic.processor;

import com.xiaozhang.spider.logs.LogsSpiderStart;
import com.xiaozhang.spider.logs.constant.LogsXpathEnum;
import com.xiaozhang.spider.logs.model.GlobalFightReport;
import com.xiaozhang.util.JsonUtils;
import lombok.extern.slf4j.Slf4j;
import us.codecraft.webmagic.Page;
import us.codecraft.webmagic.Site;
import us.codecraft.webmagic.processor.PageProcessor;
import us.codecraft.webmagic.selector.Html;
import us.codecraft.webmagic.selector.Selectable;

/**
 * logs上传后战斗总览页面分析
 * @author : xiaozhang
 * @since : 2023/6/29 12:16
 */

@Slf4j
public class GlobalPageProcessor implements PageProcessor {

    @Override
    public void process(Page page) {
        Html html = page.getHtml();
        // 总界面所有的战斗简要信息
        Selectable allFightDiv = html.xpath(LogsXpathEnum.global_fight_list.getXpath());
        for (Selectable node : allFightDiv.nodes()) {

            String phaseIdText = LogsXpathEnum.phase_id_text.getNodeValue(node);
            String bossHpRemainText = LogsXpathEnum.boss_remain_hp_text.getNodeValue(node);
            String fightIdText = LogsXpathEnum.fight_id_text.getNodeValue(node);
            String realTimeText = LogsXpathEnum.fight_real_time_text.getNodeValue(node);

            log.info("fightId:[{}] realTime:[{}] phaseId:[{}] hpRemain:[{}]", fightIdText, realTimeText, phaseIdText, bossHpRemainText);
            GlobalFightReport globalFightReport = new GlobalFightReport(fightIdText, phaseIdText, bossHpRemainText, realTimeText);

            log.info("单局战报解析完毕:{}", page.getUrl().get());
            LogsSpiderStart.addFightReport(globalFightReport.getFightId(), globalFightReport);
        }

        LogsSpiderStart.FIGHT_REPORTS.values().forEach(GlobalFightReport::log);
        log.info("分析logs总页面完毕... :[{}]", JsonUtils.object2String(LogsSpiderStart.FIGHT_REPORTS));
    }

    @Override
    public Site getSite() {
        return Site.me().setRetryTimes(Integer.MAX_VALUE).setSleepTime(10);
    }
}
