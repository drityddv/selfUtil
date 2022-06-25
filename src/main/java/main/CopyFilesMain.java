package main;

import java.io.IOException;

import com.google.common.hash.BloomFilter;
import com.google.common.hash.Funnels;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : ddv
 * @since : 2021/8/28 14:25
 */
@Slf4j
public class CopyFilesMain {

    public static void main(String[] args) throws IOException {
		//获取系统类加载器 sun.misc.Launcher$AppClassLoader@18b4aac2
		ClassLoader systemClassLoader = ClassLoader.getSystemClassLoader();
		System.out.println(systemClassLoader);

		//获取拓展类加载器 sun.misc.Launcher$ExtClassLoader@14ae5a5
		ClassLoader extClassLoader = systemClassLoader.getParent();
		System.out.println(extClassLoader);

		//获取根类加载器 null
		ClassLoader bootstrapClassLoader = extClassLoader.getParent();
		System.out.println(bootstrapClassLoader);

		//用户自定类加载器 sun.misc.Launcher$AppClassLoader@18b4aac2(使用系统加载器进行加载)
		ClassLoader classLoader = CopyFilesMain.class.getClassLoader();
		System.out.println(classLoader);
		//获取string 类加载器 null(使用引导类加载器)java核心都是使用该种加载方式
		ClassLoader stringClassLoader = String.class.getClassLoader();
		System.out.println(stringClassLoader);
    }
}
