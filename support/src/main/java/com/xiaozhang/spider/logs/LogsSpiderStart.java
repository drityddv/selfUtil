package com.xiaozhang.spider.logs;

import com.xiaozhang.spider.logs.constant.IniKeyEnum;
import com.xiaozhang.spider.logs.constant.PlayerEnum;
import com.xiaozhang.spider.logs.constant.PoiHeadEnum;
import com.xiaozhang.spider.logs.model.GlobalFightReport;
import com.xiaozhang.spider.logs.model.PhaseFightReport;
import com.xiaozhang.spider.logs.model.PlayerDamageReport;
import com.xiaozhang.spider.logs.webmagic.processor.DamagePageProcessor;
import com.xiaozhang.spider.logs.webmagic.processor.GlobalPageProcessor;
import com.xiaozhang.util.FileUtil;
import com.xiaozhang.util.JsonUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import us.codecraft.webmagic.Spider;
import us.codecraft.webmagic.downloader.selenium.SeleniumDownloader;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;

/**
 * @author : xiaozhang
 * @since : 2023/6/29 12:18
 */
@Slf4j
public class LogsSpiderStart {

    public static String startUrl;
    public static String webDriver;
    public static Map<String, String> iniConfig;
    // 所有的战斗信息
    public static final Map<Integer, GlobalFightReport> FIGHT_REPORTS = new ConcurrentHashMap<>();

    public static CountDownLatch countDownLatch;

    static {
        URL resource = LogsSpiderStart.class.getClassLoader().getResource("config/webmagic/fflogs.ini");
        File iniFile = new File(resource.getFile());
        iniConfig = FileUtil.readFromIniFile(iniFile, IniKeyEnum.getIniKeys());
        startUrl = iniConfig.get("startUrl");
        webDriver = iniConfig.get("webDriver");
        String selenuim_config = iniConfig.get("selenuim_config");

        System.setProperty("webdriver.chrome.driver", webDriver);
        System.setProperty("selenuim_config", selenuim_config);
    }

    public static void main(String[] args) throws Exception {
        File file = new File("report.txt");
        String json = FileUtils.readFileToString(file);
        boolean useCache = Boolean.parseBoolean(iniConfig.getOrDefault(IniKeyEnum.use_cache_html.name(), "false"));
        if (StringUtils.isEmpty(json) || !useCache) {
            extractFightUrls();
            analyzeDamageReport();
            json = JsonUtils.object2String(FIGHT_REPORTS.values());
            log.info("战斗报告数据:{}", json);
            FileUtils.writeLines(new File("report.txt"), Collections.singletonList(json));
        }

        List<GlobalFightReport> memory = JsonUtils.string2Collection(json, ArrayList.class, GlobalFightReport.class);
        writeExcel(memory);

    }

