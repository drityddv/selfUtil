package com.xiaozhang.games.dontstrave;

import java.io.File;
import java.util.*;

import org.apache.commons.io.FileUtils;

import com.xiaozhang.util.*;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2024/3/25 21:13
 */

@Slf4j
public class UploadGameConfig2Server {

    // 服务器 ip
    public static final String linux_server_ip = "10.1.2.84";
    // 服务器 游戏数据文件夹
    public static final String linux_game_data_path =
        "/usr/local/zhang/software/games/dontstarve/mount/DoNotStarveTogether/Cluster_1";
    // 本地mod文件夹
    public static final String local_mods_path =
        "/Users/xiaozhang/Library/Application Support/Steam/steamapps/common/Don't Starve Together/dontstarve_steam.app/Contents/mods";
    // 地上洞穴是两个世界
    public static final List<String> worldNames = Arrays.asList("Master", "Caves");
    // 世界配置文件
    public static final List<String> worldConfigFiles = Arrays.asList("modoverrides.lua", "leveldataoverride.lua");

    // ssh root@10.1.2.84 'cd /usr/local/zhang/software/games/test ;bash /usr/local/zhang/software/games/test/backup.sh'

    public static void main(String[] args) throws Exception {
        List<String> scpCommand = new ArrayList<>();

        String backUpPath = linux_game_data_path.replaceAll("Cluster_1", "");
        String backTimeString = TimeUtil.format(System.currentTimeMillis());
        String backUpCmd = "ssh" + " " + "root@" + linux_server_ip + " " + "'cd " + backUpPath + "; "
            + "tar -czvf back_up_" + backTimeString.replaceAll(" ", "_").replaceAll(":", "-") + ".tar.gz Cluster_1/'";
        scpCommand.add(backUpCmd);

        // 先上传mod文件
        String scpModCommand = RuntimeUtil.generateShell(local_mods_path, linux_game_data_path, linux_server_ip);
        scpCommand.add(scpModCommand);

        // Arrays.asList("Master", "Caves");
        for (String worldName : worldNames) {
            File worldFile = FileUtil.getResourceFile("dontstarve/Cluster_1/" + worldName);
            for (String configFile : worldConfigFiles) {
                String worldConfigFile = worldFile.getAbsolutePath() + "/" + configFile;
                String remotePath = linux_game_data_path + "/" + worldName;
                String generateShell = RuntimeUtil.generateShell(worldConfigFile, remotePath, linux_server_ip);
                scpCommand.add(generateShell);
            }
        }

        File shell = new File("runtime/donotstarve_server_update.sh");
        FileUtils.writeLines(shell, scpCommand);

    }
}
