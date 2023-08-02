package com.xiaozhang.util;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.mutable.MutableInt;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.LinkedHashSet;

/**
 * @author : xiaozhang
 * @since : 2023/7/27 15:38
 */
@Slf4j
public class SqlUtils {

    public static void main(String[] args) {
        // 数据库连接参数
        String url = "jdbc:mysql://10.2.4.42:3306/lf668?";
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
                try {
                    String sql = "truncate table " + table;
                    statement.execute(sql);
                    finishCount.add(1);
                    log.info("进度{}% {} ", (int) (finishCount.getValue() * 1.0d / tables.size() * 100), table);
                } catch (Exception e) {
                    log.error("error on {}", table);
                }

            }
            // 关闭结果集和声明

            statement.close();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
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
        }
    }

}
