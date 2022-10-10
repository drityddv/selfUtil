package com.xiaozhang.algorithm.leetcode;

import java.util.Arrays;

import org.junit.Test;

import com.xiaozhang.algorithm.leetcode.model.TreeNode;
import com.xiaozhang.algorithm.model.TreeSupport;
import com.xiaozhang.algorithm.model.XTreeNode;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2022/9/19 17:56
 */

@Slf4j
public class Solution {

    public int maxDepth(TreeNode root) {
        if (root == null) {
            return 0;
        }
        return 1 + Math.max(maxDepth(root.left), maxDepth(root.right));
    }

    @Test
    public void test() {
        XTreeNode<Integer> treeNode = TreeSupport.makeTree(Arrays.asList(3, 9, 20, null, null, 15, 7));
        TreeSupport.show(treeNode);
        TreeNode leetCodeTree = treeNode.toLeetCodeTree();
        Solution solution = new Solution();
        log.info("{}", solution.maxDepth(leetCodeTree));
    }
}
