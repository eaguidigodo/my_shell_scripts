[ -d $CONFDIR ] || mkdir -p $CONFDIR
cat $TEMPLATE > $CONFDIR/$domain_name.conf
#Générer le template toi même
sed -i "s/nom_de_domaine/$domain_name/g" $CONFFILE
sed -i "s/racine_projet/$WEBDIR/g" $CONFFILE
echo "Nous venons de configurer le fichier, nous allons à
présent activer le site et redémarrer le serveur"
a2ensite $domain_name.conf
a2dissite 000-default.conf
systemctl restart apache2
#Vérifier après l'état des services afin de pouvoir avertir
#le user en cas de problème...
echo "Configuration des droits des dossiers..."
chmod -R 755 /var/www