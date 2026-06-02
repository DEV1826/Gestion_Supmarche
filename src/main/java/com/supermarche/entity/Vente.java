package com.supermarche.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Vente {

    public enum ModePaiement {
        ESPECES, CARTE, MOBILE_MONEY
    }

    private Long id;
    private Long caissierId;
    private LocalDateTime dateHeure;
    private BigDecimal totalTtc;
    private ModePaiement modePaiement;
    private String numeroTicket;
    private Utilisateur caissier;
    private List<LigneVente> lignes = new ArrayList<>();

    public void calculerTotal() {
        this.totalTtc = lignes.stream()
            .map(LigneVente::getSousTotal)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public static String genererNumeroTicket() {
        LocalDateTime now = LocalDateTime.now();
        return String.format("TK-%04d%02d%02d-%04d",
            now.getYear(), now.getMonthValue(), now.getDayOfMonth(),
            (int) (Math.random() * 9000) + 1000);
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getCaissierId() {
        return caissierId;
    }

    public void setCaissierId(Long caissierId) {
        this.caissierId = caissierId;
    }

    public LocalDateTime getDateHeure() {
        return dateHeure;
    }

    public void setDateHeure(LocalDateTime dateHeure) {
        this.dateHeure = dateHeure;
    }

    public BigDecimal getTotalTtc() {
        return totalTtc;
    }

    public void setTotalTtc(BigDecimal totalTtc) {
        this.totalTtc = totalTtc;
    }

    public ModePaiement getModePaiement() {
        return modePaiement;
    }

    public void setModePaiement(ModePaiement modePaiement) {
        this.modePaiement = modePaiement;
    }

    public String getNumeroTicket() {
        return numeroTicket;
    }

    public void setNumeroTicket(String numeroTicket) {
        this.numeroTicket = numeroTicket;
    }

    public Utilisateur getCaissier() {
        return caissier;
    }

    public void setCaissier(Utilisateur caissier) {
        this.caissier = caissier;
    }

    public List<LigneVente> getLignes() {
        return lignes;
    }

    public void setLignes(List<LigneVente> lignes) {
        this.lignes = lignes;
    }
}
