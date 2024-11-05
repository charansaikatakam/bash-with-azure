#!/bin/bash

read -p "Please provide the environment suffix or environment name in 30 seconds: " -t 30 env

if [ -z "$env" ]; then
  echo -e "\nyou have not provided the input in 30 seconds \nHENCE EXITING THE EXECUTION RERUN THE SCRIPT AGAIN"
  exit 1
else
  echo -e "entered environment name is - ${env}" 
fi

read -p "Please provide the Hub resource Group Name in 30 seconds: " -t 30 hubrgname

if [ -z "$hubrgname" ]; then
  echo -e "\nyou have not provided  the input in 30 seconds \nHENCE EXITING THE EXECUTION RERUN THE SCRIPT AGAIN"
  exit 1
else
  echo -e "entered hub resource group name is - ${hubrgname}" 
fi

read -p "Please provide the resource group region in 30 seconds: " -t 30 rgregion

if [ -z "$rgregion" ]; then
  echo -e "\nyou have not provided the input in 30 seconds \nHENCE EXITING THE EXECUTION RERUN THE SCRIPT AGAIN"
  exit 1
else
  echo -e "entered hub resource group region is - ${rgregion}" 
fi

# checking whether user has entered the valid region or not

result=$(az account list-locations --query "[].{Name:name}" -o yaml | cut -d : -f 2 | grep -w ${rgregion} | wc -l)

if [ $result -eq 0 ];then
  echo -e "\nYou have entered $rgregion which is NOT A VALID Azure region. Hence enter the valide region for resource groups\nyou can list the valid region name with the following command\n\n     az account list-locations --query "[].{Name:name}" -o yaml | cut -d : -f 2"
  exit 1
else
  echo "entered the valid region"
fi

# Checking the resource group already exists or not

rgresult=$(az group exists -n ${env}-{hubrgname})

#echo $rgresult

if $rgresult;then
  echo "creating the resource group"
  az group create -n ${env}-${hubrgname} -l ${rgregion}
else
  echo "resource group already exists hence skipping the step"
fi