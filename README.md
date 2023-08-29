# ERP

ERP is an application implemented using SAP CAP, SAP HANA integrating with Java/Spring Boot.

## Running project locally

Use the package manager [maven](https://maven.apache.org/) to run locally.

```bash
# maven
mvn clean install
mvn spring-boot:run
```

## Open local application

http://localhost:8080

http://localhost:8080/api/EmployeeService/Employee

http://localhost:8080/api/EmployeeService/Device

## SAP HANA

After providing SAP HANA Cloud instance, add cds-feature-hana dependency and configure the file .cdsrc.json in the root folder.

```bash
{
  "hana" : {
    "deploy-format": "hdbtable"
  }
}
```

Implicitly push all artifacts to the database.

```bash
cds deploy --to hana:erp-hana --store-credentials
```

Follow these links for detailed explanation:

[Start Using SAP HANA Cloud Trial in SAP BTP Cockpit](https://developers.sap.com/tutorials/hana-cloud-mission-trial-2.html)

[Provision an Instance of SAP HANA Cloud, SAP HANA Database](https://developers.sap.com/tutorials/hana-cloud-mission-trial-3.html)


## Deploying it to CF

Run the following command to configure which Cloud Foundry environment you want to connect to in the terminal.

```bash
cf api <CF_API_ENDPOINT>

cf login
```

To deploy project into Cloud Foundry created a application manifest and enabled application for Cloud Foundry.

```bash
mvn clean install

cf push

cf apps
```

## XSUAA for local

While enabling application for Cloud Foundry by adding the cds-starter-cloudfoundry dependency it enabled CAP Java’s secure-by-default behaviour based on Spring Security. Now we should add some custom mock users to the application via adding the security section to the application.yaml file.

```bash
  security:
    mock:
      users:
        - name: admin
          password: admin
          roles:
            - admin
```

## XSUAA for Cloud Foundry

First we should generate security descriptor.

```bash
cds compile srv/ --to xsuaa > xs-security.json
```

Update application manifest.

```bash
---
applications:
  - name: erp
    path: srv/target/erp-exec.jar
    random-route: true
    buildpacks:
      - java_buildpack
    env:
      JBP_CONFIG_OPEN_JDK_JRE: '{ jre: { version: 17.+ }}'
      JBP_CONFIG_SPRING_AUTO_RECONFIGURATION: '{enabled: false}'
      SPRING_PROFILES_ACTIVE: cloud
    services:
      - erp-hana
      - erp-xsuaa
      - erp-logs
```

Then, create instance of the Authorization and Trust Management Service

```bash
cf create-service xsuaa application orders-xsuaa -c security/xs-security.json
```

In order to get environment variables for OAuth 2.0, we shoould run following command:

```bash
cf env erp
```

Follow these links for detailed explanation:

[Add Authentication and Authorization to the Application](https://developers.sap.com/tutorials/cp-cap-java-security-local.html)

[Configure Authentication and Authorization on SAP BTP](https://developers.sap.com/tutorials/cp-cap-java-security-cf.html)

## Logging service

```bash
cf create-service application-logs lite erp-logs

cf bind-service erp erp-logs
```
[Logging service](https://help.sap.com/docs/application-logging-service/sap-application-logging-service/sap-application-logging-service-for-cloud-foundry-environment)

## Remote debugging

Add below property in your manifest.yaml:

```bash
JBP_CONFIG_JAVA_OPTS: "[java_opts: '-agentlib:jdwp=transport=dt_socket,address=8000,server=y,suspend=n,onjcmd=y']"
env:
  JBP_CONFIG_SAP_MACHINE_JDK: "[default_debug_agent_active: true]"
```

Restage your application:

```bash
cf restage erp
```

After successfully navigating to space, you need to enable the ssh-tunnel for the application you want to debug. Just to be sure, run the below command to see whether ssh is enabled for your application or not. 

```bash
cf enable-ssh erp
cf ssh-enabled erp
cf ssh erp
```

Move to 'bin' directory:

```bash
cd app/META-INF/.sap_java_buildpack/sap_machine_jdk/bin
```

Run the following command to found $JAVA_PID of debug process:
'META-INF/.sap_java_buildpack/sap_machine_jdk/bin/java'

```bash
ps aux
exit
```

Start the debug process. Replace $JAVA_PID on your number, and <app_name>:

```bash
cf ssh erp -c "export JAVA_PID=ps java pid= && app/META-INF/.sap_java_buildpack/sap_machine_jdk/bin/jcmd $JAVA_PID VM.start_java_debugging"
```

Open SSH connection to debug process and edit configuration for the debug process in Intellij IDEA:

```bash
cf ssh -N -T -L 8000:localhost:8000 erp
```

Follow these links for detailed explanation:

[Remote Debugging on Cloud Foundry](https://blogs.sap.com/2019/07/24/remote-debugging-on-cloud-foundry/)

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change, suppose new custom handlers or entities.

Please make sure to update tests as appropriate.

## Cloud Foundry

[Project link on CF](https://erp-active-rabbit-hd.cfapps.us10-001.hana.ondemand.com)

## Reference

[Build a Business Application Using CAP for Java](https://developers.sap.com/mission.cap-java-app.html)

[SAP Tutorial: App initialization, creating a model and API, manual API testing in CAP JAVA](https://medium.com/nerd-for-tech/sap-tutorial-complete-cap-java-part-1-fc1868c7bbba)

[CAPire](https://cap.cloud.sap/docs/about/)
