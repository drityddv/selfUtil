package xiaozhang.main.db;

import java.sql.Date;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.TimeUnit;

import org.apache.commons.lang3.RandomUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.SmartLifecycle;
import org.springframework.jdbc.core.JdbcTemplate;

import com.apifan.common.random.source.OtherSource;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2022/5/12 02:14
 */

@Slf4j
// @Component
public class DbService implements SmartLifecycle {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public void start() {
        clearTablesData();
        // muckTablesData();
    }

    private void muckTablesData() {
        List<String> jobList = Arrays.asList("SERVER", "QA", "CLIENT", "BOSS");
        List<Integer> deptNoList = Arrays.asList(1, 2, 3, 4, 5);

        // 员工数据
        int empSize = 500;
        String empSql = "INSERT INTO emp (e_name, job, mgr, hire_data, sal, comm, dept_no) VALUES(?,?,?,?,?,?,?)";

        List<Object[]> empParams = new ArrayList<>();
        for (int i = 0; i < empSize; i++) {

            Object[] param = new Object[7];
            param[0] = OtherSource.getInstance().randomChinese() + OtherSource.getInstance().randomChinese(1);
            param[1] = jobList.get(RandomUtils.nextInt(0, jobList.size()));
            param[2] = i % 1000;
            long dataTime = System.currentTimeMillis() - TimeUnit.DAYS.toMillis(RandomUtils.nextInt(60, 360));
            param[3] = new Date(dataTime);
            param[4] = RandomUtils.nextInt(5000, 10000);
            param[5] = RandomUtils.nextInt(500, 1000);
            param[6] = deptNoList.get(RandomUtils.nextInt(0, deptNoList.size()));
            empParams.add(param);

            if (empParams.size() >= 5000) {
                jdbcTemplate.batchUpdate(empSql, empParams);
                empParams.clear();
            }
        }
        if (empParams.size() > 0) {
            jdbcTemplate.batchUpdate(empSql, empParams);
        }

        // 部门数据
        String deptSql = "INSERT INTO dept (dept_no, dept_name, location) VALUES(?,?,?)";
        List<Object[]> deptParams = new ArrayList<>();
        for (Integer deptNo : deptNoList) {
            Object[] param = new Object[3];
            param[0] = deptNo;
            param[1] = "部门_" + deptNo;
            param[2] = "地点_" + deptNo;
            deptParams.add(param);
        }
        jdbcTemplate.batchUpdate(deptSql, deptParams);

    }

    private void clearTablesData() {
        // List<String> clearTables = new ArrayList<>();
        // List<Map<String, Object>> showTables = jdbcTemplate.queryForList("show tables");
        // showTables.forEach(s -> {
        // s.forEach((key, value) -> {
        // log.info("{} {}", key, value);
        // clearTables.add(String.valueOf(value));
        // });
        // });

        List<String> clearTables = Arrays.asList("guildcpsbiggroup");
        jdbcTemplate.execute("delete from globalinfo where type like '%CPS%'");
        for (String clearTable : clearTables) {
            jdbcTemplate.execute("delete from " + clearTable);
            jdbcTemplate.execute("alter table  " + clearTable + " AUTO_INCREMENT = 1");
        }
    }

    @Override
    public void stop() {

    }

    @Override
    public boolean isRunning() {
        return false;
    }

}
