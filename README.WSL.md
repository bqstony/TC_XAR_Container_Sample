# USE tc31-xar-base-opc OCI image for WSL2
## 1. Setup WSL

> The empty sample and soft-RT dev workloads run without any hugepages reserved. Only real PLC projects with a non-zero LockedMemSize (EtherCAT master, large router memory) need hugetlbfs-backed memory in the WSL kernel — in that case make the allocation persistent across Docker Desktop / host restarts by adding the kernel boot parameters to

In `%UserProfile%\.wslconfig` set (requires restart of WSL distros):

```ini
[wsl2]
memory=10GB
guiApplications=true
kernelCommandLine=default_hugepagesz=2M hugepagesz=2M hugepages=1024
```

## 2. Setup Twincat ADS-over-MQTT

To connect your TwinCAT Engineering system via ADS-over-MQTT with the containerized TwinCAT runtime use the following template.
Copy the content to: `C:\Program Files (x86)\Beckhoff\TwinCAT\3.1\Target\Routes\mqtt.xml`

**Config of mqtt.xml when using WSL2:**
```
<?xml version="1.0" encoding="utf-8"?>
<TcConfig xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.beckhoff.com/schemas/2015/12/TcConfig">
<RemoteConnections>
    <Mqtt Unidirectional="true">
        <Address Port="1883">127.0.0.1</Address>
        <Topic>AdsOverMqtt</Topic>
    </Mqtt>
</RemoteConnections>
</TcConfig>
```

In TwinCAT Engineering, open the "Target Systems" view, the Container `Um - tc31-xar-base-opc` should appear as an available target system when the container is running.

## 3. Starting the compose

podman compose -f docker-compose.wsl.yaml up -d 

podman compose -f docker-compose.wsl.yaml down


# 4 Connect OPC Server

The first time connection the server requires TOFU (Trust On First Use) confirmation. For this connect with Anonymous credentials and confirm the security prompt.

- **UaServer URL**: opc.tcp://127.0.0.1:4840


> Optional:
> Copy setup opc config files to local mount folder:
> ```powershell
> podman cp tc31-xar-base-opc:/etc/TwinCAT/Functions/TF6100-OPC-UA/TcOpcUaServer ./tc31-xar-base-opc/tcOpcUaServer
> ```