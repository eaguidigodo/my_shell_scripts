echo "Super on va commencer par activer le module
ssl et redemarrer le serveur:.."
a2enmod ssl
systemctl restart apache2
echo "Nous allons à présent générer un certificat
TLS...."
openssl req -x509 -nodes -days 365 -newkey\
rsa:2048 -keyout\
/etc/ssl/private/apache-selfsigned.key\
-out /etc/ssl/certs/apache-selfsigned.crt
echo "Aller, il est temps de configurer apache pour
qu'il utilise TLS"
sed s "/80/443" $CONFFILE
sed -i "/<\/VirtualHost>/i SSLEngine on\
        \n SSLCertificateFile /etc/ssl/certs\
        /apache-selfsigned.crt\
        \n  SSLCertificateKeyFile\
        /etc/ssl/private/\
apache-selfsigned.key" $CONFFILE
echo "Nous allons à présent rédiriger tous les
traffics http en https...."
sed -i "/<\/VirtualHost>/a <VirtualHost *:80>\
        \n ServerName $domain_name\
        \n Redirect / https://$domain_name \
\n <\/VirtualHost>" $CONFFILE