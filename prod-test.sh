#!/bin/bash

sleep 10s

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Checking http codes for each endpoint
healthEndpoint=$(curl -s -o /dev/null -I -w "%{http_code}" https://adarsh-portfolio.duckdns.org/health)
aboutPage=$(curl -s -o /dev/null -I -w "%{http_code}" https://adarsh-portfolio.duckdns.org/about)
blogPage=$(curl -s -o /dev/null -I -w "%{http_code}" https://adarsh-portfolio.duckdns.org/blog)
projectPage=$(curl -s -o /dev/null -I -w "%{http_code}" https://adarsh-portfolio.duckdns.org/projects)

#getting http codes for register and login 

counter=0 
flag=0

echo -e "\n*** CHECKING ALL STATIC ENDPOINTS ***\n"
#check if page loads
curl -o - https://adarsh-portfolio.duckdns.org | grep "Adarsh Patel" -q
flag=$?
if [ $flag -eq 0 ] ; then
    echo -e "${GREEN}Success: webiste loaded${NC}"
else
    echo -e "${RED}Fail: website failed to load${NC}" 
fi

counter=$((counter+flag))

#health endpoint
if [ $healthEndpoint -eq 200 ] ; then 
    echo -e "${GREEN}Success: health endpoint verified${NC}"
else
    echo -e "${RED}Fail: health endpoint failed${NC}" 
    counter=$((counter+1))
fi

#about page
if [ $aboutPage -eq 200 ] ; then 
    echo -e "${GREEN}Success: about page loaded${NC}"
else
    echo -e "${RED}Fail: about page failed to load${NC}" 
    counter=$((counter+1))
fi

#blog page
if [ $blogPage -eq 200 ] ; then 
    echo -e "${GREEN}Success: blog page loaded${NC}"
else
    echo -e "${RED}Fail: blog page failed to load${NC}" 
    counter=$((counter+1))
fi

#projects page 
if [ $projectPage -eq 200 ] ; then 
    echo -e "${GREEN}Success: projects page loaded${NC}"
else
    echo -e "${RED}Fail: projects page failed to load${NC}" 
    counter=$((counter+1))
fi

echo -e "\n*** CHECKING REGISTER AND LOGIN ENDPOINTS ***\n"
curl -X POST -d "username=test&password=test" https://adarsh-portfolio.duckdns.org/register

#user already created with username test and password test
#test successful login
curl -X POST -d "username=test&password=test" https://adarsh-portfolio.duckdns.org/login | grep "Login Successful" -q
flag=$?
if [ $flag -eq 0 ] ; then
    echo -e "${GREEN}Success: login with correct credentials works${NC}"
else
    echo -e "${RED}Fail: login with correct credentials failed${NC}" 
fi
counter=$((counter+flag))

#check if incorrect username detected
curl -X POST -d "username=tssest&password=test" https://adarsh-portfolio.duckdns.org/login | grep "Incorrect username" -q
flag=$?
if [ $flag -eq 0 ] ; then
    echo -e "${GREEN}Success: (LOGIN) Invalid username rejected${NC}"
else
    echo -e "${RED}Fail: (LOGIN) Invalid username not rejected${NC}" 
fi
counter=$((counter+flag))

#check if incorrect password detected
curl -X POST -d "username=test&password=tessst" https://adarsh-portfolio.duckdns.org/login | grep "Incorrect password" -q
flag=$?
if [ $flag -eq 0 ] ; then
    echo -e "${GREEN}Success: (LOGIN) Incorrect password rejected${NC}"
else
    echo -e "${RED}Fail: (LOGIN) Incorrect password rejected${NC}" 
fi
counter=$((counter+flag))

#testing the register endpoint 



#check if empty username is detected 
curl -X POST -d "username=&password=tessst" https://adarsh-portfolio.duckdns.org/register | grep "Username is required" -q
flag=$?
if [ $flag -eq 0 ] ; then
    echo -e "${GREEN}Success: (REGISTER) Empty username feild detected${NC}"
else
    echo -e "${RED}Fail: (REGISTER) Empty username feild not detected${NC}" 
fi
counter=$((counter+flag))

#check if empty password is detected 
curl -X POST -d "username=test&password=" https://adarsh-portfolio.duckdns.org/register | grep "Password is required" -q
flag=$?
if [ $flag -eq 0 ] ; then
    echo -e "${GREEN}Success: (REGISTER) Empty password feild detected${NC}"
else
    echo -e "${RED}Fail: (REGISTER) Empty password feild not detected${NC}" 
fi
counter=$((counter+flag))

#check if existing user found by using 'test' user previously created 
curl -X POST -d "username=test&password=test" https://adarsh-portfolio.duckdns.org/register | grep "User test is already registered" -q
flag=$?
if [ $flag -eq 0 ] ; then
    echo -e "${GREEN}Success: (REGISTER) Detected username already in use${NC}"
else
    echo -e "${RED}Fail: (REGISTER) Failed to detect username already in use${NC}" 
fi
counter=$((counter+flag))

exit $counter
