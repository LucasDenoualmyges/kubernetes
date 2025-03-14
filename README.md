Voici comment s'architecte le projet :
Architecture du projet

projet-esgi/
─ Dockerfile
─ docker-compose.yml
─ paymybuddy.jar
─ initdb/
─ kubernetes/
── backend-deployment.yaml
── backend-service.yaml
── mysql-deployment.yaml
── mysql-service.yaml
── mysql-pvc.yaml
── mysql-configmap.yaml
── mysql-secret.yaml
── mysql-init-configmap.yaml
── README.md

## Le Dockerfile
Ce fichier définit les instructions pour créer le conteneur de l'application Spring Boot, en utilisant Java 17 sur une image Alpine minimale, en créant un répertoire de travail dédié pour l'application, en configurant les paramètres de connexion à la base de données et en démarrant l'application automatiquement lors de l'initialisation du conteneur. ![image](https://cdn.discordapp.com/attachments/312901960930033665/1350115555457241198/image.png?ex=67d59098&is=67d43f18&hm=6aa163666af4d9eee5edb55685c4b20885cd52fb241ef005ea8397a96b80e5a5&2)

##Les fichiers docker

### docker-compose.yml
Ce fichier gère le déploiement de deux services étroitement liés, en définissant leur configuration et leur interaction. Il déploie l'application backend en créant une image Docker et en la rendant accessible sur le port 8080. Il déploie également une base de données MySQL avec des volumes pour assurer la persistance des données et des scripts d'initialisation pour la configuration. Les deux services sont connectés via un réseau dédié, permettant une communication efficace entre l'application backend et la base de données.
![image](https://github.com/user-attachments/assets/3733c42f-153a-4659-b064-5b628ff78a80)

### kubernetes/backend-deployment.yaml
Ce manifeste déploie l'application Spring Boot dans un environnement Kubernetes, en créant un pod contenant un conteneur qui exécute l'image de l'application. La configuration de la connexion à la base de données est gérée de manière sécurisée en utilisant un ConfigMap pour les paramètres de configuration non sensibles et un Secret pour les informations sensibles, telles que les mots de passe et les clés d'accès. ![image](https://github.com/user-attachments/assets/024eb17c-776f-4f53-92c8-a1b1bd875f0e)


### kubernetes/backend-service.yaml
Ce service Kubernetes fournit une interface de communication interne pour l'application backend, en exposant l'application sur le port 8080 via un service de type ClusterIP, ce qui permet aux autres composants du cluster de se connecter à l'application de manière transparente et sécurisée.
Note : Un service de type ClusterIP est un type de service Kubernetes qui permet d'exposer un service en interne au cluster, mais pas à l'extérieur du cluster. Cela signifie que l'application backend n'est accessible qu'aux composants qui sont à l'intérieur du cluster, et non à partir de l'extérieur du cluster. ![image](https://github.com/user-attachments/assets/311aeaa7-987c-4ade-af89-22b58fa6d09c)


### kubernetes/mysql-deployment.yaml
Ce service Kubernetes fournit une interface de communication interne pour l'application backend, en exposant l'application sur le port 8080 via un service de type ClusterIP, ce qui permet aux autres composants du cluster de se connecter à l'application de manière transparente et sécurisée.
Les services de type ClusterIP est un type de service Kubernetes qui permet d'exposer un service en interne au cluster, mais pas à l'extérieur du cluster. Cela signifie que l'application backend n'est accessible qu'aux composants qui sont à l'intérieur du cluster, et non à partir de l'extérieur du cluster.![image](https://github.com/user-attachments/assets/d919e63f-3550-47d8-84dd-d2a5bab5db39)

### kubernetes/mysql-service.yaml
Ce service Kubernetes fournit un point d'accès à la base de données MySQL sur le port 3306, permettant ainsi à l'application backend de s'y connecter et d'accéder aux données de manière sécurisée et fiable, depuis n'importe quel endroit du cluster.
Cette exposition de la base de données MySQL sur le port 3306 permet à l'application backend de se connecter à la base de données en utilisant les informations d'identification et les paramètres de connexion standard pour MySQL. Cela facilite la configuration et la gestion de la connexion à la base de données dans l'application backend.![image](https://github.com/user-attachments/assets/8271eed1-2264-4da7-8d5e-3253271ebe07)

### kubernetes/mysql-pvc.yaml
Cette demande de volume persistant prévoit 1 Go d'espace de stockage pour la base de données MySQL, ce qui garantit que les données sont stockées de manière durable et survivent aux événements tels que le redémarrage ou la migration du pod MySQL, assurant ainsi la continuité de l'accès aux données.
Cette demande de volume persistant permet de garantir que les données de la base de données MySQL soient stockées de manière permanente et ne soient pas supprimées en cas de modification ou de déplacement du pod MySQL. Cela est particulièrement important pour les applications qui nécessitent une persistance des données pour fonctionner correctement.![image](https://github.com/user-attachments/assets/e0dff397-b4cd-44f4-b62d-0ffd1c1061df)


### kubernetes/mysql-configmap.yaml
Ce ConfigMap contient les paramètres de connexion à la base de données, notamment l'URL, ce qui permet de les gérer de manière centralisée et de les modifier sans avoir à reconstruire l'image du backend, ce qui réduit les risques d'erreurs et améliore la stabilité de l'application.
Les ConfigMaps sont des objets Kubernetes qui permettent de stocker des configurations sous forme de clés-valeurs, ce qui permet de les gérer de manière centralisée et de les partager entre les différents composants d'une application. Dans ce cas, le ConfigMap stocke l'URL de connexion à la base de données, ce qui permet de la modifier ou de la mettre à jour sans avoir à reconstruire l'image du backend. ![image](https://github.com/user-attachments/assets/9409e4bb-a7a0-4f75-a17a-0a277d72d9e9)


### kubernetes/mysql-secret.yaml
Ce Secret permet de stocker les identifiants de connexion à la base de données, telles que le nom d'utilisateur et le mot de passe, de manière sécurisée et confidentielle, en utilisant un mécanisme de chiffrement pour protéger ces données sensibles et empêcher leur exposition en texte clair dans les déploiements.
Les Secrets sont des objets Kubernetes qui permettent de stocker des données sensibles, telles que les mots de passe et les clés d'accès, de manière sécurisée et chiffrée. Dans ce cas, le Secret stocke les identifiants de connexion à la base de données, ce qui permet de protéger ces informations sensibles et d'éviter les risques de fuite de données. ![image](https://github.com/user-attachments/assets/4311583c-d40c-4b88-9300-165e931b8c8a)


### kubernetes/mysql-init-configmap.yaml
Ce ConfigMap stocke les scripts SQL d'initialisation de la base de données, qui seront utilisés pour créer le schéma de données et les données initiales nécessaires à l'application PayMyBuddy, ce qui permet de simplifier le processus de déploiement et de garantir que la base de données soit correctement configurée pour le fonctionnement de l'application.
Les ConfigMaps sont des objets Kubernetes qui permettent de stocker des données de configuration sous forme de clés-valeurs. Dans ce cas, le ConfigMap stocke les scripts SQL d'initialisation de la base de données, ce qui permet de créer automatiquement le schéma de données et les données initiales nécessaires pour que l'application PayMyBuddy fonctionne correctement. ![image](https://github.com/user-attachments/assets/62e51c8c-c7fc-4b9d-aa8f-f43597b5f09a) 
![image](https://github.com/user-attachments/assets/09a6c1bc-4c9a-4850-a587-e88370d4fb65)




J'ai eu des problèmes lors du déploiement de mon application dû a d'ancien tests que j'ai fait sur ma VM. Malgré mes essais je n'arrivait pas a avoir de résultats concluant. Veuillez m'en excuser. Il y a aussi un problème de base de donnée, je n'ai pas réussi a l'exécuter correctement.


