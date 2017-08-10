package com.alipay.mvcdemo;

import com.alipay.sofa.runtime.api.annotation.SofaService;

@SofaService(uniqueId = "sample")
public class SampleServiceImpl implements SampleService {

    @Override
    public String hello() {
        return "SOFA4";
    }

}