package com.xiaozhang.lf.demo;

/**
 * @author : xiaozhang
 * @since : 2023/7/21 11:18
 */

public @interface ForeignId {

    /** 对应配置表的类 */
    Class<?> value() default Void.class;

    /** 对应配置表的关联字段名称，不填写则验证@Id字段 */
    String field() default "";

}
