/**
 * Alipay.com Inc.
 * Copyright (c) 2005-2010 All Rights Reserved.
 */
package com.alipay.mvcdemo.web.home;


import com.alipay.mvcdemo.SampleService;
import com.alipay.mvcdemo.web.home.SpringBean;
import com.alipay.sofa.runtime.api.aware.AppConfigurationAware;
import com.alipay.sofa.runtime.api.component.AppConfiguration;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.ui.ModelMap;


///**
// * A sample controller.
// * 在spring配置中使用 sofa-config变量来进行变量替换
// * by dongjia.shen 20170810
// */
//@Controller
//public class SampleController implements AppConfigurationAware{
//
//    @Autowired
//    private SpringBean springBean;
//    private AppConfiguration appConfiguration;
//
//    @RequestMapping(value="/sample",method = RequestMethod.GET)
//    public void doGet(ModelMap modelMap) {
//
//        modelMap.put("hello",appConfiguration.getPropertyValue("hello_001"));
//
//    }
//
//    @Override
//    public void setAppConfiguration(AppConfiguration appConfiguration) {
//        this.appConfiguration = appConfiguration;
//    }
//}

/**
 * A sample controller.
 */
@Controller
public class SampleController {

    @Autowired
    private SampleService sampleService;

	@RequestMapping(value="/sample",method = RequestMethod.GET)
	public void doGet(ModelMap modelMap) {

       modelMap.put("hello",sampleService.hello());

	}
}


///**
// * A sample controller.
// * 在spring配置中使用 sofa-config变量来进行变量替换
// * by dongjia.shen 20170810
// */
//@Controller
//public class SampleController {
//
//    @Autowired
//    private SpringBean springBean;
//
//    @RequestMapping(value="/sample",method = RequestMethod.GET)
//    public void doGet(ModelMap modelMap) {
//
//        modelMap.put("hello",springBean.getWorld());
//
//    }
//}



