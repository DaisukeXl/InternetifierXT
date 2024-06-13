#!/system/bin/sh
MODDIR=${0%/*}

# --- Functions ---
apply_tweak() {
    local prop="$1"
    local value="$2"
    resetprop -n "$prop" "$value" 2>/dev/null
    setprop "$prop" "$value"
}

# --- Network Tweaks ---
print_modname()
ui_print "- Applying aggressive network tweaks..."

# TCP Buffer Sizes (Optimized for high-speed networks and 12GB RAM)
chmod 0666 /proc/sys/net/ipv4/tcp_rmem
chmod 0666 /proc/sys/net/ipv4/tcp_wmem
echo 1048576,2097152,4194304,524288,1048576,2097152 > /proc/sys/net/ipv4/tcp_rmem
echo 1048576,2097152,4194304,524288,1048576,2097152 > /proc/sys/net/ipv4/tcp_wmem

# TCP Congestion Control Algorithm (Choose the most aggressive option)
chmod 0666 
echo bbr > /proc/sys/net/ipv4/tcp_congestion_control
# Alternative options: cubic, reno, htcp, vegas

# Network Stack Tweaks (Increase responsiveness)
chmod 0666 /proc/sys/net/ipv4/tcp_low_latency
chmod 0666 /proc/sys/net/ipv4/tcp_timestamps
chmod 0666 /proc/sys/net/ipv4/tcp_syn_retries
chmod 0666 /proc/sys/net/ipv4/tcp_fin_timeout
echo 1 > /proc/sys/net/ipv4/tcp_low_latency
echo 0 > /proc/sys/net/ipv4/tcp_timestamps
echo 2 > /proc/sys/net/ipv4/tcp_syn_retries
echo 20 > /proc/sys/net/ipv4/tcp_fin_timeout

# Increase Maximum Network Connections
chmod 0666 /proc/sys/net/core/netdev_max_backlog
echo 131072 > /proc/sys/net/core/netdev_max_backlog

# --- DNS Optimization ---
ui_print "- Optimizing DNS..."

# Set DNS Servers (Choose the fastest and most reliable servers for your location)
setprop net.dns1 1.1.1.1
setprop net.dns2 1.0.0.1
apply_tweak net.dns1 1.1.1.1
apply_tweak net.dns2 1.0.0.1
# Alternative options: 8.8.8.8, 8.8.4.4 (Google DNS), 9.9.9.9, 149.112.112.112 (Quad9)

# --- Mobile Data Tweaks ---
ui_print "- Boosting mobile data reception..."

# Mobile Data Tweaks
apply_tweak ro.ril.telephony.mqanelements 6
apply_tweak ro.ril.enable.dtm 1
apply_tweak ro.ril.enable.a53 1
apply_tweak ro.ril.hsxpa 3
apply_tweak ro.ril.gprsclass 12
apply_tweak ro.ril.hep 1
apply_tweak ro.ril.enable.3g.prefix 1
apply_tweak ro.ril.hsdpa.category 28
apply_tweak ro.ril.enable.gea1 1
apply_tweak ro.ril.enable.af.params 1

# Force Preferred Network Type (LTE/4G/5G)
settings put global preferred_network_mode 26 # NR/LTE/GSM/WCDMA

# Disable Mobile Data Power Saving (Can increase battery drain)
settings put global data_power_saving_mode 0

# Increase Mobile Data Polling Frequency
settings put global mobile_data_always_on 1

# --- Wi-Fi Tweaks ---
ui_print "- Boosting Wi-Fi reception..."

# TCP/IP Stack Optimization (Estremo)
apply_tweak net.tcp.buffersize.default 1048576,2097152,4194304,524288,1048576,2097152
apply_tweak net.tcp.buffersize.wifi 1048576,2097152,4194304,524288,1048576,2097152
apply_tweak net.tcp.buffersize.4g 1048576,2097152,4194304,524288,1048576,2097152
apply_tweak net.tcp.buffersize.lte 1048576,2097152,4194304,524288,1048576,2097152
apply_tweak net.tcp.buffersize.5g 1048576,2097152,4194304,524288,1048576,2097152

apply_tweak net.ipv4.tcp_rmem 4096 87380 16777216
apply_tweak net.ipv4.tcp_wmem 4096 65536 16777216
apply_tweak net.ipv4.tcp_congestion_control bbr
apply_tweak net.ipv4.tcp_low_latency 1
apply_tweak net.ipv4.tcp_no_delay 1
apply_tweak net.ipv4.tcp_sack 1
apply_tweak net.ipv4.tcp_window_scaling 1
apply_tweak net.core.rmem_max 16777216
apply_tweak net.core.wmem_max 16777216
apply_tweak net.core.rmem_default 262144
apply_tweak net.core.wmem_default 262144

# Wi-Fi Tweaks
svc wifi aggressive_mode 1
settings put global wifi_sleep_policy 2
settings put global wifi_scan_interval 15000 

# --- Additional Tweaks (Experimental) ---
ui_print "- Applying experimental tweaks..."

# Force Wi-Fi Roaming Aggressiveness (Can cause instability)
settings put global wifi_roam_trigger -65

# Set Wi-Fi Country Code (Experiment with different codes)
settings put global wifi_country_code IT # Italy

# Increase TCP Maximum Segment Size (MSS) for larger packets
iptables -t mangle -A POSTROUTING -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1460

# Disable Nagle's Algorithm (Can increase packet overhead, use with caution)
echo 1 > /proc/sys/net/ipv4/tcp_no_delay