package com.fy.erp;

import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * Created by 尹彬 on 2017/10/24.
 */

@RunWith(SpringJUnit4ClassRunner.class)  //使用junit4进行测试
@ContextConfiguration({"classpath*:spring-context*.xml"}) //加载配置文件
public class BaseJunit {

}
