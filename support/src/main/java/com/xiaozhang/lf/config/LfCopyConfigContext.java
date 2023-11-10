package com.xiaozhang.lf.config;

import java.util.*;

import org.apache.commons.lang3.StringUtils;

import com.xiaozhang.common.CollectionUtils;

import lombok.Getter;

/**
 * @author : xiaozhang
 * @since : 2023/10/24 14:56
 */

@Getter
public class LfCopyConfigContext {
    // svn地址
    private static final String svnPath = "/Users/xiaozhang/workspace/im30/lf2/cehua/resource_t/";

    // 服务器id
    private int serverId;
    // 没有写分支名 就copy主干配置
    private String branchName = "";
    // 不需要copy的配置
    private Set<String> skipFiles = new HashSet<>();
    // 需要特定copy的配置
    private Set<String> requiredFiles = new HashSet<>();

    public static LfCopyConfigContext of(int serverId, String branchName, Collection<String> skipFiles,
        Collection<String> requiredFiles) {
        LfCopyConfigContext context = new LfCopyConfigContext();
        context.serverId = serverId;
        if (StringUtils.isNoneBlank(branchName)) {
            context.branchName = branchName;
        }
        if (CollectionUtils.isNotEmpty(skipFiles)) {
            context.skipFiles.addAll(skipFiles);
        }
        if (CollectionUtils.isNotEmpty(requiredFiles)) {
            context.requiredFiles.addAll(requiredFiles);
        }
        return context;
    }

    public String calcSvnPath() {
        if (StringUtils.isNotEmpty(branchName)) {
            return svnPath + branchName + "/";
        }
        return svnPath;
    }

}
