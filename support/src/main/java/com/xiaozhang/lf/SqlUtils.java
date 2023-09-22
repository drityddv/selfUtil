package com.xiaozhang.lf;

import java.sql.*;
import java.util.*;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicInteger;

import org.apache.commons.lang3.mutable.MutableInt;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2023/7/27 15:38
 */
@Slf4j
public class SqlUtils {

    private static final AtomicInteger record = new AtomicInteger(0);

    private static final Set<String> skipTables = new HashSet<>();

    static {
//        skipTables.add("battle_server_info");
//        skipTables.add("server_info");
//        skipTables.add("battle_server_world_return");
    }

    public static void main(String[] args) {
        ExecutorService executorService = Executors.newFixedThreadPool(10);
        // executorService.submit(() -> clear(668));
        // executorService.submit(() -> clear(670));

//        executorService.submit(() -> clear(669));
        executorService.submit(() -> clear(671));

    }

    public static void clear(int serverId) {
        record.addAndGet(1);
        // 数据库连接参数
        String url = null;
        url = "jdbc:mysql://10.1.2.23:3306/lf" + serverId;
        String username = "root";
        String password = "admin123";

        // JDBC连接对象
        Connection conn = null;

        try {
            // 加载数据库驱动程序
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 建立数据库连接
            conn = DriverManager.getConnection(url, username, password);

            // 创建执行 SQL 语句的 Statement 对象
            Statement statement = conn.createStatement();

            // 执行 SQL 查询
            String query = "show tables";
            ResultSet resultSet = statement.executeQuery(query);

            LinkedHashSet<String> tables = new LinkedHashSet<>();
            // 处理查询结果
            while (resultSet.next()) {
                // 根据列名获取数据
                String column1 = resultSet.getString(1);
                tables.add(column1);
            }
            resultSet.close();
            MutableInt finishCount = new MutableInt();
            for (String table : tables) {
                if (skipTables.contains(table)) {
                    continue;
                }
                try {
                    String sql = "truncate table " + table;
                    statement.execute(sql);
                    finishCount.add(1);
                    log.info("serverId :{} 进度{}% {} ", url, (int)(finishCount.getValue() * 1.0d / tables.size() * 100),
                        table);
                } catch (Exception e) {
                    log.error("error on {}", table);
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
            record.decrementAndGet();
            if (record.get() == 0) {
                System.exit(1);
            }
        }

    }

}
