package uz.erp.handlers;
import com.sap.cds.services.handler.EventHandler;
import com.sap.cds.services.handler.annotations.After;
import com.sap.cds.services.handler.annotations.Before;
import com.sap.cds.services.handler.annotations.On;
import com.sap.cds.services.handler.annotations.ServiceName;
import com.sap.cds.services.mt.MtGetDependenciesEventContext;
import com.sap.cds.services.mt.MtSubscribeEventContext;
import com.sap.cds.services.mt.MtSubscriptionService;
import com.sap.cds.services.mt.MtUnsubscribeEventContext;
import com.sap.cloud.mt.subscription.json.ApplicationDependency;
import com.sap.xsa.core.instancemanager.client.InstanceCreationOptions;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Slf4j
//@Component
@ServiceName(MtSubscriptionService.DEFAULT_NAME)
public class SubscriptionHandler implements EventHandler {
    @Value("${vcap.services.<my-service-instance>.credentials.xsappname}")
    private String xsappname;

    @On(event = MtSubscriptionService.EVENT_GET_DEPENDENCIES)
    public void onGetDependencies(MtGetDependenciesEventContext context) {
        log.info("ON ------ EVENT GET DEPENDENCIES invoked");
        ApplicationDependency dependency = new ApplicationDependency();
        dependency.xsappname = xsappname;
        List<ApplicationDependency> dependencies = new ArrayList<>();
        dependencies.add(dependency);
        context.setResult(dependencies);
    }

    @Before(event = MtSubscriptionService.EVENT_SUBSCRIBE)
    public void beforeSubscription(MtSubscribeEventContext context) {
        log.info("BEFORE ------ EVENT SUBSCRIBE invoked");

        // Activities before tenant database container is created
        context.setInstanceCreationOptions(
                new InstanceCreationOptions().withProvisioningParameters(
                        Collections.singletonMap("database_id", "<database ID>")));
    }

    @After(event = MtSubscriptionService.EVENT_SUBSCRIBE)
    public void afterSubscription(MtSubscribeEventContext context) {
        log.info("AFTER ------ EVENT SUBSCRIBE invoked");

        // For example, send notification, …
        if (context.getResult() == null) {
            context.setResult(
                    "https://" +
                            context.getSubscriptionPayload().subscribedSubdomain +
                            ".cfapps.us10-001.hana.ondemand.com");
        }
    }

    @Before(event = MtSubscriptionService.EVENT_UNSUBSCRIBE)
    public void beforeUnsubscribe(MtUnsubscribeEventContext context) {
        // Activities before off-boarding
        log.info("BEFORE ------ EVENT UNSUBSCRIBE invoked");

        // Trigger deletion of database container of off-boarded tenant
        context.setDelete(true);
    }

    @After(event = MtSubscriptionService.EVENT_UNSUBSCRIBE)
    public void afterUnsubscribe(MtUnsubscribeEventContext context) {
        // Notify off-boarding finished
        log.info("AFTER ------ EVENT UNSUBSCRIBE invoked");
    }
}
