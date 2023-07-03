package com.xiaozhang.spider.logs.model;

import com.xiaozhang.spider.logs.constant.PlayerEnum;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.ArrayList;
import java.util.List;

/**
 * @author : xiaozhang
 * @since : 2023/7/3 00:21
 */

@Data
@Slf4j
@NoArgsConstructor
public class PhaseFightReport {

    // 战斗id
    private int fightId;
    // 分pid
    private int phaseId;
    // 玩家这p战斗信息
    private List<PlayerDamageReport> playerDamageReportList;

    public PhaseFightReport(int fightId, int phaseId, List<PlayerDamageReport> playerDamageReportList) {
        this.fightId = fightId;
        this.phaseId = phaseId;
        this.playerDamageReportList = playerDamageReportList;
    }

    public String getPhaseString() {
        return "P" + phaseId;
    }

    public List<PlayerDamageReport> getDamageReportsByTeam() {
        List<PlayerDamageReport> result = new ArrayList<>();
        for (PlayerEnum playerEnum : PlayerEnum.values()) {
            String playerName = playerEnum.getPlayerName();
            PlayerDamageReport targetPlayerReport = playerDamageReportList.stream()
                    .filter(playerDamageReport -> playerDamageReport.getPlayerName().equals(playerName)).findFirst().orElse(null);
            if (targetPlayerReport != null) {
                result.add(targetPlayerReport);
            }
        }
        return result;
    }

    public PlayerDamageReport getPlayerReportByName(String playerName) {
        return playerDamageReportList.stream()
                .filter(playerDamageReport -> playerDamageReport.getPlayerName().equals(playerName)).findFirst().orElse(null);
    }

}
