#!/system/bin/sh
MODDIR=${0%/*}

# --- Functions ---
print_modname() {
    ui_print "*****************************************"
    ui_print "         InternetifierXTX             "
    ui_print "*****************************************"
}

abort_with_error() {
    ui_print "$1"
    ui_print "Aborting module execution due to an error."
    exit 1
}

file_exists_and_not_empty() {
    [ -s "$1" ] 
}

backup_file() {
    cp -f "$1" "$1.bak" || abort_with_error "Failed to backup $1"
}

apply_tweak() {
    local file="$1"
    local prop="$2"
    local new_value="$3"

    if grep -q "^$prop=" "$file"; then
        sed -i "s/^$prop=.*/$prop=$new_value/" "$file"
    else
        echo "$prop=$new_value" >> "$file"
    fi
}

set_permissions() {
    local file="$1"
    local perm="$2"
    chown $perm "$file" || abort_with_error "Failed to set permissions for $file"
    chmod $perm "$file" || abort_with_error "Failed to set permissions for $file"
}

# --- Main Customization ---
print_modname()

ui_print "- Starting customization..."

# Check for required files and create backups
for file in "/system/vendor/build.prop" "/system/build.prop" "/system/etc/init/service.sh"; do
    if ! file_exists_and_not_empty "$file"; then
        abort_with_error "Error: Required file '$file' not found or empty."
    fi
    backup_file "$file"
done

ui_print "  - Applying modifications..."

# --- System build.prop ---
apply_tweak "/system/build.prop" "ro.build.type" "userdebug"
apply_tweak "/system/build.prop" "ro.secure" "0"
apply_tweak "/system/build.prop" "ro.debuggable" "1"
# ... (add your other system build.prop tweaks here)

# --- Vendor build.prop ---
apply_tweak "/system/vendor/build.prop" "ro.vendor.build.type" "userdebug"
apply_tweak "/system/vendor/build.prop" "ro.vendor.secure" "0"
apply_tweak "/system/vendor/build.prop" "ro.vendor.debuggable" "1"
# ... (add your other vendor build.prop tweaks here)

# --- Service.sh ---
# ... (add your service.sh tweaks here)
set_permissions "/system/etc/init/service.sh" "0755" # Set permissions to rwxr-xr-x

# --- Additional Customizations ---
# ... (add any other customization steps here)

# --- Completion ---
ui_print "- Customization complete!"