package com.xiaozhang.lf.db;

import java.sql.*;
import java.util.*;
import java.util.concurrent.*;

import org.apache.commons.lang3.mutable.MutableInt;
import org.junit.Test;

import com.xiaozhang.common.CollectionUtils;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2023/7/27 15:38
 */
@Slf4j
public class LfClearDb {

    private ExecutorService executorService = Executors.newFixedThreadPool(12);
    private CountDownLatch countDownLatch;

    @Test
    public void clearModelMarket() throws Exception {
        //        List<Integer> serverIds = Arrays.asList(671, 914, 915);
        List<Integer> serverIds = Arrays.asList(671);
        List<String> skipTableList = Arrays.asList("server_info");
        List<String> requiredTableList =
                Arrays.asList("user_model_market", "user_common_market", "model_market_goods", "model_market_group");
        List<LfClearDbContext> clearContextList = generateClearContext(serverIds, skipTableList, requiredTableList);

        for (LfClearDbContext clearDbContext : clearContextList) {
            if (clearDbContext.getServerId() == 914 || clearDbContext.getServerId() == 915) {
                clearDbContext.setMysqlHost("jdbc:mysql://10.2.4.42:3306/lf");
            }
        }
        submitClearTask(clearContextList);
    }

    @Test
    public void clearServerActivity() throws Exception {
        List<Integer> serverIds = Arrays.asList(671);
        List<String> skipTableList = Arrays.asList("server_info");
        List<String> requiredTableList = Arrays.asList("server_activity_item");
        List<LfClearDbContext> clearContextList = generateClearContext(serverIds, skipTableList, requiredTableList);
        submitClearTask(clearContextList);
    }

    // 清理monopoly
    @Test
    public void clearMonopoly() throws Exception {
        List<Integer> serverIds = Arrays.asList(671);
        List<String> skipTableList = Arrays.asList("server_info");
        List<String> requiredTableList = new ArrayList<>(Arrays.asList("server_activity_item", "user_monopoly"));
        List<LfClearDbContext> clearContextList = generateClearContext(serverIds, skipTableList, requiredTableList);
        submitClearTask(clearContextList);
    }

    @Test
    // 击杀排行榜
    public void clearScoreRank() throws Exception {
        List<Integer> serverIds = Arrays.asList(669);
        List<String> skipTableList = Arrays.asList("server_info");
        List<String> requiredTableList = Arrays.asList("activity_item", "user_score_rank");

        List<LfClearDbContext> clearContextList = generateClearContext(serverIds, skipTableList, requiredTableList);
        submitClearTask(clearContextList);
    }

    @Test
    // 联盟bp
    public void clearAllianceBp() throws Exception {
        List<Integer> serverIds = Arrays.asList(669);
        List<String> skipTableList = Arrays.asList("server_info");
        List<String> requiredTableList = Arrays.asList("activity_item", "alliance_bp", "user_alliance_bp");

        List<LfClearDbContext> clearContextList = generateClearContext(serverIds, skipTableList, requiredTableList);
        submitClearTask(clearContextList);
    }

    @Test
    public void clearAllianceBoss() throws Exception {
        List<Integer> serverIds = Arrays.asList(668,670);
        List<String> skipTableList = Arrays.asList("server_info");
        List<String> requiredTableList = Arrays.asList("alliance_boss_round","alliance_boss_alliance_info","user_alliance_boss");

        List<LfClearDbContext> clearContextList = generateClearContext(serverIds, skipTableList, requiredTableList);
        submitClearTask(clearContextList);
    }

    // 清元旦活动组
    @Test
    public void clearFireworks() throws Exception {
        List<Integer> serverIds = Arrays.asList(668);
        List<String> skipTableList = Arrays.asList("server_info");
        List<String> requiredTableList = Arrays.asList("activity_item", "user_active_drop_record",
                "user_fireworks_wish", "fireworks_wish_pool", "user_score_rank");

        List<LfClearDbContext> clearContextList = generateClearContext(serverIds, skipTableList, requiredTableList);
        submitClearTask(clearContextList);
    }

    @Test
    public void clearAll() throws Exception {
        List<Integer> serverIds = Arrays.asList(671);
        List<String> skipTableList = Arrays.asList("server_info");
        List<LfClearDbContext> clearContextList = generateClearContext(serverIds, skipTableList, null);
        submitClearTask(clearContextList);
    }

    @Test
    public void clear903_904() throws Exception {
        List<Integer> serverIds = Arrays.asList(903, 904);
        List<String> skipTableList = Arrays.asList("server_info");

        List<LfClearDbContext> clearContextList = generateClearContext(serverIds, skipTableList, null);
        for (LfClearDbContext clearDbContext : clearContextList) {
            clearDbContext.setMysqlHost("jdbc:mysql://10.2.4.42:3306/lf");
        }
        submitClearTask(clearContextList);
    }

    private List<LfClearDbContext> generateClearContext(List<Integer> serverIdList, List<String> skipTableList,
                                                        List<String> requiredTableList) {
        List<LfClearDbContext> result = new ArrayList<>();
        for (Integer serverId : serverIdList) {
            LfClearDbContext clearContext = LfClearDbContext.of(serverId, skipTableList, requiredTableList);
            result.add(clearContext);
        }
        return result;
    }

    private void submitClearTask(List<LfClearDbContext> clearContexts) throws InterruptedException {
        if (CollectionUtils.isEmpty(clearContexts)) {
            return;
        }
        countDownLatch = new CountDownLatch(clearContexts.size());
        for (LfClearDbContext clearContext : clearContexts) {
            executorService.submit(() -> clear(clearContext));
        }
        log.info("等待任务执行完成...");
        countDownLatch.await();
        log.info("任务执行完成...");
    }

    public void clear(LfClearDbContext clearContext) {
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

            log.info("serverId:{} tables :{}", clearContext.getServerId(), tables);
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
                            (int) (finishCount.getValue() * 1.0d / tables.size() * 100), table);
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
