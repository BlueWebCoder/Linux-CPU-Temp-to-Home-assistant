
# Linux-CPU-Temp-to-Home-assistant

Ce projet permet de récupérer la température CPU des machines distantes tournant sur des systèmes Linux (HiveOS, Proxmox, etc.) et d'envoyer ces informations vers Home Assistant.

## Installation

### Étape 1 : Installer lm-sensors sur la machine distante type HiveOs

Exécutez les commandes suivantes pour installer lm-sensors et configurer le module :

```bash
sudo apt-get install lm-sensors
sudo modprobe drivetemp
echo drivetemp | sudo tee -a /etc/modules
```

### Étape 2 : Créer un jeton d'accès longue durée dans Home Assistant

1. Allez dans la section "Profil utilisateur" dans Home Assistant.
2. Créez un jeton d'accès longue durée.
3. Sauvegardez le jeton, il sera utilisé dans le script plus tard.

![image](https://github.com/user-attachments/assets/0cd6ce80-a621-4830-aefa-d0f9126fc7c9)

### Étape 3 : Créer un script de récupération des températures sur la machine distante type HiveOs

Téléchargez le fihier script de  récuoeration des températures afin de les envoyer à Home Assistant :

```bash
sudo apt update
sudo apt install git
git clone https://github.com/BlueWebCoder/Linux-CPU-Temp-to-Home-assistant.git && cd Linux-CPU-Temp-to-Home-assistant
```

Editez le script en remplaçant le jeton d'acces home assistant et l'ul de home-assistant dans le script .Personnalisez le serv_name si besoin :

```bash
nano temp-to-ha.sh
```
enregistrez + quittez

Rendez le script exécutable :

```bash
chmod +x temp-to-ha.sh
```

Executer le scrpit afin de voir que les données remontent bien : 
```bash
./temp-to-ha.sh
```

![image](https://github.com/user-attachments/assets/237c7f0f-514f-4ca5-822a-4aa1979731eb)


### Étape 4 : Planifier l'exécution automatique du script

Pour exécuter le script automatiquement toutes les minutes, éditez la crontab :

```bash
crontab -e
```

Ajoutez la ligne suivante pour exécuter le script une fois par minute :

```bash
*/1 * * * * /home/user/Linux-CPU-Temp-to-Home-assistant/temp-to-ha.sh
```

Sauvegardez et quittez l'éditeur.

### Étape 6 : Redémarrer le service cron

Redémarrez le service cron pour appliquer les changements :

```bash
systemctl restart cron.service
systemctl status cron.service
```

## Étape 7 : Vérification dans Home Assistant

Recherchez les entités suivantes dans Home Assistant pour vérifier les températures (hiveos ou le serv_name donné ):

- `sensor.hiveos_cpu_temperature`

Vous pouvez maintenant surveiller les températures de votre machine distante directement depuis Home Assistant !
