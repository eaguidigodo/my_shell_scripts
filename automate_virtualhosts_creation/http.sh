#!/bin/bash


#[ -d $CONFDIR ] || mkdir -p $CONFDIR
echo "Yo j'ai été appelé, me voici"
echo "Voici la variable template: $TEMPLATE"
cat $TEMPLATE > $CONFDIR/$CONFFILE.conf
echo "On dirait que je me bloque ici"
#Générer le template toi même

sed  "s@nom_de_domaine@$CONFFILE.local@g" $CONFFILE.conf
sed  "s@racine_projet@$WEBDIR/$project_path@g" $CONFFILE.conf
echo "Nous venons de configurer le fichier, nous allons à
présent activer le site et redémarrer le serveur"
#a2ensite $domain_name.conf
#a2dissite 000-default.conf
#systemctl restart apache2
#Vérifier après l'état des services afin de pouvoir avertir
#le user en cas de problème...
#echo "Configuration des droits des dossiers..."
#chmod -R 755 /var/www