package com.xiaozhang.spider.logs.constant;

import us.codecraft.webmagic.selector.Selectable;

import java.util.Objects;

/**
 * @author : xiaozhang
 * @since : 2023/6/28 21:21
 */

public enum LogsXpathEnum {

    // logs总页面xpath
    global_fight_list("//*[@class=\"fight-grid-cell-container\"]", "logs总览全部战斗简要信息"),
    phase_id_text("//span[@class=\"fight-grid-cell-phase\"]/text()", "最远达到p几"),
    boss_remain_hp_text("//span[@class=\"fight-grid-cell-percent common\"]/text()", "boss剩余血量") {
        @Override
        public String getNodeValue(Selectable node) {
            String s = node.xpath(getXpath()).get();
            if (Objects.isNull(s)) {
                return node.xpath("//span[@class=\"fight-grid-cell-percent uncommon\"]/text()").get();
            }
            return s;
        }
    },
    fight_id_text("//span[@class=\"fight-grid-number\"]/text()", "战斗序号"),
    fight_real_time_text("//span[@class=\"fight-grid-time\"]/text()", "战斗现实时间"),

    // 战斗页面xpath
    damage_table("//*[@id=\"main-table-0\"]", "小队伤害table"),
    ;

    private String xpath;
    private String desc;

    public String getXpath() {
        return xpath;
    }

    public String getNodeValue(Selectable node) {
        return node.xpath(this.xpath).get();
    }

    LogsXpathEnum(String xpath, String desc) {
        this.xpath = xpath;
        this.desc = desc;
    }

}
