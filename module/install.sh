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
    ui_print "        Internetifier             "
    ui_print "            By: Daisuke $MODVER  "
    ui_print " "
}

# --- Inizio Installazione ---

print_modname()  # Mostra informazioni sul modulo

# Verifica compatibilità del dispositivo (opzionale, ma consigliata)
ui_print "- Controllo compatibilità dispositivo..."
ui_print "  - Modello telefono: $(getprop ro.product.model)"
ui_print "  - Versione Android: $(getprop ro.system.build.version.release)"
ui_print "  - Architettura: $ARCH"

# Esempio di controllo di compatibilità:
# if [ "$API" -lt 30 ]; then
#   abort "Questo modulo richiede Android 11 o superiore!"
# fi

# --- Azioni di Installazione ---

ui_print "- Estrazione dei file del modulo..."
unzip -o "$ZIPFILE" -d $MODPATH >&2  # Estrai i file del modulo nella directory $MODPATH

# --- Impostazione dei permessi ---

set_permissions() {
    ui_print "- Impostazione dei permessi..."
    # Permessi ricorsivi per la cartella config
    set_perm_recursive $MODPATH/config 0 0 0755 0755

    # Permessi ricorsivi per tutti i file e le cartelle in /system
    set_perm_recursive $MODPATH/system/* 0 0 0755 0644

    # Permessi specifici per la cartella /system/bin
    set_perm_recursive $MODPATH/system/bin 0 0 0755 0755

    # Aggiungi qui altri permessi specifici per file o cartelle, se necessario
    # Esempio:
    # set_perm $MODPATH/system/etc/hosts 0 0 0644  # Permessi di sola lettura per il file hosts
}

# --- Fine Installazione ---

ui_print " "
ui_print "- Installazione completata!"