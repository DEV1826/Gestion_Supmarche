package com.supermarche.entity;

import java.math.BigDecimal;

public class LigneVente {

    private Long id;
    private Long venteId;
    private Long produitId;
    private int quantite;
    private BigDecimal prixUnitaire;
    private BigDecimal sousTotal;
    private Produit produit;

    public LigneVente() {
    }

    public LigneVente(Long produitId, int quantite, BigDecimal prixUnitaire) {
        this.produitId = produitId;
        this.quantite = quantite;
        this.prixUnitaire = prixUnitaire;
        calculerSousTotal();
    }

    public void calculerSousTotal() {
        if (prixUnitaire != null) {
            this.sousTotal = prixUnitaire.multiply(BigDecimal.valueOf(quantite));
        }
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getVenteId() {
        return venteId;
    }

    public void setVenteId(Long venteId) {
        this.venteId = venteId;
    }

    public Long getProduitId() {
        return produitId;
    }

    public void setProduitId(Long produitId) {
        this.produitId = produitId;
    }

    public int getQuantite() {
        return quantite;
    }

    public void setQuantite(int quantite) {
        this.quantite = quantite;
        calculerSousTotal();
    }

    public BigDecimal getPrixUnitaire() {
        return prixUnitaire;
    }

    public void setPrixUnitaire(BigDecimal prixUnitaire) {
        this.prixUnitaire = prixUnitaire;
        calculerSousTotal();
    }

    public BigDecimal getSousTotal() {
        return sousTotal;
    }

    public void setSousTotal(BigDecimal sousTotal) {
        this.sousTotal = sousTotal;
    }

    public Produit getProduit() {
        return produit;
    }

    public void setProduit(Produit produit) {
        this.produit = produit;
    }
}
