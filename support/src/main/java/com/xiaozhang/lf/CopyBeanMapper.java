package com.xiaozhang.lf;

/**
 * @author : xiaozhang
 * @since : 2023/9/6 17:10
 */

public class CopyBeanMapper extends LfUtil {

    private static int workSpaceId = 3;

    public static void main(String[] args) {
        if (args != null && args.length > 0) {
            CopyBeanMapper.workSpaceId = Integer.parseInt(args[0]);
        }
        copyLfMappers(workSpaceId);
    }

}