    private static void writeExcel(List<GlobalFightReport> globalFightReports) throws Exception {
        log.info("即将写入excel...");
        File file = new File("logs统计.xlsx");
        if (file.exists()) {
            FileUtils.forceDelete(file);
        }

        BufferedOutputStream outputStream = new BufferedOutputStream(new FileOutputStream("logs统计.xlsx"));
        XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFCellStyle styleMain = workbook.createCellStyle();
        styleMain.setAlignment(HorizontalAlignment.CENTER);
        styleMain.setVerticalAlignment(VerticalAlignment.CENTER);

        globalFightReports.sort(Comparator.comparingInt(globalFightReport1 -> -globalFightReport1.getIntPhase()));

        for (GlobalFightReport globalFightReport : globalFightReports) {
            for (PhaseFightReport phaseFightReport : globalFightReport.getSortedPhaseFightReports()) {
                String phaseString = phaseFightReport.getPhaseString();
                XSSFSheet currentSheet = workbook.getSheet(phaseString);
                List<String> fightHeads = PoiHeadEnum.getHeads();
                List<String> playerHeadWithOther = PlayerEnum.getPlayerHeadWithOther();
                if (currentSheet == null) {
                    currentSheet = workbook.createSheet(phaseString);
                    int columnIndex = 0;
                    for (String fightHead : fightHeads) {
                        XSSFRow headRow = currentSheet.getRow(0);
                        if (headRow == null) {
                            headRow = currentSheet.createRow(0);
                        }
                        XSSFCell cell = headRow.createCell(columnIndex++);
                        cell.setCellValue(fightHead);
                        cell.setCellStyle(styleMain);
                    }
                    boolean otherColumn = false;
                    for (String playerName : playerHeadWithOther) {
                        XSSFRow headRow = currentSheet.getRow(0);
                        if (headRow == null) {
                            headRow = currentSheet.createRow(0);
                        }
                        XSSFCell cell = headRow.createCell(columnIndex);
                        int width = otherColumn ? 32 : 16;
                        currentSheet.setColumnWidth(columnIndex, width * 256);
                        cell.setCellValue(playerName);
                        cell.setCellStyle(styleMain);
                        columnIndex++;
                        otherColumn = !otherColumn;
                    }

                }

                currentSheet.setDefaultColumnWidth(20);
                int columnIndex = 0;

                int rowIndex = currentSheet.getLastRowNum() + 1;
                for (PoiHeadEnum poiHeadEnum : PoiHeadEnum.values()) {
                    XSSFRow row = getOrCreateRow(currentSheet, rowIndex);
                    XSSFCell headCell = row.createCell(columnIndex);
                    currentSheet.setColumnWidth(columnIndex, poiHeadEnum.getExcelWidth());
                    headCell.setCellValue(poiHeadEnum.getCellValues(globalFightReport, phaseFightReport).toString());
                    headCell.setCellStyle(styleMain);
                    columnIndex++;
                }

                List<String> playerHeads = PlayerEnum.getPlayerHeads();
                for (int i = 0; i < playerHeads.size(); i++) {
                    String playerName = playerHeads.get(i);
                    PlayerDamageReport playerDamageReport = phaseFightReport.getPlayerReportByName(playerName);
                    if (playerDamageReport == null) {
                        columnIndex += 2;
                        continue;
                    }
                    XSSFRow row = getOrCreateRow(currentSheet, rowIndex);
                    XSSFCell playerCell = row.createCell(columnIndex);
                    playerCell.setCellValue(playerDamageReport.getExcelDamage());
                    playerCell.setCellStyle(styleMain);
                    columnIndex++;

                    XSSFCell playerOtherCell = row.createCell(columnIndex);
                    playerOtherCell.setCellValue(playerDamageReport.getOtherInfo());
                    playerOtherCell.setCellStyle(styleMain);
                    columnIndex++;
                }
            }

        }

        // 执行写入操作
        workbook.write(outputStream);
        workbook.close();
        outputStream.flush();
        outputStream.close();
    }

    private static XSSFRow getOrCreateRow(XSSFSheet currentSheet, int rowIndex) {
        XSSFRow row = currentSheet.getRow(rowIndex);
        if (row == null) {
            row = currentSheet.createRow(rowIndex);
        }
        return row;
    }

    private static void analyzeDamageReport() {
        List<String> fightUrls = FIGHT_REPORTS.values().stream().flatMap(globalFightReport -> globalFightReport.getFightUrls().stream())
                .collect(Collectors.toList());
        int threadNum = Integer.parseInt(iniConfig.getOrDefault(IniKeyEnum.threadNum.name(), "1"));
        ExecutorService executorService = Executors.newFixedThreadPool(threadNum);
        countDownLatch = new CountDownLatch(fightUrls.size());
        log.info("需要解析的战斗数据条数:{}", fightUrls.size());
        for (String fightUrl : fightUrls) {
            executorService.submit(() -> {
                Spider spider = Spider.create(new DamagePageProcessor());
                spider.addUrl(fightUrl);
                spider.downloader(new SeleniumDownloader(LogsSpiderStart.webDriver));
                spider.thread(threadNum).run();
            });
        }
        try {
            countDownLatch.await();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            executorService.shutdown();
        }

    }

    public static void extractFightUrls() {
        Spider spider = Spider.create(new GlobalPageProcessor());
        spider.addUrl(LogsSpiderStart.startUrl);
        spider.downloader(new SeleniumDownloader(LogsSpiderStart.webDriver));
        spider.thread(1).run();
    }

    public static void addPhaseReport(int fightId, int phaseId, PhaseFightReport phaseFightReport) {
        GlobalFightReport globalFightReport = FIGHT_REPORTS.get(fightId);
        globalFightReport.addPhaseReport(phaseId, phaseFightReport);
    }

    public static void addFightReport(int fightId, GlobalFightReport globalFightReport) {
        if (globalFightReport.getFightUrls().isEmpty()) {
            return;
        }
        FIGHT_REPORTS.put(fightId, globalFightReport);
    }
}
