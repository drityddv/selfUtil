package xiaozhang.algorithm.model;

import java.util.Optional;

import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import xiaozhang.algorithm.leetcode.model.TreeNode;
import xiaozhang.util.JsonUtils;

/**
 * @author : xiaozhang
 * @since : 2022/9/15 15:03
 */

@Getter
@Setter
@Slf4j
public class XTreeNode<T> {

    public T val;
    public XTreeNode<T> left;
    public XTreeNode<T> right;

    public static <T> XTreeNode<T> of(T value, XTreeNode<T> left, XTreeNode<T> right) {
        XTreeNode<T> node = new XTreeNode<T>();
        node.val = value;
        node.left = left;
        node.right = right;
        return node;
    }

    /**
     * 节点高度
     */
    public int getHeight() {
        if (left == null && right == null) {
            return 1;
        }
        int leftHeight = Optional.ofNullable(left).map(XTreeNode::getHeight).orElse(0);;
        int rightHeight = Optional.ofNullable(right).map(XTreeNode::getHeight).orElse(0);;
        return 1 + Math.max(leftHeight, rightHeight);
    }

    public XTreeNode<T> addNode(T insertValue) {
        if (left == null) {
            this.left = XTreeNode.of(insertValue, null, null);
            return this.left;
        }
        if (right == null) {
            this.right = XTreeNode.of(insertValue, null, null);
            return this.right;
        }
        throw new RuntimeException("node is full");
    }

    public TreeNode toLeetCodeTree() {
        TreeNode head = new TreeNode((Integer)this.val);
        toLeetCodeTree(head, (XTreeNode<Integer>)this);
        return head;
    }

    private static void toLeetCodeTree(TreeNode head, XTreeNode<Integer> xTreeNode) {
        if (xTreeNode.left != null) {
            Integer nodeValue = Optional.ofNullable(xTreeNode.left.val).orElse(0);
            head.left = new TreeNode(nodeValue);
            toLeetCodeTree(head.left, xTreeNode.left);
        }

        if (xTreeNode.right != null) {
            Integer nodeValue = Optional.ofNullable(xTreeNode.right.val).orElse(0);
            head.right = new TreeNode(nodeValue);
            toLeetCodeTree(head.right, xTreeNode.right);
        }
    }

    public String toJson() {
        String jsonString = JsonUtils.object2String(this);
        log.info("{}", jsonString);
        return jsonString;
    }

    public boolean isFull() {
        return left != null && right != null;
    }
}
