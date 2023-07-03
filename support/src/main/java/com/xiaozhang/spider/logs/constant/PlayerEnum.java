package com.xiaozhang.spider.logs.constant;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author : xiaozhang
 * @since : 2023/7/2 17:54
 */

public enum PlayerEnum {

    afa("悠哉悠哉", "mt"),
    zi_yuan("三日月紫苑", "st"),
    xiao_zhang("小张烤秋刀鱼", "h1"),
    s_lao_shi("柳成荫", "h2"),
    k_zone("Kianaz", "d1"),
    long_tou("秋亦瞒秋", "d2"),
    momo("Momo丶", "d3"),
    x("爱克斯", "d4"),
    ;

    PlayerEnum(String playerName, String position) {
        this.playerName = playerName;
        this.position = position;
    }

    private String playerName;
    private String position;

    public String getPlayerName() {
        return playerName;
    }

    public String getPosition() {
        return position;
    }

    public static List<String> getPlayerHeadWithOther() {
        List<String> heads = new ArrayList<>();
        for (PlayerEnum playerEnum : PlayerEnum.values()) {
            heads.add(playerEnum.getPlayerName());
            heads.add(playerEnum.getPlayerName() + "の补充");
        }
        return heads;
    }

    public static List<String> getPlayerHeads() {
        return Arrays.stream(PlayerEnum.values()).map(PlayerEnum::getPlayerName).collect(Collectors.toList());
    }
}
