package com.xiaozhang.algorithm.model;

import java.util.LinkedList;
import java.util.List;
import java.util.Stack;

import com.xiaozhang.common.CollectionUtils;
import com.xiaozhang.util.RandomUtils;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2022/9/15 16:56
 */

@Slf4j
public class TreeSupport {

    /*
    树的结构示例：
              1
            /   \
          2       3
         / \     / \
        4   5   6   7
    */

    // 用于获得树的层数
    public static int getTreeDepth(XTreeNode root) {
        return root == null ? 0 : (1 + Math.max(getTreeDepth(root.left), getTreeDepth(root.right)));
    }

    private static void writeArray(XTreeNode currNode, int rowIndex, int columnIndex, String[][] res, int treeDepth) {
        // 保证输入的树不为空
        if (currNode == null)
            return;
        // 先将当前节点保存到二维数组中
        res[rowIndex][columnIndex] = String.valueOf(currNode.val);

        // 计算当前位于树的第几层
        int currLevel = ((rowIndex + 1) / 2);
        // 若到了最后一层，则返回
        if (currLevel == treeDepth)
            return;
        // 计算当前行到下一行，每个元素之间的间隔（下一行的列索引与当前元素的列索引之间的间隔）
        int gap = treeDepth - currLevel - 1;

        // 对左儿子进行判断，若有左儿子，则记录相应的"/"与左儿子的值
        if (currNode.left != null) {
            res[rowIndex + 1][columnIndex - gap] = "/";
            writeArray(currNode.left, rowIndex + 2, columnIndex - gap * 2, res, treeDepth);
        }

        // 对右儿子进行判断，若有右儿子，则记录相应的"\"与右儿子的值
        if (currNode.right != null) {
            res[rowIndex + 1][columnIndex + gap] = "\\";
            writeArray(currNode.right, rowIndex + 2, columnIndex + gap * 2, res, treeDepth);
        }
    }

    public static void show(XTreeNode root) {
        if (root == null)
            System.out.println("EMPTY!");
        // 得到树的深度
        int treeDepth = getTreeDepth(root);

        // 最后一行的宽度为2的（n - 1）次方乘3，再加1
        // 作为整个二维数组的宽度
        int arrayHeight = treeDepth * 2 - 1;
        int arrayWidth = (2 << (treeDepth - 2)) * 3 + 1;
        // 用一个字符串数组来存储每个位置应显示的元素
        String[][] res = new String[arrayHeight][arrayWidth];
        // 对数组进行初始化，默认为一个空格
        for (int i = 0; i < arrayHeight; i++) {
            for (int j = 0; j < arrayWidth; j++) {
                res[i][j] = " ";
            }
        }

        // 从根节点开始，递归处理整个树
        writeArray(root, 0, arrayWidth / 2, res, treeDepth);

        // 此时，已经将所有需要显示的元素储存到了二维数组中，将其拼接并打印即可
        for (String[] line : res) {
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < line.length; i++) {
                sb.append(line[i]);
                if (line[i].length() > 1 && i <= line.length - 1) {
                    i += line[i].length() > 4 ? 2 : line[i].length() - 1;
                }
            }
            System.out.println(sb);
        }
    }

    public static XTreeNode<Integer> makeTree(int nodeSize) {
        List<Integer> randomUnRepeated = RandomUtils.randomUnRepeated(nodeSize);
        return makeTree(randomUnRepeated);
    }

    public static XTreeNode<Integer> makeTree(List<Integer> treeValues) {
        if (CollectionUtils.isEmpty(treeValues)) {
            throw new UnsupportedOperationException("treeValues size must be greater than zero");
        }
        log.info("values order {}", treeValues);
        LinkedList<XTreeNode<Integer>> waitNodes = new LinkedList<>();
        XTreeNode<Integer> headNode = null;
        for (Integer nodeValue : treeValues) {
            if (headNode == null) {
                headNode = XTreeNode.of(nodeValue, null, null);
                waitNodes.addLast(headNode);
                continue;
            }
            waitNodes.removeIf(XTreeNode::isFull);
            XTreeNode<Integer> nodesFirst = waitNodes.getFirst();
            XTreeNode<Integer> newNode = nodesFirst.addNode(nodeValue);
            waitNodes.addLast(newNode);
        }
        return headNode;
    }

    // 深度优先递归
    public static void dfsRecursion(XTreeNode node, List<Object> result) {
        if (node == null) {
            return;
        }
        result.add(node.val);
        dfsRecursion(node.left, result);
        dfsRecursion(node.right, result);
    }

    // 深度优先
    public static void dfs(XTreeNode<?> node, List<Object> result) {
        if (node == null) {
            return;
        }
        Stack<XTreeNode<?>> stack = new Stack<>();
        stack.push(node);
        while (!stack.isEmpty()) {
            XTreeNode<?> pop = stack.pop();
            result.add(pop.val);
            if (pop.right != null) {
                stack.push(pop.right);
            }
            if (pop.left != null) {
                stack.push(pop.left);
            }
        }
    }

    // 广度优先递归
    public static void bfsRecursion(XTreeNode node, List<Object> result) {
        if (node == null) {
            return;
        }
        LinkedList<XTreeNode<?>> queue = new LinkedList<>();
        queue.add(node);
        doBfsRecursion(queue, result);
    }

    private static void doBfsRecursion(LinkedList<XTreeNode<?>> queue, List<Object> result) {
        if (queue.isEmpty()) {
            return;
        }
        XTreeNode<?> node = queue.pollFirst();
        result.add(node.val);
        if (node.left != null) {
            queue.add(node.left);
        }
        if (node.right != null) {
            queue.add(node.right);
        }
        doBfsRecursion(queue, result);
    }

    // 广度优先
    public static void bfs(XTreeNode node, List<Object> result) {
        if (node == null) {
            return;
        }
        LinkedList<XTreeNode<?>> queue = new LinkedList<>();
        queue.add(node);

        while (!queue.isEmpty()) {
            node = queue.pollFirst();
            result.add(node.val);
            if (node.left != null) {
                queue.add(node.left);
            }
            if (node.right != null) {
                queue.add(node.right);
            }
        }
    }

}
