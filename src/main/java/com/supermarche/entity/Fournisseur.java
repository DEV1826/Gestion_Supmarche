package com.supermarche.entity;

public class Fournisseur {

    private Long id;
    private String raisonSociale;
    private String telephone;
    private String email;
    private int delaiLivraisonJours;
    private String conditionsPaiement;

    public Fournisseur() {
    }

    public Fournisseur(Long id, String raisonSociale, String telephone, String email,
                       int delaiLivraisonJours, String conditionsPaiement) {
        this.id = id;
        this.raisonSociale = raisonSociale;
        this.telephone = telephone;
        this.email = email;
        this.delaiLivraisonJours = delaiLivraisonJours;
        this.conditionsPaiement = conditionsPaiement;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getRaisonSociale() {
        return raisonSociale;
    }

    public void setRaisonSociale(String raisonSociale) {
        this.raisonSociale = raisonSociale;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getDelaiLivraisonJours() {
        return delaiLivraisonJours;
    }

    public void setDelaiLivraisonJours(int delaiLivraisonJours) {
        this.delaiLivraisonJours = delaiLivraisonJours;
    }

    public String getConditionsPaiement() {
        return conditionsPaiement;
    }

    public void setConditionsPaiement(String conditionsPaiement) {
        this.conditionsPaiement = conditionsPaiement;
    }
}
