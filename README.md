
# Linux-Temp-to-Home-assistant

Ce projet permet de récupérer la température des machines distantes tournant sur des systèmes Linux (HiveOS, Proxmox, etc.) et d'envoyer ces informations vers Home Assistant.

## Installation

### Étape 1 : Installer lm-sensors sur la machine distante

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

### Étape 3 : Créer un script de récupération des températures

Créez un fichier de script sur la machine distante pour récupérer les températures et les envoyer à Home Assistant :

```bash
nano ha_post_temp.sh
```

Collez le code nécessaire dans le fichier, puis enregistrez-le avec les commandes :

```bash
CTRL + S
CTRL + X
```

Rendez le script exécutable :

```bash
chmod +x ha_post_temp.sh
```

### Étape 4 : Vérifier le fonctionnement du script

Exécutez manuellement le script pour vérifier qu'il fonctionne correctement :

```bash
/root/ha_post_temp.sh
```

### Étape 5 : Planifier l'exécution automatique du script

Pour exécuter le script automatiquement toutes les minutes, éditez la crontab :

```bash
crontab -e
```

Ajoutez la ligne suivante pour exécuter le script une fois par minute :

```bash
*/1 * * * * /root/ha_post_temp.sh
```

Sauvegardez et quittez l'éditeur.

### Étape 6 : Redémarrer le service cron

Redémarrez le service cron pour appliquer les changements :

```bash
systemctl restart cron.service
systemctl status cron.service
```

## Étape 7 : Vérification dans Home Assistant

Recherchez les entités suivantes dans Home Assistant pour vérifier les températures :

- `sensor.hiveos_cpu_temperature`
- `sensor.hiveos_gpu_temperature`

Vous pouvez maintenant surveiller les températures de votre machine distante directement depuis Home Assistant !
