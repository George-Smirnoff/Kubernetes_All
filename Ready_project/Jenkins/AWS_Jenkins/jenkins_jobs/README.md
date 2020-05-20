## IMPORT/EXPORT JENKINS JOBS

Download jenkins-cli.jar file:
```
curl -O http://<Jenkins-DNS>/jnlpJars/jenkins-cli.jar

For example:
curl -O http://35.158.112.255:32000/jnlpJars/jenkins-cli.jar
```

Install java:
```
sudo apt install default-jre
```

Check the server availability:

```
java -jar jenkins-cli.jar -s http://<Jenkins-DNS>/ -auth <user_name>:<user_passwd> who-am-i

For example:
java -jar jenkins-cli.jar -s http://35.158.112.255:32000/ -auth admin:password who-am-i
```
Export Jenkins job:
```
java -jar jenkins-cli.jar -s http://<Jenkins-DNS>/ -auth <user_name>:<user_passwd> get-job MySQL_backup > MySQL_backup.xml

For example:
java -jar jenkins-cli.jar -s http://35.158.112.255:32000/ -auth admin:password get-job MySQL_backup > MySQL_backup.xml
```
Import Jenkins job:
```
java -jar jenkins-cli.jar -s http://<Jenkins-DNS>/ -auth <user_name>:<user_passwd> create-job newmyjob < MySQL_backup.xml

For example:
java -jar jenkins-cli.jar -s http://35.158.112.255:32000/ -auth admin:password create-job newmyjob < MySQL_backup.xml
```
