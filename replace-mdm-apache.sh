#modify config
sed -i "" 's#/usr/sbin/httpd#/usr/local/bin/httpd#g'  /Applications/Server.app/Contents/ServerRoot/usr/sbin/httpd-server-wrapper  
sed -i "" 's#HTTPD_PATH="/usr/sbin/httpd"#HTTPD_PATH="/usr/local/bin/httpd#g' /Applications/Server.app/Contents/ServerRoot/usr/sbin/serviceproxyctl  
sed -i "" 's#libexec/apache2#/usr/local/opt/apache2/lib/httpd/modules#g' /Library/Server/Web/Config/Proxy/apache_serviceproxy.conf  

#using old hfs module and remove the parameter LegacyCertChainVerify  
cp /usr/libexec/apache2/mod_hfs_apple.so /usr/local/opt/apache2/lib/httpd/modules/  
sed -i "" 's#+LegacyCertChainVerify##g' /Library/Server/Web/Config/apache2/httpd_devicemanagement_ssl.conf  
