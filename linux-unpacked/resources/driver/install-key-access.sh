#!/bin/sh
# SkolAR Labs - one-time setup so a normal (non-root) user can use the HYP2003 USB key.
# Run once as root, BEFORE plugging the key in:   sudo sh install-key-access.sh
set -e
if [ "$(id -u)" != "0" ]; then echo "Please run as root:  sudo sh $0"; exit 1; fi

cat > /etc/udev/rules.d/70-skolar-hyp2003.rules <<'EOF'
# Hypersecu HYP2003 / ePass2003 USB tokens
SUBSYSTEM=="usb", ATTR{idVendor}=="2ccf", MODE="0666"
SUBSYSTEM=="usb", ATTR{idVendor}=="096e", MODE="0666"
EOF

if command -v udevadm >/dev/null 2>&1; then
  udevadm control --reload-rules && udevadm trigger
fi
echo "Done. Now plug in the key."
echo "Note: this driver talks to the key directly over USB. If the key is not found, stop the smart-card service:"
echo "      sudo systemctl stop pcscd pcscd.socket"
