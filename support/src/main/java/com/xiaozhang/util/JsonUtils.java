package com.xiaozhang.util;

import java.io.IOException;
import java.io.StringWriter;
import java.lang.reflect.Field;
import java.lang.reflect.GenericArrayType;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicLong;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.reflect.TypeUtils;
import org.slf4j.helpers.FormattingTuple;
import org.slf4j.helpers.MessageFormatter;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.module.SimpleModule;
import com.fasterxml.jackson.databind.type.TypeFactory;

/**
 * JSON转换相关的工具类 注意,Map的Key只能为简单类型，不可采用复杂类型。
 *
 * @author Kubby
 */
@SuppressWarnings({"unchecked", "rawtypes"})
public final class JsonUtils {

    private static final TypeFactory TYPE_FACTORY = TypeFactory.defaultInstance();
    private static final long LONG_JS_MAX_VLAUE = 1L << 53;
    private static final ObjectMapper MAPPER_CONVERT;
    private static final ObjectMapper MAPPER;

    static {
        MAPPER_CONVERT = new ObjectMapper();
        MAPPER_CONVERT.setVisibility(MAPPER_CONVERT.getVisibilityChecker()
            .withFieldVisibility(JsonAutoDetect.Visibility.ANY).withGetterVisibility(JsonAutoDetect.Visibility.NONE)
            .withIsGetterVisibility(JsonAutoDetect.Visibility.NONE).withSetterVisibility(JsonAutoDetect.Visibility.NONE)
            .withCreatorVisibility(JsonAutoDetect.Visibility.NONE));

        MAPPER = new ObjectMapper();
        MAPPER.setVisibility(MAPPER.getVisibilityChecker().withFieldVisibility(JsonAutoDetect.Visibility.ANY)
            .withGetterVisibility(JsonAutoDetect.Visibility.NONE).withIsGetterVisibility(JsonAutoDetect.Visibility.NONE)
            .withSetterVisibility(JsonAutoDetect.Visibility.NONE)
            .withCreatorVisibility(JsonAutoDetect.Visibility.NONE));
        MAPPER.enable(DeserializationFeature.ACCEPT_SINGLE_VALUE_AS_ARRAY);
        MAPPER.enable(SerializationFeature.WRITE_DATE_KEYS_AS_TIMESTAMPS);
        MAPPER.enable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);

        // Long
        SimpleModule module = new SimpleModule();
        JsonSerializer<Long> longSerializer = new JsonSerializer<Long>() {
            @Override
            public void serialize(Long value, JsonGenerator jgen, SerializerProvider provider) throws IOException {
                jgen.writeNumber(value);
            }
        };
        JsonDeserializer<? extends Long> longDeserializer = new JsonDeserializer<Long>() {
            @Override
            public Long deserialize(JsonParser jp, DeserializationContext ctxt) throws IOException {
                return Long.valueOf(jp.getValueAsString());
            }
        };
        // AtomicInteger
        JsonSerializer<AtomicInteger> atomicIntegerSerializer = new JsonSerializer<AtomicInteger>() {
            @Override
            public void serialize(AtomicInteger value, JsonGenerator jgen, SerializerProvider provider)
                throws IOException {
                jgen.writeNumber(value.get());
            }
        };
        JsonDeserializer<AtomicInteger> atomicIntegerDeserializer = new JsonDeserializer<AtomicInteger>() {
            @Override
            public AtomicInteger deserialize(JsonParser jp, DeserializationContext ctxt) throws IOException {
                String s = jp.getValueAsString();
                if (s == null) {
                    return new AtomicInteger();
                } else {
                    return new AtomicInteger(Integer.parseInt(s));
                }
            }
        };
        // AtomicLong
        JsonSerializer<AtomicLong> atomicLongSerializer = new JsonSerializer<AtomicLong>() {
            @Override
            public void serialize(AtomicLong value, JsonGenerator jgen, SerializerProvider provider)
                throws IOException {
                jgen.writeNumber(value.get());
            }
        };
        JsonDeserializer<AtomicLong> atomicLongDeserializer = new JsonDeserializer<AtomicLong>() {
            @Override
            public AtomicLong deserialize(JsonParser jp, DeserializationContext ctxt) throws IOException {
                String s = jp.getValueAsString();
                if (s == null) {
                    return new AtomicLong();
                } else {
                    return new AtomicLong(Long.parseLong(s));
                }
            }
        };
        // BIGINTEGER
        JsonSerializer<BigInteger> bigIntSerializer = new JsonSerializer<BigInteger>() {
            @Override
            public void serialize(BigInteger value, JsonGenerator jgen, SerializerProvider provider)
                throws IOException {
                if (value.longValue() >= LONG_JS_MAX_VLAUE) {
                    jgen.writeString(value.toString());
                } else {
                    jgen.writeNumber(value);
                }
            }
        };
        // BIGDECIMAL
        JsonSerializer<BigDecimal> bigDecSerializer = new JsonSerializer<BigDecimal>() {
            @Override
            public void serialize(BigDecimal value, JsonGenerator jgen, SerializerProvider provider)
                throws IOException {
                jgen.writeString(String.valueOf(value));
            }
        };
        module.addSerializer(long.class, longSerializer);
        module.addSerializer(Long.class, longSerializer);
        module.addSerializer(AtomicInteger.class, atomicIntegerSerializer);
        module.addSerializer(AtomicLong.class, atomicLongSerializer);
        module.addSerializer(BigInteger.class, bigIntSerializer);
        module.addSerializer(BigDecimal.class, bigDecSerializer);

