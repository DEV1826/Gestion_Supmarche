# Supermarche Jakarta EE

Projet de base pour le TP 07 de gestion d'un supermarche en Jakarta EE.

## Structure

- `src/main/java/com/supermarche/entity` : modeles metier
- `src/main/java/com/supermarche/dao` : acces JDBC MySQL
- `src/main/java/com/supermarche/servlet` : controleurs web
- `src/main/java/com/supermarche/filter` : filtre d'authentification
- `src/main/java/com/supermarche/util` : utilitaires DB, BCrypt, PDF, CSV, SMS
- `src/main/webapp/views` : JSP

## Configuration

1. Creer la base avec `src/main/resources/schema.sql`
2. Configurer MySQL avec de vraies variables d'environnement :

```powershell
$env:DB_URL="jdbc:mysql://localhost:3306/supermarche?useSSL=false&serverTimezone=UTC"
$env:DB_USERNAME="root"
$env:DB_PASSWORD="votre_mot_de_passe"
```

3. Configurer Twilio pour les SMS reels :

```powershell
$env:SMS_ENABLED="true"
$env:TWILIO_ACCOUNT_SID="ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
$env:TWILIO_AUTH_TOKEN="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
$env:TWILIO_FROM_NUMBER="+237657786440"
```

4. Configurer l'email SMTP pour envoyer le PDF aux fournisseurs :

```powershell
$env:MAIL_ENABLED="true"
$env:MAIL_SMTP_HOST="smtp.gmail.com"
$env:MAIL_SMTP_PORT="587"
$env:MAIL_SMTP_USERNAME="japhetdjomo@gmail.com"
$env:MAIL_SMTP_PASSWORD="avjx hmfx bumu ntzo"
$env:MAIL_SMTP_FROM="japhetdjomo@gmail.com"
```

5. Lancer avec Maven Jetty :

```powershell
mvn org.eclipse.jetty.ee10:jetty-ee10-maven-plugin:12.0.7:run
```

6. Ouvrir `http://localhost:8080/supermarche`

## Comptes par defaut

- `admin` / `admin123`
- `sophie` / `admin123`

Si ta base a ete creee avant cette mise a jour, execute aussi :

```sql
UPDATE utilisateur
SET mot_de_passe = '$2a$12$kaiE7qTm97vdXSCqBVPYW.WOuLOB0ieoxwcfyYC.fCiy7SxuhxXWu'
WHERE login IN ('admin', 'sophie');
```

## Notes

- Les identifiants MySQL et Twilio ne sont pas ecrits en dur dans le projet.
- La configuration lit d'abord les variables d'environnement, puis les fichiers `db.properties` et `app.properties`.
- Le CRUD complet produits/fournisseurs est disponible avec modification et suppression.
- Le bon de commande fournisseur peut etre genere en PDF, avec option d'envoi SMS.
- Le build Maven n'a pas pu etre verifie completement ici a cause du telechargement reseau trop long dans l'environnement.
- Si `mvn jetty-ee10:run` echoue avec `No plugin found for prefix 'jetty-ee10'`, utilise la commande complete ci-dessus.


et maintenant tu me retape le designe complet de tout les page et tu dois gerer la responsiviter des pages et tout et les couleurs sont le bleu blanc 