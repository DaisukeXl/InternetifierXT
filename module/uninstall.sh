#!/system/bin/sh
MODDIR=${0%/*}

# --- Functions ---

# Print module name
print_modname() {
  ui_print "*****************************************"
  ui_print "           InternetifierXTX            "
  ui_print "*****************************************"
}

# Function to ask the user for confirmation
confirm_uninstall() {
  ui_print "Are you sure you want to uninstall Your Module Name?"
  ui_print "This will restore original internet/network settings."
  local choice
  while true; do
    ui_print "[Volume Up] - Yes [Volume Down] - No"
    read choice
    case "$choice" in
      1) return 0 ;;  # Yes
      0) ui_print "- Uninstallation cancelled." && exit 1 ;;
      *) ui_print "Invalid choice. Press Volume Up for Yes or Volume Down for No." ;;
    esac
  done
}

# --- Uninstallation ---

print_modname()
confirm_uninstall

ui_print "- Restoring internet/network settings..."

# Restore Original Files (If applicable)
if [ -f "$INFO" ]; then
  while read LINE; do
    if [ "$(echo -n "$LINE" | tail -c 1)" == "~" ]; then
      continue  # Skip backup files
    elif [ -f "$LINE~" ]; then
      ui_print "  - Restoring $LINE"
      mv -f "$LINE~" "$LINE"  # Restore backup if it exists
    else
      ui_print "  - Removing $LINE"
      rm -f "$LINE"  # Remove the module file if no backup is present
      
      # Remove empty parent directories recursively
      while true; do
        LINE=$(dirname "$LINE")
        if [ "$(ls -A "$LINE" 2>/dev/null)" ]; then
          break  # Stop if directory is not empty
        else
          rm -rf "$LINE"  # Remove the empty directory
        fi
      done
    fi
  done < "$INFO"
  rm -f "$INFO"  # Remove the $INFO file after processing
else
  ui_print "- $INFO file not found. It may have already been uninstalled."
fi

ui_print "- Uninstallation complete!"
exit 0
