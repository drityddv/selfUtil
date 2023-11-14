package com.xiaozhang.util;

import java.io.*;
import java.util.*;

import org.apache.commons.io.*;
import org.apache.poi.xssf.usermodel.*;
import org.junit.Test;

import com.xiaozhang.excel.export.XSSFClientAnchorJump;

/**
 * @author : xiaozhang
 * @since : 2023/11/13 20:32
 */

public class ExcelUtil {

    @Test
    public void exportDD() throws Exception {
        String excelUrl = "/Users/xiaozhang/Documents/im30/打车报销/2023_06-07 资料/张杰(小张).xlsx";
        String imageUrl = "/Users/xiaozhang/Documents/im30/打车报销/2023_06-07 资料/考勤截图";
        String carBillUrl = "/Users/xiaozhang/Documents/im30/打车报销/2023_06-07 资料/出租车发票拍照";
        createExcelWithImage(excelUrl, imageUrl, carBillUrl);
    }

    public void createExcelWithImage(String excelUrl, String workSignUrl, String ddBillUrl) throws Exception {

        FileUtils.deleteQuietly(new File(excelUrl));

        XSSFWorkbook workbook = new XSSFWorkbook();

        handleWorkSignPic(getImages(workSignUrl), workbook);
        handleDDbillPic(getImages(ddBillUrl), workbook);

        save(excelUrl, workbook);
    }

    private List<File> getImages(String fileFolder) {
        List<File> imageList = new ArrayList<>();
        imageList.addAll(FileUtils.listFiles(new File(fileFolder), new String[] {"jpg", "jpeg"}, true));
        imageList.sort(Comparator.comparing(File::getName));
        Collections.reverse(imageList);
        return imageList;
    }

 

    // 考勤截图
    private void handleWorkSignPic(List<File> imageList, XSSFWorkbook workbook) throws IOException {
        XSSFSheet sheet = workbook.createSheet("考勤截图");
        XSSFDrawing patriarch = sheet.createDrawingPatriarch();
        XSSFClientAnchor start = new XSSFClientAnchor(0, 0, 1024, 1024, 0, 0, 8, 52);
        XSSFClientAnchorJump clientAnchorJump = XSSFClientAnchorJump.of(start, 5, 8);
        for (File file : imageList) {
            // 插入图片
            patriarch.createPicture(clientAnchorJump.jump(),
                workbook.addPicture(IOUtils.toByteArray(new FileInputStream(file)), XSSFWorkbook.PICTURE_TYPE_JPEG));
        }
    }

    // 出租车发票拍照
    private void handleDDbillPic(List<File> imageList, XSSFWorkbook workbook) throws Exception {
        XSSFSheet sheet = workbook.createSheet("出租车发票截图");
        XSSFDrawing patriarch = sheet.createDrawingPatriarch();
        XSSFClientAnchor start = new XSSFClientAnchor(0, 0, 1024, 1024, 0, 0, 10, 52);
        XSSFClientAnchorJump clientAnchorJump = XSSFClientAnchorJump.of(start, 5, 10);
        for (File file : imageList) {
            // 插入图片
            patriarch.createPicture(clientAnchorJump.jump(),
                    workbook.addPicture(IOUtils.toByteArray(new FileInputStream(file)), XSSFWorkbook.PICTURE_TYPE_JPEG));
        }
    }

    private void save(String excelPath, XSSFWorkbook workbook) throws IOException {
        FileOutputStream fileOutputStream = new FileOutputStream(excelPath);
        workbook.write(fileOutputStream);
        fileOutputStream.close();
    }

}
