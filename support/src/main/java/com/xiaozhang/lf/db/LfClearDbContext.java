package com.xiaozhang.lf.db;

import java.util.*;

import com.xiaozhang.common.CollectionUtils;

import lombok.*;
import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2023/10/20 12:03
 */

@Slf4j
@Getter
public class LfClearDbContext {
    // mysql相关配置
    private String mysqlHost = "jdbc:mysql://10.1.2.23:3306/lf";
    private String userName = "root";
    private String password = "admin123";

    // 服务器id
    private int serverId;
    // 指定不清理的表 优先级最高
    private Set<String> skipTableList = new HashSet<>(Arrays.asList("server_info"));
    // 指定清理的表 其他表不清
    private Set<String> requiredTableList = new HashSet<>();

    public static LfClearDbContext of(int serverId, Collection<String> skipTableList,
                                      Collection<String> requiredTableList) {
        LfClearDbContext clearContext = new LfClearDbContext();
        clearContext.serverId = serverId;
        if (CollectionUtils.isNotEmpty(skipTableList)) {
            clearContext.skipTableList.addAll(skipTableList);
        }

        if (CollectionUtils.isNotEmpty(requiredTableList)) {
            clearContext.requiredTableList.addAll(requiredTableList);
        }

        return clearContext;
    }

    public String getUrl() {
        return this.mysqlHost + serverId;
    }

    public void setMysqlHost(String mysqlHost) {
        this.mysqlHost = mysqlHost;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setServerId(int serverId) {
        this.serverId = serverId;
    }

    public void setSkipTableList(Set<String> skipTableList) {
        this.skipTableList = skipTableList;
    }

    public void setRequiredTableList(Set<String> requiredTableList) {
        this.requiredTableList = requiredTableList;
    }
}
