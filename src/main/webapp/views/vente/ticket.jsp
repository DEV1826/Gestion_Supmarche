<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <%@ include file="/views/partials/head.jspf" %>
    <title>Ticket</title>
</head>
<body class="app-shell">
<c:set var="activePage" value="cashier"/>
<c:set var="pageTitle" value="Ticket de vente"/>
<c:set var="pageSubtitle" value="Recu detaille et impression client."/>
<jsp:include page="/views/partials/sidebar.jsp"/>
<div class="lg:pl-[19rem]">
    <jsp:include page="/views/partials/topbar.jsp"/>
    <main class="px-4 py-6 sm:px-6 lg:px-10">
        <section class="page-card overflow-hidden">
            <div class="border-b border-market-line px-8 py-8">
                <div class="flex flex-col gap-5 lg:flex-row lg:items-center lg:justify-between">
                    <div>
                        <p class="text-lg font-semibold uppercase tracking-[0.2em] text-market-pine">Facture client</p>
                        <h1 class="mt-4 font-display text-5xl font-extrabold text-market-pine">Recu ${vente.numeroTicket}</h1>
                        <p class="mt-3 text-2xl text-slate-500">Recu detaille de la vente enregistree.</p>
                    </div>
                    <div class="flex flex-wrap gap-3">
                        <a class="rounded-[1.35rem] bg-market-gold px-6 py-4 text-xl font-bold text-white shadow-float" href="${pageContext.request.contextPath}/ventes/ticket?id=${vente.id}&format=pdf">Telecharger la facture PDF</a>
                        <a class="rounded-[1.35rem] border border-market-line bg-white px-6 py-4 text-xl font-semibold text-market-pine" href="${pageContext.request.contextPath}/ventes/nouvelle">Nouvelle vente</a>
                    </div>
                </div>
            </div>

            <div class="grid gap-5 border-b border-market-line bg-market-pine px-8 py-7 text-white lg:grid-cols-3">
                <div>
                    <p class="text-sm uppercase tracking-[0.2em] text-white/65">Total TTC</p>
                    <p class="mt-3 font-display text-4xl font-extrabold"><fmt:formatNumber value="${vente.totalTtc}" type="number" maxFractionDigits="0"/> FCFA</p>
                </div>
                <div>
                    <p class="text-sm uppercase tracking-[0.2em] text-white/65">Paiement</p>
                    <p class="mt-3 font-display text-4xl font-extrabold">${vente.modePaiement}</p>
                </div>
                <div>
                    <p class="text-sm uppercase tracking-[0.2em] text-white/65">Date</p>
                    <p class="mt-3 text-2xl font-semibold">${vente.dateHeure}</p>
                </div>
            </div>

            <div class="px-8 py-8">
                <div class="mb-5 flex flex-wrap gap-3 text-lg font-semibold">
                    <span class="rounded-full bg-market-mint px-4 py-2 text-market-pine">${vente.lignes.size()} ligne(s)</span>
                    <span class="rounded-full bg-market-cream px-4 py-2 text-slate-600">Montants en FCFA</span>
                    <span class="rounded-full bg-market-cream px-4 py-2 text-slate-600">Pret pour impression</span>
                </div>
                <div class="overflow-hidden rounded-[1.6rem] border border-market-line">
                    <div class="overflow-x-auto">
                        <table class="min-w-[720px] text-left">
                            <thead class="bg-market-cream text-xl font-bold text-market-pine">
                                <tr>
                                    <th class="px-6 py-5">Produit</th>
                                    <th class="px-6 py-5">Quantite</th>
                                    <th class="px-6 py-5">Prix unitaire</th>
                                    <th class="px-6 py-5">Sous-total</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${vente.lignes}" var="l">
                                    <tr class="border-t border-market-line">
                                        <td class="px-6 py-5 text-2xl font-semibold text-market-ink">${l.produit.designation}</td>
                                        <td class="px-6 py-5 text-2xl text-market-ink">${l.quantite}</td>
                                        <td class="px-6 py-5 text-2xl text-market-ink"><fmt:formatNumber value="${l.prixUnitaire}" type="number" maxFractionDigits="0"/> FCFA</td>
                                        <td class="px-6 py-5 text-2xl font-bold text-market-pine"><fmt:formatNumber value="${l.sousTotal}" type="number" maxFractionDigits="0"/> FCFA</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="mt-8 flex justify-end">
                    <div class="rounded-[1.6rem] bg-market-cream px-8 py-6 text-right">
                        <p class="text-sm uppercase tracking-[0.2em] text-slate-500">Net a payer</p>
                        <p class="mt-3 font-display text-5xl font-extrabold text-market-pine"><fmt:formatNumber value="${vente.totalTtc}" type="number" maxFractionDigits="0"/> FCFA</p>
                    </div>
                </div>
            </div>
        </section>
    </main>
</div>
<script>
    const sidebarToggle = document.getElementById('sidebarToggle');
    const appSidebar = document.getElementById('appSidebar');
    if (sidebarToggle && appSidebar) {
        sidebarToggle.addEventListener('click', () => {
            appSidebar.classList.toggle('-translate-x-full');
        });
    }
</script>
</body>
</html>
