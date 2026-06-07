import psutil
import sys
import os


# @app.get("/health")
def get_system_metrics() :
    cpu_per = psutil.cpu_percent(interval=1)
    print("CPU utilisation is : ",cpu_per)
    disk_usage_per = psutil.disk_usage("C:")[3]
    print("Disk utilisation is : ",disk_usage_per)
    mem_usage_per = psutil.virtual_memory()[2]
    print("RAM utilisation is : ",mem_usage_per)
    
    cpu_threshold = 50
    mem_th = 60
    disk_th = 70
    
    cpu_status = "Healthy" if cpu_per <= cpu_threshold else "High CPU"
    disk_status = "Healthy" if disk_usage_per <= disk_th  else "High Disk Usage"
    mem_status = "Healthy" if mem_usage_per <= mem_th  else "High RAM Usage"
   
    if cpu_status == "Healthy" and disk_status == "Healthy" and mem_status == "Healthy":
        status = "healthy"
    else:
        status = "unhealthy"
        
    
    return {
        "CPU utilisation is": cpu_per,
        "Disk utilisation is": disk_usage_per,
        "RAM utilisation is": mem_usage_per,
        "CPU Status": cpu_status,
        "Disk Status": disk_status,
        "RAM Status": mem_status,
        "Threshold values (CPU,DISK,RAM)": [cpu_threshold,disk_th,mem_th],
        "Status": status
    }
if __name__ == "__main__":
    get_system_metrics()
