[ -d $CONFDIR ] || mkdir -p $CONFDIR
cat $TEMPLATE > $CONFDIR/$CONFFILE.conf
#Générer le template toi même

sed -i "s@nom_de_domaine@$CONFFILE.local/g" $CONFFILE.conf
sed -i "s@racine_projet@$WEBDIR/$project_path@g" $CONFFILE.conf
echo "Nous venons de configurer le fichier, nous allons à
présent activer le site et redémarrer le serveur"
#a2ensite $domain_name.conf
#a2dissite 000-default.conf
#systemctl restart apache2
#Vérifier après l'état des services afin de pouvoir avertir
#le user en cas de problème...
#echo "Configuration des droits des dossiers..."
#chmod -R 755 /var/www