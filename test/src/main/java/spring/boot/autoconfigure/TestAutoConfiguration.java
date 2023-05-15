package spring.boot.autoconfigure;

import org.springframework.beans.factory.InitializingBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

/**
 * @author : xiaozhang
 * @since : 2022/10/14 16:12
 */
@ConditionalOnProperty()
@EnableConfigurationProperties(TestProperties.class)
public class TestAutoConfiguration implements InitializingBean {

    @Override
    public void afterPropertiesSet() throws Exception {

    }
}
