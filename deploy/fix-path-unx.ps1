sed -i 's/ROOT_DIR/\/u01/g' deploy.ps1
sed -i '1s/^/export NLS_LANG\=AMERICAN_AMERICA.AR8MSWIN1256\n/' deploy.ps1