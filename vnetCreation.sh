#!/bin/bash

read -p "Please provide the environment suffix or environment name in 30 seconds: " -t 30 env

if [ -z "$env" ]; then
  echo -e "\nyou have not provided the input in 30 seconds \nHENCE EXITING THE EXECUTION RERUN THE SCRIPT AGAIN"
  exit 1
else
  echo -e "entered environment name is - ${env}" 
fi

read -p "Please provide the vnet Name in 30 seconds: " -t 30 vnetname

if [ -z "$vnetname" ]; then
  echo -e "\nyou have not provided the input in 30 seconds \nHENCE EXITING THE EXECUTION RERUN THE SCRIPT AGAIN"
  exit 1
else
  echo -e "entered hub vnet name is - ${vnetname}" 
fi

read -p "Please provide the vnet region in 30 seconds: " -t 30 vnetregion

if [ -z "$vnetregion" ]; then
  echo -e "\nyou have not provided the input in 30 seconds \nHENCE EXITING THE EXECUTION RERUN THE SCRIPT AGAIN"
  exit 1
else
  echo -e "entered hub vnet region is - ${vnetregion}" 
fi

# checking whether user has entered the valid region or not

result=$(az account list-locations --query "[].{Name:name}" -o yaml | cut -d : -f 2 | grep -w ${vnetregion} | wc -l)

if [ $result -eq 0 ];then
  echo -e "\nYou have entered $vnetregion which is NOT A VALID Azure region. Hence enter the valide region for resource groups\nyou can list the valid region name with the following command\n\n     az account list-locations --query "[].{Name:name}" -o yaml | cut -d : -f 2"
  exit 1
else
  echo "entered the valid region"
fi

read -p "Please provide the private address prefixes in 30 seconds: " -t 30 addressprefix

if [ -z "$addressprefix" ]; then
  echo -e "\nyou have not provided the input in 30 seconds \nHENCE EXITING THE EXECUTION RERUN THE SCRIPT AGAIN"
  exit 1
else
  echo -e "entered hub vnet name is - ${addressprefix}" 
fi

read -p "Please provide the resource group Name in 30 seconds: " -t 30 rgname

if [ -z "$rgname" ]; then
  echo -e "\nyou have not provided the input in 30 seconds \nHENCE EXITING THE EXECUTION RERUN THE SCRIPT AGAIN"
  exit 1
else
  echo -e "entered hub vnet name is - ${rgname}" 
fi

# Checking the resource group already exists or not
rgresult=$(az group exists -n ${rgname})

#echo $rgresult

if $rgresult;then
  echo "creating the vnet"
  az network vnet create -n ${env}-${vnetname} -l ${vnetregion} -g ${rgname} --address-prefixes ${addressprefix}
else
  echo "resource group does not exists hence stopping the execution, please rerun the script"
  exit 1
fi