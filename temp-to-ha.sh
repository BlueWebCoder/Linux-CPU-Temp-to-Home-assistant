#!/bin/bash

# Home Assistant Settings
url_base="http://192.168.1.174:8123/api/states"
token="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiIxYjlkYzk4NTgwMmU0YTEyYmM3MjA1NDVhMDQ5OTk1OSIsImlhdCI6MTcyODcyNjk3NiwiZXhwIjoyMDQ0MDg2OTc2fQ.pybY_TOIwj>

# Server name
srv_name="proxmox"

# Constants for device info
DEVICE_IDENTIFIERS='["n100_server"]'
DEVICE_NAME="Intel N100"
DEVICE_MANUFACTURER="AC8-N"
DEVICE_MODEL="N100 16 512"


# Function to send data to Home Assistant
send_to_ha() {
  local sensor_name=$1
  local temperature=$2
  local friendly_name=$3
  local icon=$4
  local unique_id=$5

  local url="${url_base}/${sensor_name}"
  local device_info="{\"identifiers\":${DEVICE_IDENTIFIERS},\"name\":\"${DEVICE_NAME}\",\"manufacturer\":\"${DEVICE_MANUFACTURER}\",\"model\":\"${DEVICE_MODE>
  local payload="{\"state\":\"${temperature}\",\"attributes\": {\"friendly_name\":\"${friendly_name}\",\"icon\":\"${icon}\",\"state_class\":\"measurement\",\>
  
  curl -X POST -H "Authorization: Bearer ${token}" -H 'Content-type: application/json' --data "${payload}" "${url}"
}
# Send CPU package temperature
cpu_temp=$(sensors | grep 'Tccd1' | awk '{print $2}' | sed 's/+//;s/°C//')
send_to_ha "sensor.${srv_name}_cpu_temperature" "${cpu_temp}" "CPU Package Temperature" "mdi:cpu-64-bit" "${srv_name}_cpu_temp"

# Send Chipset temperature (adjust device if necessary)
chipset_temp=$(sensors | grep 'temp1:' | awk '{print $2}' | sed 's/+//;s/°C//')

if [[ $chipset_temp != "" ]]; then
  send_to_ha "sensor.${srv_name}_chipset_temperature" "${chipset_temp}" "Chipset Temperature" "mdi:chip" "${srv_name}_chipset_temp"
fi

# Send NVMe/SSD composite temperature (adjust device if necessary)
nvme_temp=$(sensors | grep 'Composite' | head -1 | awk '{print $2}' | sed 's/+//;s/°C//')
if [[ $nvme_temp != "" ]]; then
  send_to_ha "sensor.${srv_name}_nvme_temperature" "${nvme_temp}" "NVMe/SSD Temperature" "mdi:harddisk" "${srv_name}_nvme_temp"
fi

# Send GPU temperature (adjust device if necessary)
gpu_temp=$(sensors | grep 'GPU Temp' | awk '{print $2}' | sed 's/+//;s/°C//')
if [[ $gpu_temp != "" ]]; then
  send_to_ha "sensor.${srv_name}_gpu_temperature" "${gpu_temp}" "GPU Temperature" "mdi:gpu" "${srv_name}_gpu_temp"
fi