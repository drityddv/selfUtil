package com.xiaozhang.spider.logs.constant;

import com.xiaozhang.spider.logs.model.GlobalFightReport;
import com.xiaozhang.spider.logs.model.PhaseFightReport;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author : xiaozhang
 * @since : 2023/6/30 110:35
 */

public enum PoiHeadEnum {

    fightId("战斗序号", 10) {
        @Override
        public Object getCellValues(GlobalFightReport globalFightReport, PhaseFightReport phaseFightReport) {
            return globalFightReport.getFightId();
        }
    },
    phaseId("当前进度", 10) {
        @Override
        public Object getCellValues(GlobalFightReport globalFightReport, PhaseFightReport phaseFightReport) {
            return phaseFightReport.getPhaseString();
        }
    },
    maxPhaseId("最远进度", 10) {
        @Override
        public Object getCellValues(GlobalFightReport globalFightReport, PhaseFightReport phaseFightReport) {
            return globalFightReport.getPhaseId();
        }
    },
    hp("最终P血量", 12) {
        @Override
        public Object getCellValues(GlobalFightReport globalFightReport, PhaseFightReport phaseFightReport) {
            return globalFightReport.getHpRemain() + "%";
        }
    },
    realTime("现实时间", 12) {
        @Override
        public Object getCellValues(GlobalFightReport globalFightReport, PhaseFightReport phaseFightReport) {
            return globalFightReport.getRealTimeExcel();
        }
    },

    ;
    private String head;
    private int excelWidth;

    PoiHeadEnum(String head, int excelWidth) {
        this.head = head;
        this.excelWidth = excelWidth;
    }

    public Object getCellValues(GlobalFightReport globalFightReport, PhaseFightReport phaseFightReport) {
        return null;
    }

    public static List<String> getHeads() {
        return Arrays.stream(PoiHeadEnum.values()).map(poiHeadEnum -> poiHeadEnum.head).collect(Collectors.toList());
    }

    public int getExcelWidth() {
        return excelWidth * 256;
    }
}
