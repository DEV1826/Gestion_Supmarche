CREATE DATABASE IF NOT EXISTS supermarche CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE supermarche;

CREATE TABLE utilisateur (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    login VARCHAR(80) NOT NULL UNIQUE,
    mot_de_passe VARCHAR(255) NOT NULL,
    role ENUM('ADMIN','CAISSIER') NOT NULL DEFAULT 'CAISSIER',
    actif BOOLEAN NOT NULL DEFAULT TRUE,
    date_creation DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB;

CREATE TABLE fournisseur (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    raison_sociale VARCHAR(150) NOT NULL UNIQUE,
    telephone VARCHAR(20),
    email VARCHAR(150),
    delai_livraison_jours INT NOT NULL DEFAULT 7,
    conditions_paiement VARCHAR(100)
) ENGINE=InnoDB;

CREATE TABLE produit (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code_barre VARCHAR(30) NOT NULL UNIQUE,
    designation VARCHAR(150) NOT NULL,
    categorie VARCHAR(80) NOT NULL,
    prix_achat DECIMAL(10,2) NOT NULL,
    prix_vente DECIMAL(10,2) NOT NULL,
    stock_actuel INT NOT NULL DEFAULT 0,
    stock_minimum INT NOT NULL DEFAULT 5,
    date_peremption DATE,
    fournisseur_id BIGINT,
    CONSTRAINT fk_produit_fournisseur
        FOREIGN KEY (fournisseur_id) REFERENCES fournisseur(id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE vente (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    caissier_id BIGINT NOT NULL,
    date_heure DATETIME NOT NULL DEFAULT NOW(),
    total_ttc DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    mode_paiement ENUM('ESPECES','CARTE','MOBILE_MONEY') NOT NULL,
    numero_ticket VARCHAR(20) NOT NULL UNIQUE,
    CONSTRAINT fk_vente_caissier
        FOREIGN KEY (caissier_id) REFERENCES utilisateur(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE ligne_vente (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    vente_id BIGINT NOT NULL,
    produit_id BIGINT NOT NULL,
    quantite INT NOT NULL,
    prix_unitaire DECIMAL(10,2) NOT NULL,
    sous_total DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_lv_vente
        FOREIGN KEY (vente_id) REFERENCES vente(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_lv_produit
        FOREIGN KEY (produit_id) REFERENCES produit(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO utilisateur (nom, prenom, login, mot_de_passe, role) VALUES
('Dupont', 'Jean', 'admin', '$2a$12$kaiE7qTm97vdXSCqBVPYW.WOuLOB0ieoxwcfyYC.fCiy7SxuhxXWu', 'ADMIN'),
('Martin', 'Sophie', 'sophie', '$2a$12$kaiE7qTm97vdXSCqBVPYW.WOuLOB0ieoxwcfyYC.fCiy7SxuhxXWu', 'CAISSIER');

INSERT INTO fournisseur (raison_sociale, telephone, email, delai_livraison_jours, conditions_paiement) VALUES
('SODIFRA Alimentation', '+33612345678', 'contact@sodifra.fr', 5, '30 jours net'),
('ProHygiene SARL', '+33698765432', 'commandes@prohygiene.fr', 7, 'Comptant'),
('ElectroDistrib', '+33645678901', 'pro@electrodistrib.fr', 14, '60 jours fin de mois');

INSERT INTO produit (code_barre, designation, categorie, prix_achat, prix_vente, stock_actuel, stock_minimum, fournisseur_id) VALUES
('3017620422003', 'Nutella 400g', 'Alimentation', 2.50, 3.99, 45, 10, 1),
('3228857000166', 'Eau minerale Evian 1.5L', 'Alimentation', 0.45, 0.89, 200, 30, 1),
('3574660239881', 'Lessive Ariel 3kg', 'Hygiene', 8.20, 12.99, 3, 5, 2),
('8712566338498', 'Ampoule LED 10W', 'Electronique', 2.10, 4.50, 8, 5, 3),
('3229820129488', 'Chocolat noir 200g', 'Alimentation', 1.20, 2.30, 60, 15, 1);

CREATE OR REPLACE VIEW v_top_produits AS
SELECT
    p.id,
    p.designation,
    p.categorie,
    SUM(lv.quantite) AS total_quantite_vendue,
    SUM(lv.sous_total) AS chiffre_affaires
FROM ligne_vente lv
JOIN produit p ON p.id = lv.produit_id
GROUP BY p.id, p.designation, p.categorie
ORDER BY total_quantite_vendue DESC
LIMIT 10;

CREATE OR REPLACE VIEW v_ca_par_categorie AS
SELECT
    p.categorie,
    SUM(lv.sous_total) AS ca_total,
    COUNT(DISTINCT lv.vente_id) AS nb_ventes
FROM ligne_vente lv
JOIN produit p ON p.id = lv.produit_id
GROUP BY p.categorie
ORDER BY ca_total DESC;

CREATE OR REPLACE VIEW v_ventes_hebdo AS
SELECT
    YEAR(v.date_heure) AS annee,
    WEEK(v.date_heure, 1) AS semaine,
    COUNT(DISTINCT v.id) AS nb_tickets,
    SUM(v.total_ttc) AS ca_semaine
FROM vente v
GROUP BY YEAR(v.date_heure), WEEK(v.date_heure, 1)
ORDER BY annee DESC, semaine DESC;

CREATE OR REPLACE VIEW v_alertes_stock AS
SELECT
    p.id,
    p.designation,
    p.stock_actuel,
    p.stock_minimum,
    f.raison_sociale AS fournisseur,
    f.telephone AS tel_fournisseur
FROM produit p
JOIN fournisseur f ON f.id = p.fournisseur_id
WHERE p.stock_actuel <= p.stock_minimum
ORDER BY p.stock_actuel ASC;
