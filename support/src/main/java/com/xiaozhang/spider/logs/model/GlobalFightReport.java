package com.xiaozhang.spider.logs.model;

import com.xiaozhang.spider.logs.LogsSpiderStart;
import com.xiaozhang.spider.logs.constant.PhaseEnum;
import com.xiaozhang.util.JsonUtils;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

/**
 * @author : xiaozhang
 * @since : 2023/6/28 11:37
 */

@Data
@Slf4j
@NoArgsConstructor
public class GlobalFightReport {

    // 对应logs的每场战斗序号[1,2,3,4]
    private int fightId;
    // 最远达到p几 [p1,p2,p3,p4,p5,p6]
    private String phaseId;
    // boss剩余血量百分比
    private String hpRemain;
    // 现实时间
    private String realTime;
    // 所有战斗url
    private List<String> fightUrls;
    // 每p的战斗报告
    private Map<Integer, PhaseFightReport> phaseFightReports = new ConcurrentHashMap<>();

    public GlobalFightReport(String fightId, String phaseId, String hpRemain, String realTime) {
        this.fightId = Integer.parseInt(fightId);
        this.phaseId = phaseId;
        this.hpRemain = hpRemain;
        this.realTime = realTime;
        this.fightUrls = getFightUrls();
    }

    // 拼凑每p伤害详情url
    public List<String> getFightUrls() {
        LinkedHashSet<String> urls = new LinkedHashSet<>();
        // p1灭的就不看了
        if (this.getIntPhase() <= PhaseEnum.P1.getPhaseId()) {
            return Collections.emptyList();
        }

        // 从灭的那一p往前开始 每p都记录,如果这p血量剩余低于21%也算入其中 https://cn.fflogs.com/reports/rp398ZqPt4NJYDCm#fight=2&type=damage-done&phase=1
        for (int phaseIndex = 1; phaseIndex <= getIntPhase(); phaseIndex++) {
            // 最远p boss血量不到20%就当机制处理失误不管了 p4除外
            PhaseEnum phaseEnum = PhaseEnum.getByPhaseId(phaseIndex);
            if (phaseIndex == getIntPhase() && getHpRemain() > phaseEnum.getDiscardHp()) {
                continue;
            }

            StringBuilder sb = new StringBuilder();
            sb.append(LogsSpiderStart.startUrl);
            sb.append("#");
            sb.append("fight=").append(this.fightId);
            sb.append("&type=damage-done");
            sb.append("&phase=").append(phaseIndex);
            String url = sb.toString();
            urls.add(url);
        }

        return new ArrayList<>(urls);
    }

    public int getIntPhase() {
        String phaseString = this.phaseId;
        return Integer.parseInt(phaseString.replaceAll("P", ""));
    }

    public List<PhaseFightReport> getSortedPhaseFightReports() {
        return phaseFightReports.values().stream().sorted(Comparator.comparingInt(PhaseFightReport::getPhaseId)).collect(Collectors.toList());
    }

    public void log() {
        log.info("{}", JsonUtils.object2String(this));
    }

    public double getHpRemain() {
        return Double.parseDouble(this.hpRemain.replaceAll("%", ""));
    }

    public void addPhaseReport(int phaseId, PhaseFightReport phaseFightReport) {
        phaseFightReports.put(phaseId, phaseFightReport);
        log.info("战斗序列:{} p{} 分析完毕,数据:{}", this.fightId, phaseId, JsonUtils.object2String(phaseFightReport));
    }

    public String getRealTimeExcel() {
        boolean plusHalfDayHours = realTime.contains("晚上");
        String timeString = realTime.replaceAll("晚上", "").replaceAll(" ", "");
        String[] split = timeString.split(":");
        int hour = Integer.parseInt(split[0]) + (plusHalfDayHours ? 12 : 0);
        return hour + ":" + split[1];
    }
}
