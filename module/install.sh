#!/system/bin/sh
MODDIR=${0%/*}

# --- Configurazione del modulo ---

# Flags di configurazione (non modificare a meno che non si sappia cosa si sta facendo)
SKIPMOUNT=false
PROPFILE=true
POSTFSDATA=true
LATESTARTSERVICE=true

# --- Funzioni ---

# Funzione per stampare il nome del modulo
print_modname() {
    ui_print " "
    ui_print "         InternetifierXTX             "
    ui_print "         By: Daisuke $MODVER           "
    ui_print " "
}

# Funzione per impostare i permessi

# --- Inizio Installazione ---

print_modname()

# Verifica compatibilità del dispositivo (aggiungi le tue condizioni specifiche)
ui_print "- Checking device compatibility..."
ui_print "  - Phone Model: $(getprop ro.product.model)"
ui_print "  - Android Version: $(getprop ro.system.build.version.release)"
ui_print "  - Architecture: $ARCH"

# Esempio di controllo di compatibilità:
# if [ "$API" -lt 30 ]; then
#   abort "This module requires Android 11 or higher!"
# fi

# --- Azioni di Installazione ---

ui_print "- Extracting module files..."
unzip -o "$ZIPFILE" -d $MODPATH >&2

# --- Impostazione dei permessi ---

ui_print "- Setting permissions..."

# Permessi ricorsivi per la cartella config
#!/system/bin/sh

# Imposta i permessi corretti per i file del modulo
chmod 644 /system/etc/hosts
chmod 644 /system/etc/resolv.conf
chmod 644 /system/etc/ppp/ip-up

# Copia i file del modulo nelle posizioni appropriate
cp -f $MODPATH/system/etc/hosts /system/etc/hosts
cp -f $MODPATH/system/etc/resolv.conf /system/etc/resolv.conf
cp -f $MODPATH/system/etc/ppp/ip-up /system/etc/ppp/ip-up

# Riavvia i servizi di rete (se necessario)
svc wifi restart
svc data restart

# --- Fine Installazione ---

ui_print " "
ui_print "- Installation complete!"