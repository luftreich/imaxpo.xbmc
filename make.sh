echo
cat src/repository.imaxpo/addon.xml | head -n5
echo '....'
echo -n '<!> 确认repo已经更新 ?? [Y/n] '
read LUFT
[ "$LUFT" = "Y" -o "$LUFT" = "y" ] && {
    python addons_xml_and_zipfile_generator.py 
}
