---
layout:     default
title:      macOS Cmdline Network Settings
date:       2021-12-03
editdate:   2021-12-03
categories: MacAdmin Networking
disqus_id:  macos-cmdline-network-settings.html
---

macOS command line network Settings

## networksetup

See the [man page](https://www.unix.com/man-page/OSX/8/networksetup/)

	sudo networksetup -setairportpower en1 off 	

This is its usage (as of macOS 11 Big Sur).

```
networksetup Help Information
-------------------------------
Usage: networksetup -listnetworkserviceorder
	Display services with corresponding port and device in order they are tried for connecting
	to a network. An asterisk (*) denotes that a service is disabled.

Usage: networksetup -listallnetworkservices
	Display list of services. An asterisk (*) denotes that a network service is disabled.

Usage: networksetup -listallhardwareports
	Display list of hardware ports with corresponding device name and ethernet address.

Usage: networksetup -detectnewhardware
	Detect new network hardware and create a default network service on the hardware.

Usage: networksetup -getmacaddress <hardwareport or device name>
	Display ethernet (or Wi-Fi) address for hardwareport or device specified.

Usage: networksetup -getcomputername
	Display the computer name.

Usage: networksetup -setcomputername <name>
	Set the computer's name (if valid) to <name>.

Usage: networksetup -getinfo <networkservice>
	Display IPv4 address, IPv6 address, subnet mask,
	router address, ethernet address for <networkservice>.

Usage: networksetup -setmanual <networkservice> <ip> <subnet> <router>
	Set the <networkservice> TCP/IP configuration to manual with IP address set to ip,
	Subnet Mask set to subnet, and Router address set to router.

Usage: networksetup -setdhcp <networkservice> [clientid]
	Set the <networkservice> TCP/IP configuration to DHCP. You can set the
 	DHCP client id to the optional [clientid]. Specify "Empty" for [clientid]
	to clear the DHCP client id.

Usage: networksetup -setbootp <networkservice>
	Set the <networkservice> TCP/IP configuration to BOOTP.

Usage: networksetup -setmanualwithdhcprouter <networkservice> <ip>
	Set the <networkservice> TCP/IP configuration to manual with DHCP router with IP address set
	to ip.

Usage: networksetup -getadditionalroutes <networkservice>
	Get additional IPv4 routes associated with <networkservice>
Usage: networksetup -setadditionalroutes <networkservice> [ <dest> <mask> <gateway> ]*
	Set additional IPv4 routes associated with <networkservice>
	by specifying one or more [ <dest> <mask> <gateway> ] tuples.
	Remove additional routes by specifying no arguments.
	If <gateway> is "", the route is direct to the interface
Usage: networksetup -setv4off <networkservice>
	Turn IPv4 off on <networkservice>.

Usage: networksetup -setv6off <networkservice>
	Turn IPv6 off on <networkservice>.

Usage: networksetup -setv6automatic <networkservice>
	Set the service to get its IPv6 info automatically.

Usage: networksetup -setv6LinkLocal <networkservice>
	Set the service to use its IPv6 only for link local.

Usage: networksetup -setv6manual <networkservice> <address> <prefixlength> <router>
	Set the service to get its IPv6 info manually.
	Specify <address> <prefixLength> and <router>.

Usage: networksetup -getv6additionalroutes <networkservice>
	Get additional IPv6 routes associated with <networkservice>
Usage: networksetup -setv6additionalroutes <networkservice> [ <dest> <prefixlength> <gateway> ]*
	Set additional IPv6 routes associated with <networkservice>
	by specifying one or more [ <dest> <prefixlength> <gateway> ] tuples.
	Remove additional routes by specifying no arguments.
	If <gateway> is "", the route is direct to the interface
Usage: networksetup -getdnsservers <networkservice>
	Display DNS info for <networkservice>.

Usage: networksetup -setdnsservers <networkservice> <dns1> [dns2] [...]
	Set the <networkservice> DNS servers to <dns1> [dns2] [...]. Any number of dns servers can be
	specified. Specify "Empty" for <dns1> to clear all DNS entries.

Usage: networksetup -getsearchdomains <networkservice>
	Display Domain Name info for <networkservice>.

Usage: networksetup -setsearchdomains <networkservice> <domain1> [domain2] [...]
	Set the <networkservice> Domain Name servers to <domain1> [domain2] [...]. Any number of Domain Name
 	servers can be specified. Specify "Empty" for <domain1> to clear all Domain Name entries.

Usage: networksetup -create6to4service <newnetworkservicename>
	Create a 6 to 4 service with name <newnetworkservicename>.

Usage: networksetup -set6to4automatic <networkservice>
	Set the service to get its 6 to 4 info automatically.

Usage: networksetup -set6to4manual <networkservice> <relayaddress>
	Set the service to get its 6 to 4 info manually.
	Specify <relayaddress> for the relay address.

Usage: networksetup -getftpproxy <networkservice>
	Display FTP proxy (server, port, enabled value) info for <networkservice>.

Usage: networksetup -setftpproxy <networkservice> <domain> <port number> <authenticated> <username> <password>
	Set FTP proxy for <networkservice> with <domain> and <port number>. Turns proxy on. Optionally, specify <on> or <off> for <authenticated> to enable and disable authenticated proxy support. Specify <username> and <password> if you turn authenticated proxy support on.

Usage: networksetup -setftpproxystate <networkservice> <on off>
	Set FTP proxy to  either <on> or <off>.

Usage: networksetup -getwebproxy <networkservice>
	Display Web proxy (server, port, enabled value) info for <networkservice>.

Usage: networksetup -setwebproxy <networkservice> <domain> <port number> <authenticated> <username> <password>
	Set Web proxy for <networkservice> with <domain> and <port number>. Turns proxy on. Optionally, specify <on> or <off> for <authenticated> to enable and disable authenticated proxy support. Specify <username> and <password> if you turn authenticated proxy support on.

Usage: networksetup -setwebproxystate <networkservice> <on off>
	Set Web proxy to  either <on> or <off>.

Usage: networksetup -getsecurewebproxy <networkservice>
	Display Secure Web proxy (server, port, enabled value) info for <networkservice>.

Usage: networksetup -setsecurewebproxy <networkservice> <domain> <port number> <authenticated> <username> <password>
	Set Secure Web proxy for <networkservice> with <domain> and <port number>. Turns proxy on. Optionally, specify <on> or <off> for <authenticated> to enable and disable authenticated proxy support. Specify <username> and <password> if you turn authenticated proxy support on.

Usage: networksetup -setsecurewebproxystate <networkservice> <on off>
	Set SecureWeb proxy to  either <on> or <off>.

Usage: networksetup -getstreamingproxy <networkservice>
	Display Streaming proxy (server, port, enabled value) info for <networkservice>.

Usage: networksetup -setstreamingproxy <networkservice> <domain> <port number> <authenticated> <username> <password>
	Set Streaming proxy for <networkservice> with <domain> and <port number>. Turns proxy on. Optionally, specify <on> or <off> for <authenticated> to enable and disable authenticated proxy support. Specify <username> and <password> if you turn authenticated proxy support on.

Usage: networksetup -setstreamingproxystate <networkservice> <on off>
	Set Streaming proxy to  either <on> or <off>.

Usage: networksetup -getgopherproxy <networkservice>
	Display Gopher proxy (server, port, enabled value) info for <networkservice>.

Usage: networksetup -setgopherproxy <networkservice> <domain> <port number> <authenticated> <username> <password>
	Set Gopher proxy for <networkservice> with <domain> and <port number>. Turns proxy on. Optionally, specify <on> or <off> for <authenticated> to enable and disable authenticated proxy support. Specify <username> and <password> if you turn authenticated proxy support on.

Usage: networksetup -setgopherproxystate <networkservice> <on off>
	Set Gopher proxy to  either <on> or <off>.

Usage: networksetup -getsocksfirewallproxy <networkservice>
	Display SOCKS Firewall proxy (server, port, enabled value) info for <networkservice>.

Usage: networksetup -setsocksfirewallproxy <networkservice> <domain> <port number> <authenticated> <username> <password>
	Set SOCKS Firewall proxy for <networkservice> with <domain> and <port number>. Turns proxy on. Optionally, specify <on> or <off> for <authenticated> to enable and disable authenticated proxy support. Specify <username> and <password> if you turn authenticated proxy support on.

Usage: networksetup -setsocksfirewallproxystate <networkservice> <on off>
	Set SOCKS Firewall proxy to  either <on> or <off>.

Usage: networksetup -getproxybypassdomains <networkservice>
	Display Bypass Domain Names for <networkservice>.

Usage: networksetup -setproxybypassdomains <networkservice> <domain1> [domain2] [...]
	Set the Bypass Domain Name Servers for <networkservice> to <domain1> [domain2] [...]. Any number of
	Domain Name servers can be specified. Specify "Empty" for <domain1> to clear all
	Domain Name entries.

Usage: networksetup -getproxyautodiscovery <networkservice>
	Display whether Proxy Auto Discover is on or off for <network service>.

Usage: networksetup -setproxyautodiscovery <networkservice> <on off>
	Set Proxy Auto Discovery to either <on> or <off>.

Usage: networksetup -getpassiveftp <networkservice>
	Display whether Passive FTP is on or off for <networkservice>.

Usage: networksetup -setpassiveftp <networkservice> <on off>
	Set Passive FTP to either <on> or <off>.

Usage: networksetup -setautoproxyurl <networkservice> <url>
	Set proxy auto-config to url for <networkservice> and enable it.

Usage: networksetup -getautoproxyurl <networkservice>
	Display proxy auto-config (url, enabled) info for <networkservice>.

Usage: networksetup -setautoproxystate <networkservice> <on off>
	Set proxy auto-config to either <on> or <off>.

Usage: networksetup -getairportnetwork <device name>
	Display current Wi-Fi Network for <device name>.

Usage: networksetup -setairportnetwork <device name> <network> [password]
	Set Wi-Fi Network to <network> for <device name>.
	If a password is included, it gets stored in the keychain.

Usage: networksetup -getairportpower <device name>
	Display whether Wi-Fi power is on or off for <device name>.

Usage: networksetup -setairportpower <device name> <on off>
	Set Wi-Fi power for <device name> to either <on> or <off>.

Usage: networksetup -listpreferredwirelessnetworks <device name>
	List the preferred wireless networks for <device name>.

Usage: networksetup -addpreferredwirelessnetworkatindex <device name> <network> <index> <security type> [password]
	Add wireless network named <network> to preferred list for <device name> at <index>.
	For security type, use OPEN for none, WPA for WPA Personal, WPAE for WPA Enterprise,
	WPA2 for WPA2 Personal, WPA2E for WPA2 Enterprise, WEP for plain WEP, and 8021XWEP for 802.1X WEP.
	If a password is included, it gets stored in the keychain.

Usage: networksetup -removepreferredwirelessnetwork <device name> <network>
	Remove <network> from the preferred wireless network list for <device name>.

Usage: networksetup -removeallpreferredwirelessnetworks <device name>
	Remove all networks from the preferred wireless network list for <device name>.

Usage: networksetup -getnetworkserviceenabled <networkservice>
	Display whether a service is on or off (enabled or disabled).

Usage: networksetup -setnetworkserviceenabled <networkservice> <on off>
	Set <networkservice> to either <on> or <off> (enabled or disabled).

Usage: networksetup -createnetworkservice <newnetworkservicename> <hardwareport>
	Create a service named <networkservice> on port <hardwareport>. The new service will be enabled by default.

Usage: networksetup -renamenetworkservice <networkservice> <newnetworkservicename>
	Rename <networkservice> to <newnetworkservicename>.

Usage: networksetup -duplicatenetworkservice <networkservice> <newnetworkservicename>
	Duplicate <networkservice> and name it with <newnetworkservicename>.

Usage: networksetup -removenetworkservice <networkservice>
	Remove the service named <networkservice>. Will fail if this is the only service on the hardware port that <networkservice> is on.

Usage: networksetup -ordernetworkservices <service1> <service2> <service3> <...>
	Order the services in order specified. Use "-listnetworkserviceorder" to view service order.
	Note: use quotes around service names which contain spaces (ie. "Built-in Ethernet").

Usage: networksetup -setMTUAndMediaAutomatically <hardwareport or device name>
	Set hardwareport or device specified back to automatically setting the MTU and Media.

Usage: networksetup -getMTU <hardwareport or device name>
	Get the MTU value for hardwareport or device specified.

Usage: networksetup -setMTU <hardwareport or device name> <value>
	Set MTU for hardwareport or device specified.

Usage: networksetup -listvalidMTUrange <hardwareport or device name>
	List the valid MTU range for hardwareport or device specified.

Usage: networksetup -getmedia <hardwareport or device name>
	Show both the current setting for media and the active media on hardwareport or device specified.

Usage: networksetup -setmedia <hardwareport or device name> <subtype> [option1] [option2] [...]
	Set media for hardwareport or device specified to subtype. Specify optional [option1] and additional options depending on subtype. Any number of valid options can be specified.

Usage: networksetup -listvalidmedia <hardwareport or device name>
 	List valid media options for hardwareport or device name. Enumerates available subtypes and options per subtype.

Usage: networksetup -createVLAN <VLAN name> <device name> <tag>
	Create a VLAN with name <VLAN name> over device <device name> with unique tag <tag>. A default network service will be created over the VLAN.

Usage: networksetup -deleteVLAN <VLAN name> <device name> <tag>
	Delete the VLAN with name <VLAN name> over the parent device <device name> with unique tag <tag>. If there are network services running over the VLAN they will be deleted.

Usage: networksetup -listVLANs
	List the VLANs that have been created.

Usage: networksetup -listdevicesthatsupportVLAN
	List the devices that support VLANs.

Usage: networksetup -isBondSupported <device name ie., en0>
	Return YES if the specified device can be added to a bond. NO if it cannot.

Usage: networksetup -createBond <user defined name> <device name 1> <device name 2> <...>
	Create a new bond and give it the user defined name. Add the specified devices, if any, to the bond.

Usage: networksetup -deleteBond <bond name ie., bond0>
	Delete the bond with the specified device-name.

Usage: networksetup -addDeviceToBond <device name> <bond name>
	Add the specified device to the specified bond.

Usage: networksetup -removeDeviceFromBond <device name> <bond name>
	Remove the specified device from the specified bond

Usage: networksetup -listBonds
	List all of the bonds.

Usage: networksetup -showBondStatus <bond name ie., bond0>
	Display the status of the specified bond.

Usage: networksetup -listpppoeservices
	List all of the PPPoE services in the current set.

Usage: networksetup -showpppoestatus <service name ie., MyPPPoEService>
	Display the status of the specified PPPoE service.

Usage: networksetup -createpppoeservice <device name ie., en0> <service name> <account name> <password> [pppoe service name]
	Create a PPPoE service on the specified device with the service name specified.
	The "pppoe service name" is optional and may not be supported by the service provider.

Usage: networksetup -deletepppoeservice <service name>
	Delete the PPPoE service.

Usage: networksetup -setpppoeaccountname <service name> <account name>
	Sets the account name for the specified service.

Usage: networksetup -setpppoepassword <service name> <password>
	Sets the password stored in the keychain for the specified service.

Usage: networksetup -connectpppoeservice <service name>
	Connect the PPPoE service.

Usage: networksetup -disconnectpppoeservice <service name>
	Disconnect the PPPoE service.

Usage: networksetup -getcurrentlocation
	Display the name of the current location.

Usage: networksetup -listlocations
	List all of the locations.

Usage: networksetup -createlocation <location name> [populate]
	Create a new network location with the spcified name.
	If the optional term "populate" is included, the location will be populated with the default services.

Usage: networksetup -deletelocation <location name>
	Delete the location.

Usage: networksetup -switchtolocation <location name>
	Make the specified location the current location.

Usage: networksetup -version
	Display version of networksetup tool.

Usage: networksetup -help
	Display these help listings.

Usage: networksetup -printcommands
	Displays a quick listing of commands (without explanations).

Any command that takes a password, will accept - to indicate the password should be read from stdin.

The networksetup tool requires at least admin privileges to change network settings. If the "Require an administrator password to access system-wide preferences" option is selected in System Preferences > Security & Privacy, then root privileges are required to change network settings.
```

## airport

Located at: /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport

### Usage

This is its usage (as of macOS 11 Big Sur).

```
Usage: airport <interface> <verb> <options>

	<interface>
	If an interface is not specified, airport will use the first AirPort interface on the system.

	<verb is one of the following:
	prefs	If specified with no key value pairs, displays a subset of AirPort preferences for
		the specified interface.

		Preferences may be configured using key=value syntax. Keys and possible values are specified below.
		Boolean settings may be configured using 'YES' and 'NO'.

		DisconnectOnLogout (Boolean)
		JoinMode (String)
			Automatic
			Preferred
			Ranked
			Recent
			Strongest
		JoinModeFallback (String)
			Prompt
			JoinOpen
			KeepLooking
			DoNothing
		RememberRecentNetworks (Boolean)
		RequireAdmin (Boolean)
		RequireAdminIBSS (Boolean)
		RequireAdminNetworkChange (Boolean)
		RequireAdminPowerToggle (Boolean)
       AllowLegacyNetworks (Boolean)
		WoWEnabled (Boolean)

	logger	Monitor the driver's logging facility.

	sniff	If a channel number is specified, airportd will attempt to configure the interface
		to use that channel before it begins sniffing 802.11 frames. Captures files are saved to /tmp.
		Requires super user privileges.

	debug	Enable debug logging. A debug log setting may be enabled by prefixing it with a '+', and disabled
		by prefixing it with a '-'.

		AirPort Userland Debug Flags
			DriverDiscovery
			DriverEvent
			Info
			SystemConfiguration
			UserEvent
			PreferredNetworks
			AutoJoin
			IPC
			Scan
			802.1x
			Assoc
			Keychain
			RSNAuth
			WoW
			P2P
			Roam
			BTCoex
			AllUserland - Enable/Disable all userland debug flags

		AirPort Driver Common Flags
			DriverInfo
			DriverError
			DriverWPA
			DriverScan
			AllDriver - Enable/Disable all driver debug flags

		AirPort Driver Vendor Flags
			VendorAssoc
			VendorConnection
			AllVendor - Enable/Disable all vendor debug flags

		AirPort Global Flags
			LogFile - Save all AirPort logs to /var/log/wifi.log

<options> is one of the following:
	No options currently defined.

Examples:

Configuring preferences (requires admin privileges)
	sudo airport en1 prefs JoinMode=Preferred RememberRecentNetworks=NO RequireAdmin=YES

Sniffing on channel 1:
	airport en1 sniff 1


LEGACY COMMANDS:
Supported arguments:
 -c[<arg>] --channel=[<arg>]    Set arbitrary channel on the card
 -z        --disassociate       Disassociate from any network
 -I        --getinfo            Print current wireless status, e.g. signal info, BSSID, port type etc.
 -s[<arg>] --scan=[<arg>]       Perform a wireless broadcast scan.
				   Will perform a directed scan if the optional <arg> is provided
 -x        --xml                Print info as XML
 -P        --psk                Create PSK from specified pass phrase and SSID.
				   The following additional arguments must be specified with this command:
                                  --password=<arg>  Specify a WPA password
                                  --ssid=<arg>      Specify SSID when creating a PSK
 -h        --help               Show this help
 ```


	sudo airport en1 prefs RequireAdmin=YES

### Examples

Require password to change airport settings.

	/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport prefs RequireAdminIBSS=YES
	/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport prefs RequireAdminNetworkChange=YES
	/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport prefs RequireAdminPowerToggle=YES

See [serverfault](https://serverfault.com/questions/367386/os-x-wifi-settings-via-terminal).