        module.addDeserializer(long.class, longDeserializer);
        module.addDeserializer(Long.class, longDeserializer);
        module.addDeserializer(AtomicInteger.class, atomicIntegerDeserializer);
        module.addDeserializer(AtomicLong.class, atomicLongDeserializer);

        // COLLECTION
        module.addSerializer(Collection.class, new JsonSerializer<Collection>() {
            @Override
            public void serialize(Collection value, JsonGenerator jgen, SerializerProvider provider)
                throws IOException {
                jgen.writeStartArray();
                Iterator it = value.iterator();
                while (it.hasNext()) {
                    Object o = it.next();
                    jgen.writeObject(o);
                }
                jgen.writeEndArray();
            }
        });
        // MAP
        module.addSerializer(Map.class, new JsonSerializer<Map>() {
            @Override
            public void serialize(Map value, JsonGenerator jgen, SerializerProvider provider) throws IOException {
                jgen.writeStartObject();
                Iterator<Entry> it = value.entrySet().iterator();
                while (it.hasNext()) {
                    Entry o = it.next();
                    Object k = o.getKey();
                    Object v = o.getValue();
                    String fn;
                    if (k instanceof String) {
                        fn = (String)k;
                    } else if (k instanceof Enum) {
                        fn = ((Enum)k).name();
                    } else if (k instanceof Number) {
                        fn = k.toString();
                    } else {
                        StringWriter out = new StringWriter();
                        MAPPER.writeValue(out, k);
                        fn = out.toString();
                        int len = fn.length();
                        if (fn.charAt(0) == '\"' && fn.charAt(len - 1) == '\"') {
                            fn = fn.substring(1, len - 1);
                        }
                    }
                    jgen.writeObjectField(fn, v);
                }
                jgen.writeEndObject();
            }
        });

