package com.xiaozhang.spider.logs.webmagic.processor;

import com.xiaozhang.spider.logs.LogsSpiderStart;
import com.xiaozhang.spider.logs.constant.LogsXpathEnum;
import com.xiaozhang.spider.logs.constant.PlayerEnum;
import com.xiaozhang.spider.logs.model.PhaseFightReport;
import com.xiaozhang.spider.logs.model.PlayerDamageReport;
import lombok.extern.slf4j.Slf4j;
import us.codecraft.webmagic.Page;
import us.codecraft.webmagic.Site;
import us.codecraft.webmagic.processor.PageProcessor;
import us.codecraft.webmagic.selector.Html;
import us.codecraft.webmagic.selector.Selectable;

import java.util.ArrayList;
import java.util.List;

/**
 * 输出页面分析
 * @author : xiaozhang
 * @since : 2023/6/29 12:16
 */
@Slf4j
public class DamagePageProcessor implements PageProcessor {

    @Override
    public void process(Page page) {

        try {
            Html html = page.getHtml();
            // 总界面所有的战斗简要信息
            Selectable damageTable = html.xpath(LogsXpathEnum.damage_table.getXpath());
            List<Selectable> nodes = damageTable.nodes();
            Selectable tableNode = nodes.get(0);
            // 玩家数据table的body
            Selectable fightLineNodes = tableNode.xpath("//*[@id=\"main-table-0\"]/tbody");
            // 每行玩家战斗数据,logs这里用了两个css 全部拿一遍
            List<Selectable> playerDamageNodes = new ArrayList<>();
            playerDamageNodes.addAll(fightLineNodes.xpath("//tr[@class=\"even\"]").nodes());
            playerDamageNodes.addAll(fightLineNodes.xpath("//tr[@class=\"odd\"]").nodes());

            List<PlayerDamageReport> playerDamageReports = new ArrayList<>();
            for (Selectable playerDamageNode : playerDamageNodes) {
                String nameString = playerDamageNode.xpath("//a/text()").get().replaceAll(" ", "");
                // 伤害 单位百万或者千
                String damageString = playerDamageNode.xpath("//span[@class=report-amount-total]/text()").get();
                // gcd利用率 75.30%
                String activePercentString = playerDamageNode.xpath("//td[@class=\"num tooltip main-table-active\"]/text()").get();
                // rd 
                String adString = playerDamageNode.xpath("//td[@class=\"main-table-number primary main-per-second-amount\"]/text()").get()
                        .replaceAll(",", "");
                // ad
                String rdString = playerDamageNode.xpath("//td[@class=\"main-table-number tooltip rdps main-per-second-amount\"]/text()").get()
                        .replaceAll(",", "");

                String damageText = damageString.replaceAll("百万", "").replaceAll("千", "");
                long damage = (long) (damageString.contains("百万") ?
                        Double.parseDouble(damageText) * 100 * 10000 :
                        Double.parseDouble(damageText) * 1000);
                PlayerDamageReport playerDamageReport = new PlayerDamageReport(nameString, damage, activePercentString, adString, rdString);
                if (nameString.equals(PlayerEnum.xiao_zhang.getPlayerName())) {
                    log.info("{} {}", playerDamageReport.getDamage(), page.getUrl().get());
                    log.info("done");
                }
                playerDamageReports.add(playerDamageReport);
            }

            // https://cn.fflogs.com/reports/rNYXGJd3kQwfFvjx#fight=22&type=damage-done&phase=1
            String url = page.getUrl().get();
            String substring = url.substring(url.indexOf("#")).replaceAll("#", "");
            // fight=22&type=damage-done&phase=1
            int fightId = 0;
            int phaseId = 0;
            String[] strings = substring.split("&");
            for (String string : strings) {
                if (string.contains("fight")) {
                    fightId = Integer.parseInt(string.replaceAll("fight=", ""));
                }
                if (string.contains("phase")) {
                    phaseId = Integer.parseInt(string.replaceAll("phase=", ""));
                }
            }

            PhaseFightReport phaseFightReport = new PhaseFightReport(fightId, phaseId, playerDamageReports);
            LogsSpiderStart.addPhaseReport(fightId, phaseId, phaseFightReport);
            //        log.info("分析单p战斗报告完毕 [战斗序列:{}] [p:{}]", fightId, phaseId);
        } catch (Exception e) {
            log.error("处理页面出错 :{}", page.getUrl().get());
        } finally {
            LogsSpiderStart.countDownLatch.countDown();
        }
    }

    @Override
    public Site getSite() {
        return Site.me().setRetryTimes(Integer.MAX_VALUE).setSleepTime(10);
    }
}
