package com.xiaozhang.spider.fflogs.model;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * @author : xiaozhang
 * @since : 2023/7/3 00:26
 */

@Data
@NoArgsConstructor
public class PlayerDamageReport {

    // 玩家名
    private String playerName;
    // 伤害 单位个位数
    private long damage;
    // gcd利用率
    private String active;
    // dps
    private String ad;
    // rd
    private String rd;

    public PlayerDamageReport(String playerName, long damage, String active, String ad, String rd) {
        this.playerName = playerName;
        this.damage = damage;
        this.active = active;
        this.ad = ad;
        this.rd = rd;
    }

    public String getExcelDamage() {
        double result = damage * 1.0d / 10000;
        BigDecimal bigDecimal = new BigDecimal(result);
        return bigDecimal.setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue() + "万";
    }

    public String getOtherInfo() {
        StringBuilder sb = new StringBuilder();
        sb.append("gcd:").append(active).append(" ");
        sb.append("ad:").append(ad).append(" ");
        sb.append("rd:").append(rd).append(" ");
        return sb.toString();
    }
}
