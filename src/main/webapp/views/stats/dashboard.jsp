<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <%@ include file="/views/partials/head.jspf" %>
    <title>Statistiques</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="app-shell">
<c:set var="activePage" value="stats"/>
<c:set var="pageTitle" value="Analyses &amp; Statistiques"/>
<c:set var="pageSubtitle" value="Suivi des performances operationnelles du terminal."/>
<c:set var="sidebarBrand" value="MarketPro UI"/>
<c:set var="sidebarSubtitle" value="Terminal Admin v2.0"/>
<c:set var="topbarSearchPlaceholder" value="Rechercher..."/>
<jsp:include page="/views/partials/sidebar.jsp"/>
<div class="lg:pl-[19rem]">
    <jsp:include page="/views/partials/topbar.jsp"/>
    <main class="space-y-8 px-4 py-6 sm:px-6 lg:px-10">
        <section class="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
            <div>
                <h1 class="font-display text-5xl font-extrabold text-market-pine">Analyses &amp; Statistiques</h1>
                <p class="mt-2 text-2xl text-slate-500">Suivi des performances operationnelles du terminal</p>
            </div>
            <div class="page-card flex flex-wrap items-center gap-4 px-4 py-3 text-xl font-semibold text-market-ink">
                <span class="rounded-full bg-market-mint px-5 py-3 text-market-pine">7 derniers jours</span>
                <span class="px-4 py-2">Mensuel</span>
                <span class="border-l border-market-line px-4 py-2">Annuel</span>
                <span class="rounded-full border border-market-pine px-5 py-3 text-market-pine">Personnalise</span>
            </div>
        </section>

        <section class="grid gap-5 xl:grid-cols-[1.5fr_0.7fr]">
            <article class="page-card p-8">
                <div class="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
                    <div>
                        <h2 class="font-display text-4xl font-bold text-market-pine">Evolution du Chiffre d'Affaires</h2>
                        <p class="mt-2 text-xl font-semibold text-slate-500">Revenus hebdomadaires cumules (FCFA)</p>
                    </div>
                    <div class="text-right">
                        <p class="font-display text-5xl font-extrabold text-market-pine"><fmt:formatNumber value="${kpis.ca_total}" type="number" maxFractionDigits="0"/> FCFA</p>
                        <p class="mt-2 text-xl font-bold text-market-gold">+12.4% vs sem. derniere</p>
                    </div>
                </div>
                <div class="mt-8 rounded-[1.8rem] bg-slate-50 p-4">
                    <canvas id="weekChart" height="150"></canvas>
                </div>
            </article>
            <article class="page-card border-l-4 border-l-market-gold p-8">
                <div class="flex items-start justify-between gap-4">
                    <div class="rounded-[1.35rem] bg-market-mint p-4 text-market-pine">
                        <svg class="h-9 w-9" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9"><path d="M7 7h10l3 5-8 8-8-8z"/><path d="M7 7 4 12"/><path d="M17 7 20 12"/></svg>
                    </div>
                    <span class="rounded-full bg-slate-100 px-4 py-2 text-lg font-semibold text-market-pine">Stable</span>
                </div>
                <h2 class="mt-10 font-display text-4xl font-bold text-market-pine">Panier Moyen</h2>
                <p class="mt-4 text-2xl leading-10 text-slate-600">Valeur moyenne des transactions effectuees cette semaine.</p>
                <p class="mt-16 font-display text-6xl font-extrabold text-market-pine"><fmt:formatNumber value="${kpis.panier_moyen}" type="number" maxFractionDigits="0"/> <span class="text-4xl">FCFA</span></p>
                <div class="mt-8 h-3 rounded-full bg-market-mint">
                    <div class="h-3 w-3/4 rounded-full bg-market-gold"></div>
                </div>
                <p class="mt-4 text-xl font-semibold text-market-ink">Objectif: 15,000 FCFA</p>
            </article>
        </section>

        <section class="grid gap-5 xl:grid-cols-[0.7fr_1.3fr]">
            <article class="page-card p-8">
                <h2 class="font-display text-4xl font-bold text-market-pine">Top 5 Categories</h2>
                <div class="mt-10 space-y-8">
                    <c:forEach items="${caParCategorie}" var="row" begin="0" end="4">
                        <c:set var="shareValue" value="${kpis.ca_total > 0 ? (row.ca_total * 100.0) / kpis.ca_total : 0}" />
                        <div>
                            <div class="mb-3 flex items-center justify-between gap-3 text-2xl font-semibold text-market-ink">
                                <span>${row.categorie}</span>
                                <span><fmt:formatNumber value="${shareValue}" maxFractionDigits="0"/>%</span>
                            </div>
                            <div class="h-3 rounded-full bg-market-mint">
                                <div class="h-3 rounded-full bg-market-pine" style="width: ${shareValue}%"></div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </article>
            <article class="page-card p-8">
                <div class="mb-8 flex items-center justify-between gap-4">
                    <h2 class="font-display text-4xl font-bold text-market-pine">Tableau des meilleures ventes</h2>
                    <a class="text-2xl font-semibold text-market-pine" href="${pageContext.request.contextPath}/produits">Voir tout le catalogue</a>
                </div>
                <div class="overflow-x-auto">
                    <table class="min-w-[760px] text-left">
                        <thead class="border-b border-market-line text-xl font-semibold text-slate-500">
                            <tr>
                                <th class="px-2 py-4">Produit</th>
                                <th class="px-2 py-4">Categorie</th>
                                <th class="px-2 py-4">Unites</th>
                                <th class="px-2 py-4">Chiffre d'Affaires</th>
                                <th class="px-2 py-4">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${topProduits}" var="row" begin="0" end="3">
                                <tr class="border-b border-market-line last:border-b-0">
                                    <td class="px-2 py-6">
                                        <div class="flex items-center gap-4">
                                            <div class="flex h-14 w-14 items-center justify-center rounded-[1.1rem] bg-market-mint text-xl font-bold text-market-pine">${fn:substring(row.designation, 0, 1)}</div>
                                            <span class="text-3xl font-semibold text-market-ink">${row.designation}</span>
                                        </div>
                                    </td>
                                    <td class="px-2 py-6 text-2xl text-market-ink">${row.categorie}</td>
                                    <td class="px-2 py-6 text-2xl font-semibold text-market-ink">${row.quantite_vendue}</td>
                                    <td class="px-2 py-6 text-2xl font-bold text-market-pine"><fmt:formatNumber value="${row.chiffre_affaires}" type="number" maxFractionDigits="0"/> FCFA</td>
                                    <td class="px-2 py-6"><span class="rounded-full bg-market-mint px-4 py-2 text-lg font-semibold text-market-pine">En Stock</span></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </article>
        </section>
    </main>
</div>
<script>
    const weekLabels = [
        <c:forEach items="${ventesHebdo}" var="row" varStatus="status">'S${row.semaine}'<c:if test="${!status.last}">,</c:if></c:forEach>
    ];
    const weekValues = [
        <c:forEach items="${ventesHebdo}" var="row" varStatus="status">${row.ca_semaine}<c:if test="${!status.last}">,</c:if></c:forEach>
    ];

    new Chart(document.getElementById('weekChart'), {
        type: 'line',
        data: {
            labels: weekLabels,
            datasets: [{
                data: weekValues,
                borderColor: '#1f3fb7',
                backgroundColor: 'rgba(31, 63, 183, 0.12)',
                fill: true,
                borderWidth: 4,
                tension: 0.35,
                pointBackgroundColor: '#1f3fb7',
                pointRadius: 4
            }]
        },
        options: {
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, grid: { color: 'rgba(31,63,183,0.08)' } },
                x: { grid: { display: false } }
            }
        }
    });

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
