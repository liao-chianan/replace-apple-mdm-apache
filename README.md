

# 取代mdm內建的apache，改成brew的最新版
Apple mdm server buildin apache(2.4.54) is outdated,replace with brew apache(2.4.56)
  
# 系統環境
Environment  
MacOS Monterey 12.6.3  
MacOS server 5.12.2  
  
# !!!!!不保證在任何平台皆能成功，請務必有MacOS的完整備份再進行以下動作!!!!
  

# 步驟 
Step1. 登入系統，打開終端機  
  
Step2. 複製貼上以下指令 (安裝HomeBrew以及apache，過程中會詢問sudo密碼)  
  
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && brew install apache-httpd  

Step3. 修改設定檔 (過程中會詢問sudo密碼)
  
    sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/liao-chianan/replace-apple-mdm-apache/main/replace-mdm-apache.sh)"

Step4. 重開機  
  
    sudo reboot  

Step5.一樣打開終端機，用curl檢查是否已經替換成最新版  
  
    curl --insecure --head https://localhost  
