package xiaozhang.common;

import java.util.Collection;

import lombok.extern.slf4j.Slf4j;

/**
 * @author xiaozhang
 * @date 2021-08-25 22:06
 */
@Slf4j
public class CollectionUtils {

    public static boolean isEmpty(Collection<?> collection) {
        return collection == null || collection.size() == 0;
    }

}
