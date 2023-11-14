package com.xiaozhang.excel.export;

import org.apache.poi.ss.usermodel.ClientAnchor.AnchorType;
import org.apache.poi.xssf.usermodel.XSSFClientAnchor;

/**
 * @author : xiaozhang
 * @since : 2023/11/13 21:13
 */

public class XSSFClientAnchorJump {

    private XSSFClientAnchor originAnchor;

    private int dxOff = 0;
    private int colOff = 0;

    public static XSSFClientAnchorJump of(XSSFClientAnchor originAnchor, int dxOff, int colOff) {
        XSSFClientAnchorJump anchorJump = new XSSFClientAnchorJump();
        anchorJump.originAnchor = originAnchor;
        anchorJump.dxOff = dxOff;
        anchorJump.colOff = colOff;
        return anchorJump;
    }

    public XSSFClientAnchor jump() {
        XSSFClientAnchor newAnchor = new XSSFClientAnchor(originAnchor.getDx1(), originAnchor.getDy1(),
            originAnchor.getDx2(), originAnchor.getDy2(), originAnchor.getCol1(), originAnchor.getRow1(),
            originAnchor.getCol2(), originAnchor.getRow2());
        newAnchor.setAnchorType(AnchorType.MOVE_DONT_RESIZE);
//        originAnchor.setDx1(originAnchor.getDx1() + dxOff);
//        originAnchor.setDx2(originAnchor.getDx2() + dxOff);
        originAnchor.setCol1(originAnchor.getCol1() + colOff);
        originAnchor.setCol2(originAnchor.getCol2() + colOff);
        return newAnchor;
    }

}
