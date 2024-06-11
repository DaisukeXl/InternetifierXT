#!/system/bin/sh
MODDIR=${0%/*}

# --- Functions ---

print_modname() {
  ui_print " "
  ui_print "        Internetifier             "  
  ui_print "            By: Daisuke $MODVER  "
  ui_print " "
}

# --- Network Tweaks ---
print_modname()
ui_print "- Applying aggressive network tweaks..."

# TCP Buffer Sizes (Very aggressive for high-speed networks and 12GB RAM)
echo "1048576,2097152,4194304,524288,1048576,2097152" > /proc/sys/net/ipv4/tcp_rmem 
echo "1048576,2097152,4194304,524288,1048576,2097152" > /proc/sys/net/ipv4/tcp_wmem 

# TCP Congestion Control Algorithm (Choose the most aggressive option)
#echo "bbr" > /proc/sys/net/ipv4/tcp_congestion_control  # BBR is generally a good choice
echo "cubic" > /proc/sys/net/ipv4/tcp_congestion_control  # Cubic can be more aggressive in some cases
# Alternative options: reno, htcp, vegas

# Network Stack Tweaks (Increase responsiveness)
echo "1" > /proc/sys/net/ipv4/tcp_low_latency     # Prioritize low latency over throughput
echo "0" > /proc/sys/net/ipv4/tcp_timestamps      # Disable TCP timestamps (can reduce overhead)
echo "2" > /proc/sys/net/ipv4/tcp_syn_retries     # Reduce SYN retransmission attempts for faster connections
echo "20" > /proc/sys/net/ipv4/tcp_fin_timeout    # Reduce TIME_WAIT state duration for faster connection recycling

# Increase Maximum Network Connections
echo "131072" > /proc/sys/net/core/netdev_max_backlog  # Double the default value

# --- DNS Optimization ---
ui_print "- Optimizing DNS..."

# Set DNS Servers (Choose the fastest and most reliable servers for your location)
setprop net.dns1 1.1.1.1
setprop net.dns2 1.0.0.1
# Consider using a local DNS resolver or a VPN with a fast DNS service for even better performance

# --- Additional Aggressive Tweaks ---
ui_print "- Applying additional aggressive tweaks..."

# Increase TCP Maximum Segment Size (MSS) for larger packets
iptables -t mangle -A POSTROUTING -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1460

# Prioritize Network Traffic for Gaming Apps (Requires iptables and knowledge of UIDs)
# Replace <GAME_APP_UID> with the actual UID of the game you want to prioritize
#iptables -t mangle -A POSTROUTING -m owner --uid-owner <GAME_APP_UID> -j CLASSIFY --set-class interactive

# Disable Nagle's Algorithm for faster response times (can increase packet overhead)
#echo "1" > /proc/sys/net/ipv4/tcp_no_delay  

ui_print "- Done"