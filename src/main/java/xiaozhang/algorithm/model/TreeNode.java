package xiaozhang.algorithm.model;

import java.util.Optional;

import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2022/9/15 15:03
 */

@Getter
@Setter
@Slf4j
public class TreeNode<T> {

    public T value;
    public TreeNode<T> leftNode;
    public TreeNode<T> rightNode;

    public static <T> TreeNode<T> of(T value, TreeNode<T> left, TreeNode<T> right) {
        TreeNode<T> node = new TreeNode<T>();
        node.value = value;
        node.leftNode = left;
        node.rightNode = right;
        return node;
    }

    /**
     * 节点高度
     */
    public int getHeight() {
        if (leftNode == null && rightNode == null) {
            return 1;
        }
        int leftHeight = Optional.ofNullable(leftNode).map(TreeNode::getHeight).orElse(0);;
        int rightHeight = Optional.ofNullable(rightNode).map(TreeNode::getHeight).orElse(0);;
        return 1 + Math.max(leftHeight, rightHeight);
    }

    public void addNode(T insertValue) {
        if (leftNode == null) {
            this.leftNode = TreeNode.of(insertValue, null, null);
            return;
        }
        if (rightNode == null) {
            this.rightNode = TreeNode.of(insertValue, null, null);
            return;
        }

        // 判断两个节点深度 找浅的插入
        TreeNode<T> targetNode = leftNode.getHeight() <= rightNode.getHeight() ? leftNode : rightNode;
        targetNode.addNode(insertValue);

    }

    public void print() {
        log.info("{}", value);
    }
}
