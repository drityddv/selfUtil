package xiaozhang.common;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;

/**
 * @author : xiaozhang
 * @since : 2022/8/31 11:12
 */

public class PoiUtils {

    public static void read(File file) {
        try (InputStream inp = new FileInputStream(file)) {
            Workbook wb = WorkbookFactory.create(inp);
            Sheet sheet = wb.getSheetAt(0);
            Row row = sheet.getRow(2);
            Cell cell = row.getCell(3);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
