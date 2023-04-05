# replace-apple-mdm-apache
Apple mdm server buildin apache(2.4.54) is outdated,replace with brew apache(2.4.56)
# Environment
MacOS Monterey 12.6.3  
MacOS server 5.12.2  

# Step
  
1. Login and start terminal  
  
2. copy and paste command (install brew and apache)  
  
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && brew install apache-httpd  

3. modify config file and pattern (sudo with password)
  
    sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/liao-chianan/replace-apple-mdm-apache/main/replace-mdm-apache.sh)"

4. reboot  


5.check apache version by curl  
  
    curl --insecure --head https://localhost  
