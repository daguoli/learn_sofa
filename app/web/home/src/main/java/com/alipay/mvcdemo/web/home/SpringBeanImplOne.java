package com.alipay.mvcdemo.web.home;

/**
 * 实现类
 * 在spring配置中使用 sofa-config.properties 里面的变量来进行变量替换.
 * dongjia.shen 20170810
 */

public class SpringBeanImplOne implements SpringBean {


    @Override
    public String getWorld() {
        return "One";
    }
}
