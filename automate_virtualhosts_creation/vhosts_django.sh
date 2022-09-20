#!/bin/bash

###############################################################################
#                                                                             #
#Script d'automatisation de la création et configuration des virtualhosts     #
#									      #
#                                                                             #
###############################################################################
PS3="Veuiller sélectionner un nombre:"
WEBDIR=/var/www/
CONFDIR=/etc/apache2/sites-available
TEMPLATE=./static_files/templates/template_django.txt

if [ $# -eq 0 ]
then
    read -p "Veuillez compléter le chemin de votre projet svp (/var/www/): " project_path
    if [ -d $WEBDIR/$project_path ]
    then
        echo "Votre dossier a été retrouvé"
        read -p "Veuillez à présent entrer le nom de votre fichier de configuration: " domain_name
        read -p "Entrez ensuite le chemin vers le dossier principal du projet: " core_folder
        read -p "Nous avons également besoin du chemin de votre virtualenv: " env_path
        read -p "Nous vooulons aussi le nom de votre projet: " project_name
    else
        echo "Le chemin indiqué n'est pas valide. Veuillez réessayer"
    fi
else
    domain_name=$1
    
fi
echo "Hello! Prenez place et observez la maggie, je vais créer vos vhosts pour
vous. Prêt?? C'est parti!"

while true; do
    select host_type in HTTP HTTPS QUITTER; do
        case $host_type in
            HTTP)
                cp $TEMPLATE  $CONFDIR/$domain_name.conf
                sed s/nom_de_domaine/$domain_name.local/ $CONFDIR/$domain_name.conf
                sed s/racine_projet/$project_path/g $CONFDIR/$domain_name.conf
                sed s/core_folder/$core_folder/g $CONFDIR/$domain_name.conf
                sed s/project_name/$project_name/g $CONFDIR/$domain_name.conf
                sed s/env_path/$env_path/g $CONFDIR/$domain_name.conf
                sudo chown :www-data $project_path
                #sed -i "s/racine_projet/$domain_name/g" /etc/apache2/sites-available/siepki.org.conf
                # sed -i "/ServerName/a  DocumentRoot $WEBDIR$domain_name" /etc/apache2/sites-available/$domain_name.conf
                echo "Nous venons de configurer le fichier, nous allons à
                présent activer le site et redémarrer le serveur"
                a2ensite $domain_name.conf
                a2dissite 000-default.conf
                systemctl restart apache2
                #Vérifier après l'état des services afin de pouvoir avertir
                #le user en cas de problème...
                echo "Configuration des droits des dossiers..."
                chmod -R 755 /var/www
                echo "Et Voilà votre host est configuré en HTTP.
                      Vous pouvez configurer votre fichier host sur votre
                machine locale. Voulez vous lui ajouter un certificat?"
                select add_certificate in Oui Non; do
                    case $add_certificate in
                        Oui)
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
                            sed -i 's/80/443/g' $CONFDIR/$domain_name.conf
                            sed -i "/<\/VirtualHost>/i SSLEngine on\
        \n SSLCertificateFile /etc/ssl/certs\
        /apache-selfsigned.crt\
        \n  SSLCertificateKeyFile\
        /etc/ssl/private/\
                            apache-selfsigned.key" $CONFDIR/$domain_name.conf
                            echo "Nous allons à présent rédiriger tous les
                            traffics http en https...."
                            sed -i "/<\/VirtualHost>/a <VirtualHost *:80>\
        \n ServerName $domain_name\
        \n Redirect / https://$domain_name \
                            \n <\/VirtualHost>" $CONFDIR/$domain_name.conf
                            break
                        ;;
                        Non)
                            echo "Super, merci d'avoir utilisé notre script"
                            exit 0
                            break
                        ;;
                    esac
                done
                break
            ;;
            
            HTTPS)
                cp $TEMPLATE  $CONFDIR/$domain_name.conf
                sed -i "s/nom_de_domaine/$domain_name.local/" $CONFDIR/$domain_name.conf 
                sed -i "s/racine_projet/$WEBDIR$project_path/g" $CONFDIR/$domain_name.conf 
                sed -i "s/core_folder/$core_folder/g" $CONFDIR/$domain_name.conf 
                sed -i "s/project_name/$project_name/g" $CONFDIR/$domain_name.conf 
                sed -i "s/env_path/$env_path/g" $CONFDIR/$domain_name.conf 
                sudo chown :www-data $project_path
                #sed -i "s/racine_projet/$domain_name/g" /etc/apache2/sites-available/siepki.org.conf
                # sed -i "/ServerName/a  DocumentRoot $WEBDIR$domain_name" /etc/apache2/sites-available/$domain_name.conf
                echo "Nous venons de configurer le fichier, nous allons à
                présent activer le site et redémarrer le serveur"
                a2ensite $domain_name.conf
                a2dissite 000-default.conf
                systemctl restart apache2
                #Vérifier après l'état des services afin de pouvoir avertir
                #le user en cas de problème...
                echo "Configuration des droits des dossiers..."
                chmod -R 755 /var/www
                echo "Et Voilà votre host est configuré en HTTP.
                      Vous pouvez configurer votre fichier host sur votre
                machine locale. Voulez vous lui ajouter un certificat?"
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
                sed -i "s/80/443/g" /etc/apache2/sites-available/$domain_name.conf
                sed -i "/<\/VirtualHost>/i SSLEngine on\
        \n SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt\
        \n  SSLCertificateKeyFile\
                /etc/ssl/private/apache-selfsigned.key" /etc/apache2/sites-available/$domain_name.conf
                echo "Nous allons à présent rédiriger tous les
                traffics http en https...."
                sed -i "/<\/VirtualHost>/a <VirtualHost *:80>\
        \n ServerName $domain_name.local\
        \n Redirect / https://$domain_name \
                \n <\/VirtualHost>" /etc/apache2/sites-available/$domain_name.conf
                chown :www-data $project_path
                systemctl restart apache2
                break
            ;;
            QUITTER)
                echo "Merci d'avoir utilisé notre script";
                exit 0
                break
            ;;
        esac
        
    done
done

#il faut ensuite lui demander s'il a envie de continuer en https
#sed s/test@example.com/$1/ $1.txt > $CONFDIR/$1.conf



