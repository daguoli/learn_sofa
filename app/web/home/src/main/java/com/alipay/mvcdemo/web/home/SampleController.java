/**
 * Alipay.com Inc.
 * Copyright (c) 2005-2010 All Rights Reserved.
 */
package com.alipay.mvcdemo.web.home;


//import com.alipay.mvcdemo.SampleService;
import com.alipay.mvcdemo.web.home.SpringBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.ui.ModelMap;

///**
// * A sample controller.
// */
//@Controller
//public class SampleController {
//
//    @Autowired
//    private SampleService sampleService;
//
//	@RequestMapping(value="/sample",method = RequestMethod.GET)
//	public void doGet(ModelMap modelMap) {
//
//       modelMap.put("hello",sampleService.hello());
//
//	}
//}


/**
 * A sample controller.
 */
@Controller
public class SampleController {

    @Autowired
    private SpringBean springBean;

    @RequestMapping(value="/sample",method = RequestMethod.GET)
    public void doGet(ModelMap modelMap) {

        modelMap.put("hello",springBean.getWorld());

    }
}
