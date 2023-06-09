

# 取代mdm內建的apache，改成brew的最新版
Apple mdm server buildin apache(2.4.54) is outdated,replace with brew apache(2.4.56 or later)
  
# 已測試系統環境
Environment x86  
MacOS Monterey 12.6.3 + MacOS server 5.12.2  
(upgrade to 12.6.4 and apache 2.4.57 is fine, redo step4 step5 needed)  
MacOS Monterey 12.6.4 + MacOS Server 5.12.2 + apache 2.4.56/2.4.57  
MacOS Bigsur 11.6 + MacOS server 5.11  
MacOS Bigsur 11.2.2 + MacOS server 5.11  
  
# !!!!本過程未經完整驗證與測試，不保證在任何平台皆能成功!!!!  
 !!!!請務必有MacOS的完整備份再進行以下動作，確保失誤時能夠還原!!!!  
  
# !!!!安裝後遇到MacOS系統升級注意事項!!!!  
 如已經安裝成功，但後續又進行了MacOs的系統升級(像是12.6.3升級到12.6.4)，更新完進系統再次開啟Server App時，
 MacOS又會把apache的設定變成預設值，導致mdm服務失效，此時再次執行Step4修改設定並進行Step5重開機即可。     

# 步驟 
Step1. 登入系統，打開終端機  
  
Step2. 安裝HomeBrew (過程中會詢問sudo密碼，按Enter繼續安裝)  
  
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 
    
Step3. 用brew安裝apache  
  
    brew install apache-httpd  

Step4. 修改設定檔 (過程中會詢問sudo密碼)
  
    sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/liao-chianan/replace-apple-mdm-apache/main/replace-mdm-apache.sh)"

Step5. 重開機  
  
    sudo reboot  

Step6.一樣打開終端機，用curl檢查是否已經替換成最新版  
  
    curl --insecure --head https://localhost  
  
    
      
        
          
          
# 參考資料與修改歷程  
  
參考文件：  
https://superuser.com/questions/801724/os-x-server-websites-interfering-with-default-apache  
https://wpbeaches.com/installing-configuring-apache-on-macos-using-homebrew/  
https://www.devxperiences.com/pzwp1/2021/01/05/install-update-apache-httpd-2-4-462-on-mac-mojave/  
https://serverfault.com/questions/446132/os-x-server-how-where-is-the-server-app-changing-the-apache-configuration  
  
  
  
##安裝HomeBrew  
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"  

##透過HomeBrew安裝httpd  
brew install apache-httpd  
  
  
安裝完畢後，mdm server仍然會是舊版本2.4.54  
ps -awx|grep httpd發現啟動路徑不對  
mdm是透過serveradmin start devicemgr啟動，然後再去com.apple.serviceproxy呼叫/usr/sbin/httpd  
但是Homebrew安裝的是 /usr/local/bin/httpd，所以要針對相關設定檔案修正  
  
  
透過grep "bin/httpd" /Applications/Server.app/* -R，找到幾個主要的設定檔案並且修改  
sed -i "" 's#/usr/sbin/httpd#/usr/local/bin/httpd#g'  /Applications/Server.app/Contents/ServerRoot/usr/sbin/httpd-server-wrapper  
sed -i "" 's#HTTPD_PATH="/usr/sbin/httpd"#HTTPD_PATH="/usr/local/bin/httpd#g' /Applications/Server.app/Contents/ServerRoot/usr/sbin/serviceproxyctl  
  
載入的模組也要換到正確的新版路徑  
sed -i "" 's#libexec/apache2#/usr/local/opt/apache2/lib/httpd/modules#g' /Library/Server/Web/Config/Proxy/apache_serviceproxy.conf  
  
再次啟動會發現失敗檢查/private/var/log/apache2/service_proxy_error.log的錯誤訊息，顯示少了apple hfs模組，新的apache也無法加上LegacyCertChainVerify這個參數  
  
所以把舊的hfs module直接複製一份給新的apache使用，並且拿掉LegacyCertChainVerify啟動參數  
cp /usr/libexec/apache2/mod_hfs_apple.so /usr/local/opt/apache2/lib/httpd/modules/  
sed -i "" 's#+LegacyCertChainVerify##g' /Library/Server/Web/Config/apache2/httpd_devicemanagement_ssl.conf  
    
測試另一台Bigsur環境還缺了httpd的設定檔目錄，所以補一行  
test -f /usr/local/etc/httpd/mime.types || cp -r /usr/local/opt/httpd/.bottle/etc/httpd/ /usr/local/etc/httpd  
  
重新啟動apache，測試結果就正常嘍  
  
# 後記  
經測試mdm server若不開外網連線、只留內網連線的情形下也能夠正常運作與佈署app，只是差別在於設備拿到外部網路環境時就無法派送，  
大多數設備應會以內網使用為主，所以若只需要在內網部署與派送設備避免資安警訊，也可以直接考慮關閉mdm server的外網連線，就不一定要進行上面的更新步驟了。
