# In the windows feature installation dialog,  install the two components called “Hyper-V-Services” and “Hyper-V-Module for Windows powershell”
# reboot the computer.

# This will return a list of network adapters, find your physical NIC and note its "Name" - In most cases "Ethernet"
Get-NetAdapter

# This creates a new vSwitch named VLAN-vSwitch and bridging our physical NIC called "Ethernet". Also we allow to add virtual Host-NICs to this switch.
New-VMSwitch -name VLAN-vSwitch -NetAdapterName Ethernet -AllowManagementOS $true

# Hyper-V automatically creates a virtual NIC without a VLAN tag to keep the host online - Remove it, except you are using a Untagged/Tagged combination.
Remove-VMNetworkAdapter -ManagementOS -Name VLAN-vSwitch

# Now we create a new virtual Host-NIC and assign a VLAN tag 123 to it. Please note, that the interface name can be chosen freely. One might want to name them by purpose.
Add-VMNetworkAdapter -ManagementOS -Name "VLAN123" -SwitchName "VLAN-vSwitch" -Passthru | Set-VMNetworkAdapterVlan -Access -VlanId 123

# You can now add as many virtual NICs as you need
Add-VMNetworkAdapter -ManagementOS -Name "VLAN456" -SwitchName "VLAN-vSwitch" -Passthru | Set-VMNetworkAdapterVlan -Access -VlanId 456

# Finally, verify that all adapter are in place
Get-NetAdapter
Get-VMNetworkAdapterVlan -ManagementOS

Set-VMNetworkAdapterVlan -ManagementOS -VMNetworkAdapterName "VLAN123" -Access -VlanId 123
Set-VMNetworkAdapterVlan -ManagementOS -VMNetworkAdapterName "VLAN456" -Access -VlanId 456
