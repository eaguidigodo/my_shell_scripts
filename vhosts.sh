#!/bin/bash

###############################################################################
#                                                                             #
#Script d'automatisation de la création et configuration des virtualhosts     #
#																		      #
#                                                                             #
###############################################################################
PS3="Veuiller sélectionner un nombre:"
WEDIR=/var/www/$domain_name
CONFDIR=/etc/apache2/sites-available
TEMPLATE=./static_files/templates/template.txt
CONFFILE=$CONFDIR/$domaine_name.conf
if [ $# -eq 0] 
    then
        read -p "Entrer le nom du domaine à configurer svp: " domaine_name
else
    domaine_name=$1
        
fi
echo "Hello! Prenez place et observez la maggie, je vais créer vos vhosts pour 
        vous. Prêt?? C'est parti!"

while true; do
    select host_type in HTTP HTTPS QUITTER; do
        case $host_type in
            HTTP)                
                [ -d $CONFDIR ] || mkdir -p $CONFDIR
                sudo cp $TEMPLATE $CONFDIR/$1.conf
                sudo sed -i  "/ServerName/a $1" $CONFFILE
                sudo sed -i "/DocumentRoot/a $WEBDIR" $CONFFILE
                echo "Et Voilà votre host est configuré en HTTP. Voulez vous 
                        lui ajouter un certificat?"
                select add_certificate in Oui Non; do
                    case $add_certificate in 
                        Oui)
                            echo "Module pas encore disponible"
                            exit 0
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

 

