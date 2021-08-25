package common;

import java.util.Collection;

/**
 * @author xiaozhang
 * @date 2021-08-25 22:06
 */
public class CollectionUtils {

    public static boolean isEmpty(Collection collection) {
        return collection == null || collection.size() == 0;
    }
}
