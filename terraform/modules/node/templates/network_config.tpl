ethernets:
    ${interface_1}:
        addresses: 
        - ${ip_addr_1}/24
        dhcp4: false
        gateway4: 192.168.122.1
        match:
            macaddress: ${mac_addr_1}
        nameservers:
            addresses: 
            - 1.1.1.1
            - 8.8.8.8
        set-name: ${interface_1}
    ${interface_2}:
        addresses: 
        - ${ip_addr_2}/24
        dhcp4: false
        gateway4: 192.168.122.1
        match:
            macaddress: ${mac_addr_2}
        nameservers:
            addresses: 
            - 1.1.1.1
            - 8.8.8.8
        set-name: ${interface_2}
version: 2
