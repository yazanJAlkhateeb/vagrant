echo export APP_NAME=psysjo >> /etc/profile
echo export APP_VERSION=rolling-release >> /etc/profile
echo export APP_ARTIFACTID=war >> /etc/profile
echo export JAVA_HOME=/u01/jdk  >> /etc/profile
echo export BUILD_DIR=\"../vagrant/artifacts\" >> /etc/profile


echo export db_driver=\"net.sourceforge.jtds.jdbc.Driver\" >> /etc/profile
echo export db_type=\"MSSQL2008\" >> /etc/profile
echo export db_validation_query=\"SELECT 1\" >> /etc/profile
echo export db_dialect=\"org.hibernate.dialect.SQLServer2008Dialect\" >> /etc/profile
echo export db_check_query=\"SELECT COUNT\(*\) FROM INFORMATION_SCHEMA.TABLES\" >> /etc/profile
echo export db_url=\"jdbc:jtds:sqlserver://localhost:1433/psysjo\" >> /etc/profile
echo export db_user=\"sa\" >> /etc/profile
echo export db_password=\"P@ssw0rd\" >> /etc/profile
echo export db_schema=\"psysjo\" >> /etc/profile
echo export JAVA_OPTS=\"-Dfile.encoding=UTF-8 -Xmx4096m -Xms2048m -XX:NewSize=1600m -XX:MaxNewSize=1600m -XX:+UseG1GC -XX:MetaspaceSize=2048m -XX:MaxMetaspaceSize=2048m\" >> /u01/tomcat/bin/setenv.sh

. /etc/profile

export PATH=$JAVA_HOME/bin:$PATH



echo "+--------------------------------------------------+"
echo "| Kill Tomcat                                      |"
echo "+--------------------------------------------------+"
service tomcat stop
sleep 3

mkdir /u01/temp;chmod 777 /u01/temp

rm -rf ROOT_DIR/tomcat/webapps/*

echo "+-----------------------------------------------------+"
echo "| Checking $APP_NAME artifacts in artifacts directory |"
echo "+-----------------------------------------------------+"

count=`ls -1 $BUILD_DIR/*.war 2>/dev/null | wc -l`
if [ $count == 1 ]; then
     echo "Artifact found."
     cp $BUILD_DIR/*.war temp
else
     echo "Artifacts not found locally .. will try to download it."
echo "+--------------------------------------------------+"
echo "| Downloading $APP_NAME WAR File                   |"
echo "+--------------------------------------------------+"
cd temp
		wget https://jfw_download:P%40ssw0rd@artifactory.psdevelop.com/artifactory/PS-Releases/com/progressoft/pluto/psysjo/war/$APP_VERSION/war-$APP_VERSION.war 1>/dev/null 2>/dev/null
cd ..
fi

unzip -qo temp/*.war -d ROOT_DIR/tomcat/webapps/$APP_NAME
chmod -R 777 ROOT_DIR/tomcat/webapps/*

echo "+--------------------------------------------------+"
echo "| Updating WAR Files                               |"
echo "+--------------------------------------------------+"
. /vagrant/updateWarFilesScript.sh

echo "+--------------------------------------------------+"
echo "| Creating Database                                |"
echo "+--------------------------------------------------+"

yes | cp -rf /vagrant/database/create_user.sql /u01/temp/create_user.sql
yes | cp -rf /vagrant/database/activate_wf.sql /u01/temp/activate_wf.sql

sqlcmd -U $db_user -P $db_password -i temp/create_user.sql


echo "+--------------------------------------------------+"
echo "| Starting DB init & Running startup tasks         |"
echo "+--------------------------------------------------+"

service tomcat stop
sleep 2

cd /u01/tomcat/webapps/$APP_NAME/WEB-INF/lib
java -jar initializer* *-domain-*

echo "+--------------------------------------------------+"
echo "| Executing workflow Scripts						 |"
echo "+--------------------------------------------------+"

cd /u01/temp
sqlcmd -U $db_user -P $db_password -i activate_wf.sql

cd /u01/tomcat/bin
./catalina.sh jpda run ; tail -f /u01/tomcat/logs/catalina.out
sleep 3
echo "+--------------------------------------------------+"
echo "| Waiting for $APP_NAME startup                    |"
echo "+--------------------------------------------------+"
#curl http://localhost:8080/$APP_NAME
echo "+--------------------------------------------------+"
echo "| $APP_NAME Started                                |"
echo "+--------------------------------------------------+"