        MAPPER.registerModule(module);
    }

    private JsonUtils() {
        throw new IllegalAccessError("该类不允许实例化");
    }

    /**
     * 将对象转换为 JSON 的字符串格式
     *
     * @param obj 被转换的对象
     * @return 当参数为空时会返回null
     */
    public static String object2String(Object obj) {
        if (obj == null) {
            return null;
        }
        StringWriter writer = new StringWriter();
        try {
            MAPPER.writeValue(writer, obj);
        } catch (Exception e) {
            FormattingTuple message = MessageFormatter.format("将对象[{}]转换为JSON字符串时发生异常", obj, e);
            throw new RuntimeException(message.getMessage(), e);
        }
        return writer.toString();
    }

    /**
     * 将 JSON 格式的字符串转换为 map
     *
     * @param json JSON，允许为空
     * @return json为null时会返回空的Map实例
     */
    public static Map<String, Object> string2Map(String json) {
        try {
            if (StringUtils.isBlank(json)) {
                return HashMap.class.newInstance();
            }
            JavaType type = TYPE_FACTORY.constructMapType(HashMap.class, String.class, Object.class);
            return MAPPER.readValue(json, type);
        } catch (Exception e) {
            FormattingTuple message = MessageFormatter.format("将字符串[{}]转换为Map时出现异常", json);
            throw new RuntimeException(message.getMessage(), e);
        }
    }

    /**
     * 将 JSON 格式的字符串转换为数组
     *
     * @param <T>
     * @param json 字符串
     * @param clz 数组类型
     * @return json为null时会返回null
     */
    public static <T> T[] string2Array(String json, Class<T> clz) {
        try {
            if (StringUtils.isBlank(json)) {
                return null;
            }
            JavaType type = TYPE_FACTORY.constructArrayType(clz);
            return (T[])MAPPER.readValue(json, type);
        } catch (Exception e) {
            FormattingTuple message = MessageFormatter.format("将字符串[{}]转换为数组时出现异常", json, e);
            throw new RuntimeException(message.getMessage(), e);
        }
    }

    /**
     * 将 JSON 格式的字符串转换为对象
     *
     * @param <T>
     * @param json 字符串
     * @param clz 对象类型
     * @return json为null时会返回null
     */
    public static <T> T string2Object(String json, Class<T> clz) {
        try {
            if (StringUtils.isBlank(json)) {
                return null;
            }
            JavaType type = TYPE_FACTORY.constructType(clz);
            return (T)MAPPER.readValue(json, type);
        } catch (Exception e) {
            FormattingTuple message =
                MessageFormatter.format("将字符串[{}]转换为对象[{}]时出现异常", new Object[] {json, clz.getSimpleName(), e});
            throw new RuntimeException(message.getMessage(), e);
        }
    }

    /**
     * 将 JSON 格式的字符串转换为对象
     *
     * @param <T>
     * @param json 字符串
     * @param type 对象类型
     * @return json为null时会返回null
     */
    public static <T> T string2Object(String json, Type type) {
        try {
            if (StringUtils.isBlank(json)) {
                return null;
            }
            JavaType t = TYPE_FACTORY.constructType(type);
            return (T)MAPPER.readValue(json, t);
        } catch (Exception e) {
            FormattingTuple message = MessageFormatter.format("将字符串[{}]转换为对象[{}]时出现异常", new Object[] {json, type, e});
            throw new RuntimeException(message.getMessage(), e);
        }
    }

    /***
     * json 泛型转换
     *
     * @param tr 示例 new TypeReference<List<Long>>(){}
     **/
    public static <T> T string2GenericObject(String json, TypeReference<T> tr) {
        if (StringUtils.isBlank(json)) {
            return null;
        } else {
            try {
                return (T)MAPPER.readValue(json, tr);
            } catch (Exception e) {
                FormattingTuple message = MessageFormatter.format("将字符串[{}]转换为[{}]时出现异常", new Object[] {json, tr});
                throw new RuntimeException(message.getMessage(), e);
            }
        }
    }

    /***
     * json 泛型转换
     *
     * @param field 属性变量多重泛型转换
     * @return 当json为空返回null 否则返回field类型值
     **/
    public static Object string2GenericObject(String json, Field field) {
        if (StringUtils.isBlank(json)) {
            return null;
        }
        TypeReference<Object> tr = buildReference(field.getGenericType());
        return string2GenericObject(json, tr);
    }

    /**
     * 将 JSON 格式的字符串转换为对象
     *
     * @param <T>
     * @param json 字符串
     * @param type 对象类型
     * @return json为null时会返回null
     */
    public static <T> T bytes2Object(byte[] json, Type type) {
        try {
            if (json == null || json.length == 0) {
                return null;
            }
            JavaType t = TYPE_FACTORY.constructType(type);
            return (T)MAPPER.readValue(json, t);
        } catch (Exception e) {
            FormattingTuple message = MessageFormatter.format("将字符串[{}]转换为对象[{}]时出现异常", new Object[] {json, type, e});
            throw new RuntimeException(message.getMessage(), e);
        }
    }

    /***
     * json数组泛型转换
     *
     * @param tr 示例 new TypeReference<List<Long>>(){}
     **/
    public static <T> T bytes2GenericObject(byte[] json, TypeReference<T> tr) {
        if (json == null || json.length == 0) {
            return null;
        } else {
            try {
                return (T)MAPPER.readValue(json, tr);
            } catch (Exception e) {
                FormattingTuple message = MessageFormatter.format("将字符串[{}]转换为[{}]时出现异常", new Object[] {json, tr});
                throw new RuntimeException(message.getMessage(), e);
            }
        }
    }

    /**
     * 将 JSON 格式的字符串转换为集合
     *
     * @param json 字符串
     * @param collectionType 集合类型
     * @param elementType 元素类型
     * @return json为null时会返回空的集合实例
     */
    public static <C extends Collection<E>, E> C string2Collection(String json, Class<C> collectionType,
        Class<E> elementType) {
        try {
            if (StringUtils.isBlank(json)) {
                return collectionType.newInstance();
            }
            JavaType type = TYPE_FACTORY.constructCollectionType(collectionType, elementType);
            return MAPPER.readValue(json, type);
        } catch (Exception e) {
            FormattingTuple message = MessageFormatter.format("将字符串[{}]转换为集合[{}]时出现异常",
                new Object[] {json, collectionType.getSimpleName(), e});
            throw new RuntimeException(message.getMessage(), e);
        }
    }

    /**
     * 将字符串转换为{@link HashMap}对象实例
     *
     * @param json 被转换的字符串
     * @param keyType 键类型
     * @param valueType 值类型
     * @return json为null时会返回空的HashMap实例
     */
    public static <K, V> Map<K, V> string2Map(String json, Class<K> keyType, Class<V> valueType) {
        try {
            if (StringUtils.isBlank(json)) {
                return HashMap.class.newInstance();
            }
            JavaType type = TYPE_FACTORY.constructMapType(HashMap.class, keyType, valueType);
            return (Map<K, V>)MAPPER.readValue(json, type);
        } catch (Exception e) {
            FormattingTuple message = MessageFormatter.format("将字符串[{}]转换为Map时出现异常", json);
            throw new RuntimeException(message.getMessage(), e);
        }
    }

    /**
     * 将字符串转换为特定的{@link Map}对象实例
     *
     * @param json 被转换的字符串
     * @param keyType 键类型
     * @param valueType 值类型
     * @param mapType 指定的{@link Map}类型
     * @return json为空时会返回空的Map实例
     */
    public static <M extends Map<K, V>, K, V> M string2Map(String json, Class<K> keyType, Class<V> valueType,
        Class<M> mapType) {
        try {
            if (StringUtils.isBlank(json)) {
                return mapType.newInstance();
            }
            JavaType type = TYPE_FACTORY.constructMapType(mapType, keyType, valueType);
            return MAPPER.readValue(json, type);
        } catch (Exception e) {
            FormattingTuple message = MessageFormatter.format("将字符串[{}]转换为Map时出现异常", json);
            throw new RuntimeException(message.getMessage(), e);
        }
    }

    /**
     * 将 JSON 对象类型转换
     *
     * @param value 字符串
     * @param type 对象类型
     * @return json为null时会返回null
     */
    public static <T> T convertObject(Object value, Type type) {
        try {
            if (value == null) {
                return (T)value;
            }
            if (TypeUtils.isAssignable(type, Number.class) && value instanceof Number) {
                return NumberUtils.valueOf(type, (Number)value);
            }
            if (!(value instanceof Collection && TypeUtils.isAssignable(type, Collection.class))
                && !(value instanceof Map && TypeUtils.isAssignable(type, Map.class))) {
                // XXX 实例泛型数据丢失，无法判断
                if (TypeUtils.isInstance(value, type)) {
                    return (T)value;
                }
            }
            JavaType t = TYPE_FACTORY.constructType(type);
            return (T)MAPPER_CONVERT.convertValue(value, t);
        } catch (Exception e) {
            FormattingTuple message = MessageFormatter.format("将对象[{}]转换为类型[{}]时出现异常", new Object[] {value, type, e});
            throw new RuntimeException(message.getMessage(), e);
        }
    }

    /**
     * 将 JSON 对象类型转换
     *
     * @param <T>
     * @param value 字符串
     * @param tr 对象类型
     * @return json为null时会返回null
     */
    public static <T> T convertObject(Object value, TypeReference<T> tr) {
        Type type = tr.getType();
        return convertObject(value, type);
    }

    /**
     * java map 转换对象
     *
     * @param mapData 原始数据
     * @param tr 转换类型
     */
    public static <T> T map2Object(Map mapData, TypeReference<T> tr) {
        if (mapData == null) {
            return (T)mapData;
        }
        try {
            if (TypeUtils.isInstance(mapData, tr.getType())) {
                return (T)mapData;
            }
            return MAPPER_CONVERT.convertValue(mapData, tr);
        } catch (Exception e) {
            FormattingTuple message = MessageFormatter.format("将MAP[{}]转换为[{}]时出现异常", new Object[] {mapData, tr});
            throw new RuntimeException(message.getMessage(), e);
        }
    }

    /**
     * java list 转换对象
     *
     * @param values 原始数据
     * @param keys 对应 values 索引KEY
     * @param tr 转换类型
     */
    public static <T> T list2Object(List<?> values, String[] keys, TypeReference<T> tr) {
        Map<String, Object> mapData = new HashMap<>(keys.length);
        for (int i = 0; i < keys.length && i < values.size(); i++) {
            Object value = values.get(i);
            if (value == null) {
                continue;
            }
            String key = keys[i];

            mapData.put(key, value);
        }
        return map2Object(mapData, tr);
    }

    /**
     * 构建通用类型引用
     *
     * @param type {@link ParameterizedType}、{@link GenericArrayType}
     * @param <A>
     * @return
     */
    private static <A> TypeReference<A> buildReference(Type type) {
        return new TypeReference<A>() {
            @Override
            public Type getType() {
                return type;
            }
        };
    }

}
