package com.xiaozhang.lf.db.clear;

import java.sql.*;
import java.util.*;
import java.util.concurrent.*;

import org.apache.commons.lang3.mutable.MutableInt;
import org.junit.Test;

import com.xiaozhang.common.CollectionUtils;
import com.xiaozhang.lf.db.clear.MySqlClearContext;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2023/7/27 15:38
 */
@Slf4j
public class LfClearDbUtil {

    private ExecutorService executorService = Executors.newFixedThreadPool(12);
    private CountDownLatch countDownLatch;

    static {
        // skipTables.add("server_info");
        //
        // requiredTables.add("activity_item");
        // requiredTables.add("alliance_bp");
        // requiredTables.add("user_alliance_bp");
    }

    @Test
    // 联盟bp
    public void clearAllianceBp() throws Exception {
        List<Integer> serverIds = Arrays.asList(668, 670);
        List<String> skipTableList = Arrays.asList("server_info");
        List<String> requiredTableList = Arrays.asList("activity_item", "alliance_bp", "user_alliance_bp");

        List<MySqlClearContext> clearContextList = generateClearContext(serverIds, skipTableList, requiredTableList);
        submitClearTask(clearContextList);
    }

    @Test
    // 联盟bp
    public void clearMiniGameCenter() throws Exception {
        List<Integer> serverIds = Arrays.asList(669);
        List<String> skipTableList = Arrays.asList("server_info");
        List<String> requiredTableList = Arrays.asList("activity_item", "user_minigame_center","user_zombie_attack","user_zombie_attack_fight");

        List<MySqlClearContext> clearContextList = generateClearContext(serverIds, skipTableList, requiredTableList);
        submitClearTask(clearContextList);
    }

    private List<MySqlClearContext> generateClearContext(List<Integer> serverIdList, List<String> skipTableList,
        List<String> requiredTableList) {
        List<MySqlClearContext> result = new ArrayList<>();
        for (Integer serverId : serverIdList) {
            MySqlClearContext clearContext = MySqlClearContext.of(serverId, skipTableList, requiredTableList);
            result.add(clearContext);
        }
        return result;
    }

    private void submitClearTask(List<MySqlClearContext> clearContexts) throws InterruptedException {
        if (CollectionUtils.isEmpty(clearContexts)) {
            return;
        }
        countDownLatch = new CountDownLatch(clearContexts.size());
        for (MySqlClearContext clearContext : clearContexts) {
            executorService.submit(() -> clear(clearContext));
        }
        log.info("等待任务执行完成...");
        countDownLatch.await();
        log.info("任务执行完成...");
    }

    public void clear(MySqlClearContext clearContext) {
        // JDBC连接对象
        Connection conn = null;
        try {
            // 加载数据库驱动程序
            Class.forName("com.mysql.cj.jdbc.Driver");
            // 建立数据库连接
            conn = DriverManager.getConnection(clearContext.getUrl(), clearContext.getUserName(),
                clearContext.getPassword());
            // 创建执行 SQL 语句的 Statement 对象
            Statement statement = conn.createStatement();
            // 执行 SQL 查询
            String query = "show tables";
            ResultSet resultSet = statement.executeQuery(query);

            LinkedHashSet<String> tables = new LinkedHashSet<>();
            if (CollectionUtils.isEmpty(clearContext.getRequiredTableList())) {
                // 处理查询结果
                while (resultSet.next()) {
                    // 根据列名获取数据
                    String tableColumn = resultSet.getString(1);
                    tables.add(tableColumn);
                }
            } else {
                tables.addAll(clearContext.getRequiredTableList());
            }
            resultSet.close();

            log.info("serverId :{} tables :{}", clearContext.getServerId(), tables);
            MutableInt finishCount = new MutableInt();
            for (String table : tables) {
                if (clearContext.getSkipTableList().contains(table)) {
                    continue;
                }
                try {
                    String sql = "truncate table " + table;
                    statement.execute(sql);
                    finishCount.add(1);
                    log.info("serverId:{} 进度{}% {} ", clearContext.getServerId(),
                        (int)(finishCount.getValue() * 1.0d / tables.size() * 100), table);
                } catch (Exception e) {
                    log.error("table:[{}] clear failed...", table);
                }

            }
            // 关闭结果集和声明

            statement.close();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            // 关闭数据库连接
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            this.countDownLatch.countDown();
        }

    }

}
