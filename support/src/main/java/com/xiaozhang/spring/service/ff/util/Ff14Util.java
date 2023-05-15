package com.xiaozhang.spring.service.ff.util;

import java.io.File;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.tuple.Pair;
import org.springframework.core.io.ClassPathResource;
import org.springframework.util.StringUtils;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2022/5/6 15:25
 */

@Slf4j
public class Ff14Util {

    // 宏相关
    private static final String REG_PLACE_HOLDER = "\\bparam";
    private static final int HONG_BUFFER_TIME = 2;
    public static final String PATH = "config/ff14/";
    public static final String HONG_TXT = "hong.txt";
    public static final String SCRIPT_TEMPLATE = "scriptTemplate.txt";
    public static final String SCRIPT = "script.txt";
    public static final String JUE_LONG_SHI = "绝龙诗.xlsx";

    public static Pair<Long, Long> countHongTimeCost() throws Exception {
        URL resource = Thread.currentThread().getContextClassLoader().getResource(PATH + HONG_TXT);
        File file = new File(resource.getFile());
        String path = file.getAbsolutePath();
        log.info("读取配置目录:{}", path);
        List<String> readLines = FileUtils.readLines(file);

        boolean multiHong = false;
        long cost1 = 0L;
        long cost2 = 0L;
        for (String readLine : readLines) {
            if (!StringUtils.hasText(readLine)) {
                multiHong = true;
            }
            if (!readLine.contains("wait.")) {
                continue;
            }
            String pattern = "(\\D*)(\\d+)(.*)";
            Pattern r = Pattern.compile(pattern);
            Matcher m = r.matcher(readLine);
            if (!m.find()) {
                continue;
            }
            String group = m.group(2);
            if (multiHong) {
                cost2 += Long.parseLong(group);
            } else {
                cost1 += Long.parseLong(group);
            }
        }

        log.info("宏1耗时:{}", cost1);
        log.info("宏2耗时:{}", cost2);
        log.info("宏总共耗时:{}", cost1 + cost2);
        return Pair.of(cost1, cost2);
    }

    public static void generateScript() throws Exception {
        Pair<Long, Long> timeCost = countHongTimeCost();
        ClassPathResource classResource = new ClassPathResource(PATH + SCRIPT_TEMPLATE);
        List<String> scriptStrings = FileUtils.readLines(classResource.getFile());
        List<String> results = new ArrayList<>();

        int opIndex = 0;
        for (String scriptString : scriptStrings) {
            Pattern p = Pattern.compile(REG_PLACE_HOLDER);
            Matcher m = p.matcher(scriptString);

            if (!m.find()) {
                results.add(scriptString);
                continue;
            }

            String replaceAll = scriptString;
            if (opIndex == 0) {
                replaceAll =
                    m.replaceAll(String.valueOf(TimeUnit.SECONDS.toMillis(timeCost.getLeft() + HONG_BUFFER_TIME)));
            } else {
                replaceAll =
                    m.replaceAll(String.valueOf(TimeUnit.SECONDS.toMillis(timeCost.getRight() + HONG_BUFFER_TIME)));
            }

            opIndex++;
            results.add(replaceAll);

            if (opIndex > 0 && timeCost.getRight() <= 0) {
                break;
            }
            if (opIndex > 2) {
                break;
            }
        }

        FileUtils.writeLines(new File(SCRIPT), results, false);
    }

    /**
     * 计算机能cd
     *
     * @param minute 起始分钟数
     * @param second 起始秒数
     * @param cd 技能cd 单位s
     */
    public static void calcSkillCd(int minute, int second, int cd) {
        for (int i = 0; i < 1; i++) {
            long endTime = TimeUnit.MINUTES.toSeconds(minute) + second + cd;
            long preTime = TimeUnit.MINUTES.toSeconds(minute) + second - cd;
            log.info("当前 {}:{}", minute, second);
            log.info("前置转好 {}:{}", preTime / TimeUnit.MINUTES.toSeconds(1), preTime % TimeUnit.MINUTES.toSeconds(1));
            log.info("后置转好 {}:{}", endTime / TimeUnit.MINUTES.toSeconds(1), endTime % TimeUnit.MINUTES.toSeconds(1));
            log.info("");
            minute = (int)(endTime / TimeUnit.MINUTES.toSeconds(1));
            second = (int)(endTime % TimeUnit.MINUTES.toSeconds(1));
        }

    }

    public static void main(String[] args) throws Exception {
        calcSkillCd(5, 35, 120);
    }
}
