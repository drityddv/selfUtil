package com.xiaozhang.zk;

import lombok.extern.slf4j.Slf4j;
import org.apache.zookeeper.*;
import org.apache.zookeeper.Watcher.Event.EventType;
import org.apache.zookeeper.data.Stat;

import java.io.IOException;
import java.util.List;

@Slf4j
public class ZookeeperWatcher implements Watcher {

    private static final String ZK_SERVER_PATH = "10.0.3.75:2181";
    private static final int SESSION_TIMEOUT = 5000;
    private ZooKeeper zooKeeper;

    public ZookeeperWatcher() throws IOException {
        this.zooKeeper = new ZooKeeper(ZK_SERVER_PATH, SESSION_TIMEOUT, this);
    }

    @Override
    public void process(WatchedEvent event) {
        EventType eventType = event.getType();
        log.info("Receive event:{} path:{} eventState:{}", eventType, event.getPath(),event.getState());
    }

    public void watchNode(String nodePath) throws KeeperException, InterruptedException {
        Stat stat = zooKeeper.exists(nodePath, false);
        if (stat != null) {
            List<String> children = zooKeeper.getChildren(nodePath, true);
            System.out.println("Initial children of node " + nodePath + ": " + children);
        } else {
            System.out.println("Node " + nodePath + " does not exist.");
        }
    }

    public static void main(String[] args) {
        try {
            ZookeeperWatcher watcher = new ZookeeperWatcher();
            String nodePath = "/SERVER_LF/GAME";
            watcher.watchNode(nodePath);

            // 保持程序运行，以便监听事件
            Thread.sleep(Long.MAX_VALUE);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
