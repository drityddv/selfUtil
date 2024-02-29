package com.xiaozhang.util;

import java.io.*;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2024/1/24 16:21
 */

@Slf4j
public class RuntimeUtil {

    public static boolean runCmd(String command) {
        log.info("runCmd:{}", command);
        // 启动进程并执行命令
        Process process = null;
        try {
            process = Runtime.getRuntime().exec(command);
            // 读取进程的输出流
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;

            // 输出命令执行结果
            while ((line = reader.readLine()) != null) {
                log.info("cmd exec print:{}", line);
            }

            // 等待命令执行完成
            int exitCode = process.waitFor();
            log.info("Command exited with code:{}", exitCode);
        } catch (Exception e) {
            log.error("runCmd error", e);
            return false;
        }
        return true;
    }
    
    public static void main(String[] args){
        runCmd("scp /Users/xiaozhang/Downloads/cache/1706089502804/arena_team_stage.xml root@10.1.2.6:/root/workspace/lf/svn");
//        runCmd("scp /Users/xiaozhang/Downloads/cache/1706089502804/*.xml root@10.1.2.6:/root/workspace/lf/svn");
    }

}
