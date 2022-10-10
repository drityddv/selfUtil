package com.xiaozhang.main.sb;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2022/5/20 16:28
 */

@Slf4j
@Controller
public class TestController {

    @RequestMapping("/test1")
	@ResponseBody
    public String test(@RequestParam("param1") String param1) {
        log.info("param {}", param1);
        return param1;
    }

}
