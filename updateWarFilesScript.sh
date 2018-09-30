sed -i 's@C:/temp@/u01/communication-folders/core@g' /u01/tomcat/webapps/$APP_NAME/WEB-INF/classes/config/product/camel/profiles/default/communication.properties
sed -i 's@C:/temp@/u01/communication-folders/converter@g' /u01/tomcat/webapps/$APP_NAME/WEB-INF/classes/config/product/camel/profiles/default/converter.properties
sed -i 's@C:/temp@/u01/communication-folders/core@g' /u01/tomcat/webapps/$APP_NAME/WEB-INF/classes/config/product/camel/profiles/default/core.properties

sed -i 's/setup.enabled=false/setup.enabled=true/g' /u01/tomcat/webapps/$APP_NAME/WEB-INF/properties/startup.properties
sed -i 's/main.menu.style=horizontal/main.menu.style=vertical/g' /u01/tomcat/webapps/$APP_NAME/WEB-INF/classes/config/core/system-generic.properties

sed -i 's@SRV_TENANT=SYSTEM@SRV_TENANT=PSYSJO@g' /u01/tomcat/webapps/$APP_NAME/WEB-INF/classes/config/product/camel/profiles/default/core.properties
