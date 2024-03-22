package com.xiaozhang.spider.fflogs.constant;

import java.util.Arrays;

/**
 * @author : xiaozhang
 * @since : 2023/7/3 11:02
 */

public enum PhaseEnum {
    P1(1, 20d),
    P2(2, 20d),
    P3(3, 20d),
    P4(4, 40d),
    P5(5, 20d),
    P6(6, 20d),
    ;

    private int phaseId;
    private double discardHp;

    PhaseEnum(int phaseId, double discardHp) {
        this.phaseId = phaseId;
        this.discardHp = discardHp;
    }

    public int getPhaseId() {
        return phaseId;
    }

    public double getDiscardHp() {
        return discardHp;
    }

    public static PhaseEnum getByPhaseId(int phaseId) {
        return Arrays.stream(PhaseEnum.values()).filter(phaseEnum -> phaseEnum.phaseId == phaseId).findAny().orElse(null);
    }

}
