#!/system/bin/sh

SKIPMOUNT=false
PROPFILE=true
POSTFSDATA=true
LATESTARTSERVICE=true

sleep 3

ui_print "                                   "      
ui_print "          internetifier                         "      
ui_print "                                   "      
ui_print "            By: Daisuke $MODVER        "
ui_print " "
ui_print "- Phone Model: $(getprop ro.product.model) "
ui_print "- System Version: Android $(getprop ro.system.build.version.release) "
ui_print "- System Structure: $ARCH "
ui_print "- build type: SPECIAL"
sleep 1

set_permissions() {
set_perm_recursive $MODPATH/config 0 0 0755 0755
set_perm_recursive $MODPATH/system/* 0 0 0755 0755
set_perm_recursive "$MODPATH/system/bin" 0 0 0755 0755
}
ui_print "              "
