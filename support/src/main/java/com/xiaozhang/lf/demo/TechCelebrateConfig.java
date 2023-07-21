package com.xiaozhang.lf.demo;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections.CollectionUtils;

import java.util.List;
import java.util.Set;

/**
 * @author : xiaozhang
 * @since : 2023/7/21 11:02
 */
@Slf4j
@XmlConfig
public class TechCelebrateConfig extends AbstractConfig {

    /**
     * 主键id
     */
    @ConfigId
    private String id;

    /**
     * 第x天
     */
    private int day;

    /**
     * 奖励id
     */
    @ForeignId(RewardConfig.class)
    private List<String> rewardIds;

    /**
     * 需要充值的礼包id
     */
    private Set<Integer> requiredGiftIds;

    public TechCelebrateConfig() {
    }

    @Override
    public void selfParse() {
    }

    @Override
    public boolean selfCheck() {
        if (day <= 0) {
            log.error("科技节天数不正确 {}", day);
            return false;
        }

        if (CollectionUtils.isEmpty(rewardIds)) {
            log.error("科技节奖励为空!");
            return false;
        }
        return true;
    }
}
