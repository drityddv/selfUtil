package com.xiaozhang.util;

import java.io.*;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2024/1/24 16:21
 */

@Slf4j
public class RuntimeUtil {

    public static boolean scpFile(String srcFolder, String desFolder, String desIp) {
        String scpCommand = generateShell(srcFolder, desFolder, desIp);
        boolean success = runCmd(scpCommand);
        if (!success) {
            log.warn("scp file failed command:{}", scpCommand);
        }
        return success;
    }

    public static String generateShell(String srcFolder, String desFolder, String desIp) {
        return "scp -r " + "\""+srcFolder + "\" " + "root@" + desIp + ":" + desFolder;
    }

    public static boolean runCmd(String command) {
        log.info("runCmd: {}", command);
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
            log.info("command finish result:[{}]", exitCode == 0 ? "success" : "failed");
        } catch (Exception e) {
            log.error("runCmd error", e);
            return false;
        }
        return true;
    }

}
