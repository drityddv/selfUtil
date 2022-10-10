package com.xiaozhang.algorithm;

import java.util.ArrayList;
import java.util.List;

import com.xiaozhang.algorithm.model.TreeSupport;
import com.xiaozhang.algorithm.model.XTreeNode;
import com.xiaozhang.util.JsonUtils;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2022/9/15 15:07
 */

@Slf4j
public class AlgorithmUtil {

    public static void main(String[] args) {
        XTreeNode<Integer> headNode = TreeSupport.makeTree(15);
        TreeSupport.show(headNode);

        List<Object> result = new ArrayList<>();
        TreeSupport.bfsRecursion(headNode, result);
        log.info("递归 {}", JsonUtils.object2String(result));

        List<Object> result2 = new ArrayList<>();
        TreeSupport.bfs(headNode, result2);
        log.info("循环 {}", JsonUtils.object2String(result2));
    }

}
