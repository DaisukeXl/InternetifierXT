#!/system/bin/sh
MODDIR=${0%/*}

# --- Functions ---

print_modname() {
  ui_print "*****************************************"
  ui_print "          InternetifierXTX            "  #
  ui_print "*****************************************"
}

abort_with_error() {
  ui_print "$1"
  ui_print "Aborting module execution due to an error."
  exit 1
}

# Function to check if a file exists and is not empty
file_exists_and_not_empty() {
  local file_path="$1"
  [ -s "$file_path" ]  # -s checks if the file exists and has a size greater than zero
}

# --- Main Customization ---

print_modname()

ui_print "- Starting customization..."

# Check if required files exist
required_files=(
  "/system/vendor/build.prop"
  "/system/build.prop"
)

for file in "${required_files[@]}"; do
  if ! file_exists_and_not_empty "$file"; then
    abort_with_error "Error: Required file '$file' not found or empty."
  fi
done

# Backup build.prop files
ui_print "  - Backing up build.prop files..."
cp -f "/system/vendor/build.prop" "/system/vendor/build.prop.bak" || abort_with_error "Failed to backup /system/vendor/build.prop"
cp -f "/system/build.prop" "/system/build.prop.bak" || abort_with_error "Failed to backup /system/build.prop"

# Apply modifications to build.prop files
ui_print "  - Applying modifications to build.prop files..."

# --- System build.prop ---
ui_print "    - Modifying /system/build.prop"

# Example modifications (replace with your actual tweaks)
sed -i 's/ro.build.type=.*/ro.build.type=userdebug/' "/system/build.prop"
sed -i 's/ro.secure=.*/ro.secure=0/' "/system/build.prop"
sed -i 's/ro.debuggable=.*/ro.debuggable=1/' "/system/build.prop"

# --- Vendor build.prop ---
ui_print "    - Modifying /system/vendor/build.prop"

# Example modifications (replace with your actual tweaks)
sed -i 's/ro.vendor.build.type=.*/ro.vendor.build.type=userdebug/' "/system/vendor/build.prop"
sed -i 's/ro.vendor.secure=.*/ro.vendor.secure=0/' "/system/vendor/build.prop"
sed -i 's/ro.vendor.debuggable=.*/ro.vendor.debuggable=1/' "/system/vendor/build.prop"

# --- Additional Customizations ---

# Add any other customization steps here

# --- Completion ---

ui_print "- Customization complete!"