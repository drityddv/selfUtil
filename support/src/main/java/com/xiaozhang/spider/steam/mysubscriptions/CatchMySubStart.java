package com.xiaozhang.spider.steam.mysubscriptions;

import java.io.File;
import java.net.URL;
import java.util.*;
import java.util.stream.Collectors;

import org.apache.commons.io.FileUtils;

import com.xiaozhang.spider.fflogs.constant.IniKeyEnum;
import com.xiaozhang.spider.param.SpiderParam;
import com.xiaozhang.spider.param.SpiderParam.SpiderParamBuilder;
import com.xiaozhang.spider.utils.SpiderUtil;
import com.xiaozhang.util.FileUtil;

import lombok.extern.slf4j.Slf4j;
import us.codecraft.webmagic.Spider;

/**
 * @author : xiaozhang
 * @since : 2023/6/29 12:18
 */
@Slf4j
public class CatchMySubStart {

    public static String startUrl =
        "https://steamcommunity.com/profiles/76561198057347652/myworkshopfiles/?appid=322330&browsefilter=mysubscriptions&p=$&numperpage=30";

    public static String webDriver;
    public static Map<String, String> iniConfig;
    public static Set<String> subIds = new HashSet<>();

    static {
        URL resource = CatchMySubStart.class.getClassLoader().getResource("config/webmagic/fflogs.ini");
        File iniFile = new File(resource.getFile());
        iniConfig = FileUtil.readFromIniFile(iniFile, IniKeyEnum.getIniKeys());
        // startUrl = iniConfig.get("startUrl");
        webDriver = iniConfig.get("webDriver");
        String selenuim_config = iniConfig.get("selenuim_config");

        System.setProperty("webdriver.chrome.driver", webDriver);
        System.setProperty("selenuim_config", selenuim_config);
    }

    public static void main(String[] args) throws Exception {
        Spider spider = Spider.create(new SteamMySubscriptionProcessor());

        SpiderParamBuilder paramBuilder = SpiderParam.builder();
        paramBuilder.baseUrl(startUrl);

        Map<String, List<String>> placeHolderMap = new HashMap<>();
        placeHolderMap.put("$", Arrays.asList("1", "2"));;
        paramBuilder.placeHoldMap(placeHolderMap);

        paramBuilder.domain("steamcommunity.com");

        String cookieString = FileUtils.readFileToString(new File(
            "/Users/xiaozhang/workspace/java/utils/support/src/main/java/com/xiaozhang/spider/steam/mysubscriptions/cooike.txt"));
        Map<String, String> cookieMap = SpiderUtil.parseCookie(cookieString);
        paramBuilder.cookie(cookieMap);

        SpiderUtil.initSpider(paramBuilder, spider);

        // spider.downloader(new SeleniumDownloader(Start.webDriver));
        spider.thread(1).run();

        List<String> modIdList =
            subIds.stream().sorted(Comparator.comparingLong(Long::parseLong)).collect(Collectors.toList());
        FileUtils.writeLines(new File("订阅mod.txt"), modIdList);

        List<String> serverLuaLines = new ArrayList<>();
        for (String subId : modIdList) {
            String luaLine = "ServerModSetup(\"" + subId + "\")";
            serverLuaLines.add(luaLine);
        }
        FileUtils.writeLines(new File("dedicated_server_mods_setup.lua"), serverLuaLines);

    }

}
