<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <%@ include file="/WEB-INF/views/partials/head.jspf" %>
    <title>Dashboard | Supermarché</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .modal-overlay {
            position: fixed;
            inset: 0;
            background-color: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.2s ease, visibility 0.2s ease;
        }
        .modal-overlay.active {
            opacity: 1;
            visibility: visible;
        }
        .modal-container {
            background: white;
            border-radius: 1.5rem;
            width: 90%;
            max-width: 650px;
            max-height: 85vh;
            overflow-y: auto;
            padding: 1.5rem;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
        }
        .compact-kpi {
            min-height: 9.5rem;
        }
        .chart-box {
            height: 18rem;
        }
        @media (max-width: 640px) {
            .chart-box {
                height: 15rem;
            }
        }
    </style>
</head>
<body class="app-shell">
<c:set var="activePage" value="dashboard"/>
<c:set var="pageTitle" value="Tableau de bord"/>
<c:set var="pageSubtitle" value="Pilotage compact des ventes, du stock et des actions rapides."/>
<c:set var="topbarSearchPlaceholder" value="Rechercher un produit ou un ticket..."/>
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp"/>
<jsp:include page="/WEB-INF/views/partials/panier-sidebar.jsp"/>

<div class="lg:pl-[19rem]">
    <jsp:include page="/WEB-INF/views/partials/topbar.jsp"/>
    <main class="space-y-6 px-4 py-5 sm:px-6 lg:px-8">
        <!-- 4 indicateurs clés -->
        <section class="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
            <!-- CA -->
            <article class="page-card compact-kpi p-5">
                <div class="flex items-start justify-between gap-3">
                    <div>
                        <p class="text-sm font-extrabold uppercase tracking-wide text-slate-500">Chiffre d'affaires</p>
                        <p class="mt-3 font-display text-3xl font-extrabold text-market-pine">
                            <fmt:formatNumber value="${kpis.ca_total}" type="number" maxFractionDigits="0"/>
                        </p>
                        <p class="mt-1 text-sm font-bold text-slate-500">FCFA encaissés</p>
                    </div>
                    <div class="rounded-[1rem] bg-market-mint p-3 text-market-pine">
                        <svg class="h-6 w-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="4" y="6" width="16" height="12" rx="2"/><path d="M7 10h10"/><path d="M8 14h4"/></svg>
                    </div>
                </div>
                <div class="mt-4 h-2 rounded-full bg-market-mint">
                    <div class="h-2 w-4/5 rounded-full bg-market-pine"></div>
                </div>
            </article>

            <!-- Tickets -->
            <article class="page-card compact-kpi p-5">
                <div class="flex items-start justify-between gap-3">
                    <div>
                        <p class="text-sm font-extrabold uppercase tracking-wide text-slate-500">Tickets</p>
                        <p class="mt-3 font-display text-3xl font-extrabold text-market-ink">${kpis.nb_ventes}</p>
                        <p class="mt-1 text-sm font-bold text-market-moss">Panier moyen: <fmt:formatNumber value="${kpis.panier_moyen}" type="number" maxFractionDigits="0"/> FCFA</p>
                    </div>
                    <div class="rounded-[1rem] bg-slate-100 p-3 text-market-pine">
                        <svg class="h-6 w-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M6 3h12v18l-2-1-2 1-2-1-2 1-2-1-2 1V3Z"/><path d="M9 8h6"/><path d="M9 12h6"/></svg>
                    </div>
                </div>
            </article>

            <!-- Alertes stock -->
            <article class="page-card compact-kpi border-l-4 border-l-red-400 p-5">
                <div class="flex items-start justify-between gap-3">
                    <div>
                        <p class="text-sm font-extrabold uppercase tracking-wide text-red-500">Alertes stock</p>
                        <p class="mt-3 font-display text-3xl font-extrabold text-red-500">${alertesStock}</p>
                        <p class="mt-1 text-sm font-bold text-slate-500"><fmt:formatNumber value="${tauxAlerte}" maxFractionDigits="1"/>% du catalogue</p>
                    </div>
                    <button type="button" id="openAlertModal" class="rounded-[1rem] bg-red-50 p-3 text-red-500" title="Voir les alertes">
                        <svg class="h-6 w-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 4 3 20h18L12 4Z"/><path d="M12 9v5"/><path d="M12 18h.01"/></svg>
                    </button>
                </div>
                <div class="mt-4 h-2 rounded-full bg-red-100">
                    <div class="h-2 rounded-full bg-red-500" style="width: ${tauxAlerte > 100 ? 100 : tauxAlerte}%;"></div>
                </div>
            </article>

            <!-- Catalogue -->
            <article class="page-card compact-kpi p-5">
                <div class="flex items-start justify-between gap-3">
                    <div>
                        <p class="text-sm font-extrabold uppercase tracking-wide text-slate-500">Catalogue</p>
                        <p class="mt-3 font-display text-3xl font-extrabold text-market-ink">${totalProduits}</p>
                        <p class="mt-1 text-sm font-bold text-market-gold">${totalFournisseurs} fournisseur(s)</p>
                    </div>
                    <div class="rounded-[1rem] bg-orange-50 p-3 text-market-gold">
                        <svg class="h-6 w-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 5v14"/><path d="M5 12h14"/><rect x="4" y="4" width="16" height="16" rx="3"/></svg>
                    </div>
                </div>
            </article>
        </section>

        <!-- Graphiques -->
        <section class="grid gap-4 xl:grid-cols-[1.45fr_0.75fr]">
            <article class="page-card p-5">
                <div class="flex flex-wrap items-start justify-between gap-3">
                    <div>
                        <h1 class="font-display text-3xl font-extrabold text-market-pine">Performance hebdomadaire</h1>
                        <p class="mt-1 text-sm font-semibold text-slate-500">Évolution du chiffre d'affaires par semaine</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/stats" class="inline-flex items-center gap-2 rounded-[1rem] bg-market-pine px-4 py-2 text-sm font-bold text-white">
                        <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 19V9"/><path d="M12 19V5"/><path d="M18 19v-7"/></svg>
                        Détails
                    </a>
                </div>
                <div class="chart-box mt-5 rounded-[1rem] bg-slate-50 p-3">
                    <canvas id="dashboardRevenueChart"></canvas>
                </div>
            </article>

            <article class="page-card p-5">
                <div class="flex items-start justify-between gap-3">
                    <div>
                        <h2 class="font-display text-2xl font-bold text-market-pine">Santé stock</h2>
                        <p class="mt-1 text-sm text-slate-500">OK vs alertes</p>
                    </div>
                    <button type="button" id="openStockModal" class="rounded-[1rem] border border-market-line bg-white p-2 text-market-pine" title="Synthèse stock">
                        <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M2 12s3.5-6 10-6 10 6 10 6-3.5 6-10 6S2 12 2 12Z"/><circle cx="12" cy="12" r="3"/></svg>
                    </button>
                </div>
                <div class="mt-4 h-56">
                    <canvas id="stockChart"></canvas>
                </div>
                <div class="mt-4 grid grid-cols-2 gap-3 text-sm">
                    <div class="rounded-[1rem] bg-market-mint px-4 py-3">
                        <p class="font-bold text-market-pine">${stockOk}</p>
                        <p class="text-slate-500">Stock normal</p>
                    </div>
                    <div class="rounded-[1rem] bg-red-50 px-4 py-3">
                        <p class="font-bold text-red-500">${alertesStock}</p>
                        <p class="text-slate-500">À traiter</p>
                    </div>
                </div>
            </article>
        </section>

        <!-- Alertes détaillées + Top ventes -->
        <section class="grid gap-4 xl:grid-cols-[0.9fr_1.1fr]">
            <article class="page-card overflow-hidden">
                <div class="flex items-center justify-between gap-3 border-b border-market-line px-5 py-4">
                    <div class="flex items-center gap-2">
                        <svg class="h-5 w-5 text-red-500" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m13 2-2 9h5l-5 11 2-9H8l5-11Z"/></svg>
                        <h2 class="font-display text-2xl font-bold text-market-ink">Urgences stock</h2>
                    </div>
                    <a class="text-sm font-bold text-market-pine" href="${pageContext.request.contextPath}/stock/alertes">Voir tout</a>
                </div>
                <div>
                    <c:forEach items="${alertes}" var="p" begin="0" end="4">
                        <div class="flex items-center justify-between gap-3 border-b border-market-line px-5 py-4 last:border-b-0">
                            <div class="flex min-w-0 items-center gap-3">
                                <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-[1rem] bg-market-mint text-sm font-extrabold text-market-pine">
                                    ${fn:substring(p.categorie, 0, 1)}
                                </div>
                                <div class="min-w-0">
                                    <p class="truncate text-sm font-extrabold text-market-ink">${p.designation}</p>
                                    <p class="text-sm text-slate-500">Ref: ${p.codeBarre}</p>
                                </div>
                            </div>
                            <span class="shrink-0 rounded-full px-3 py-1 text-sm font-extrabold ${p.stockActuel <= 0 ? 'bg-red-100 text-red-600' : 'bg-orange-100 text-orange-600'}">
                                ${p.stockActuel} u.
                            </span>
                        </div>
                    </c:forEach>
                    <c:if test="${empty alertes}">
                        <div class="px-5 py-8 text-center text-sm font-semibold text-slate-500">Aucune alerte stock.</div>
                    </c:if>
                </div>
            </article>

            <article class="page-card overflow-hidden">
                <div class="flex items-center justify-between gap-3 border-b border-market-line px-5 py-4">
                    <h2 class="font-display text-2xl font-bold text-market-pine">Meilleures ventes</h2>
                    <button type="button" id="openTopModal" class="text-sm font-bold text-market-pine">Comparer</button>
                </div>
                <div class="overflow-x-auto">
                    <table class="min-w-[620px] w-full text-left text-sm">
                        <thead class="border-b border-market-line bg-market-cream/40 text-sm uppercase tracking-wide text-slate-500">
                        <tr>
                            <th class="px-5 py-3">Produit</th>
                            <th class="px-5 py-3">Catégorie</th>
                            <th class="px-5 py-3 text-right">Unités</th>
                            <th class="px-5 py-3 text-right">CA</th>
                        </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${topProduits}" var="row" begin="0" end="5">
                                <tr class="border-b border-market-line last:border-b-0 hover:bg-market-cream/30">
                                    <td class="px-5 py-4">
                                        <div class="flex items-center gap-3">
                                            <span class="flex h-9 w-9 items-center justify-center rounded-[0.9rem] bg-market-mint text-sm font-extrabold text-market-pine">${fn:substring(row.designation, 0, 1)}</span>
                                            <span class="font-extrabold text-market-ink">${row.designation}</span>
                                        </div>
                                    </td>
                                    <td class="px-5 py-4 text-slate-500">${row.categorie}</td>
                                    <td class="px-5 py-4 text-right font-bold text-market-ink">${row.quantite_vendue}</td>
                                    <td class="px-5 py-4 text-right font-extrabold text-market-pine"><fmt:formatNumber value="${row.chiffre_affaires}" type="number" maxFractionDigits="0"/> FCFA</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </article>
        </section>
    </main>
</div>

<!-- Modal générique -->
<div id="dashboardModal" class="modal-overlay">
    <div class="modal-container">
        <div class="flex items-center justify-between gap-3 border-b border-market-line pb-3">
            <div>
                <p id="modalEyebrow" class="text-sm font-extrabold uppercase tracking-wide text-market-gold">Synthèse</p>
                <h2 id="modalTitle" class="font-display text-2xl font-bold text-market-pine">Détails</h2>
            </div>
            <button id="closeDashboardModal" class="rounded-[0.9rem] p-2 text-slate-500 hover:bg-market-mint">
                <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 18 18 6"/><path d="m6 6 12 12"/></svg>
            </button>
        </div>
        <div id="modalBody" class="pt-4 text-sm text-slate-600"></div>
    </div>
</div>

<script>
    // Extraction des données pour les graphiques
    const weekLabels = [
        <c:forEach items="${ventesHebdo}" var="row" varStatus="status">'S${row.semaine}'<c:if test="${!status.last}">,</c:if></c:forEach>
    ];
    const weekValues = [
        <c:forEach items="${ventesHebdo}" var="row" varStatus="status">${row.ca_semaine}<c:if test="${!status.last}">,</c:if></c:forEach>
    ];
    const topLabels = [
        <c:forEach items="${topProduits}" var="row" begin="0" end="5" varStatus="status">'${fn:replace(row.designation, "'", "\\'")}'<c:if test="${!status.last}">,</c:if></c:forEach>
    ];
    const topUnits = [
        <c:forEach items="${topProduits}" var="row" begin="0" end="5" varStatus="status">${row.quantite_vendue}<c:if test="${!status.last}">,</c:if></c:forEach>
    ];

    // Configuration des graphiques
    Chart.defaults.font.family = 'Manrope, sans-serif';
    Chart.defaults.color = '#5d697e';

    new Chart(document.getElementById('dashboardRevenueChart'), {
        type: 'line',
        data: {
            labels: weekLabels.reverse(),
            datasets: [{
                data: weekValues.reverse(),
                borderColor: '#1f3fb7',
                backgroundColor: 'rgba(31, 63, 183, 0.12)',
                fill: true,
                borderWidth: 3,
                tension: 0.35,
                pointBackgroundColor: '#f5a000',
                pointBorderColor: '#1f3fb7',
                pointRadius: 4
            }]
        },
        options: {
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        label: function(ctx) {
                            return Number(ctx.raw).toLocaleString('fr-FR') + ' FCFA';
                        }
                    }
                }
            },
            scales: {
                y: { beginAtZero: true, grid: { color: 'rgba(31,63,183,0.08)' } },
                x: { grid: { display: false } }
            }
        }
    });

    new Chart(document.getElementById('stockChart'), {
        type: 'doughnut',
        data: {
            labels: ['Stock normal', 'Alertes'],
            datasets: [{ data: [${stockOk}, ${alertesStock}], backgroundColor: ['#1f3fb7', '#ff4d4f'], borderWidth: 0 }]
        },
        options: {
            maintainAspectRatio: false,
            cutout: '68%',
            plugins: { legend: { position: 'bottom', labels: { boxWidth: 10, usePointStyle: true } } }
        }
    });

    // Gestion du modal générique
    const modal = document.getElementById('dashboardModal');
    const modalTitle = document.getElementById('modalTitle');
    const modalEyebrow = document.getElementById('modalEyebrow');
    const modalBody = document.getElementById('modalBody');
    const closeModalBtn = document.getElementById('closeDashboardModal');

    function openModal(title, eyebrow, bodyHtml) {
        modalTitle.textContent = title;
        modalEyebrow.textContent = eyebrow;
        modalBody.innerHTML = bodyHtml;
        modal.classList.add('active');
    }

    function closeModal() {
        modal.classList.remove('active');
    }

    closeModalBtn.addEventListener('click', closeModal);
    modal.addEventListener('click', (e) => { if (e.target === modal) closeModal(); });

    // Modale Alertes stock
    document.getElementById('openAlertModal')?.addEventListener('click', () => {
        openModal(
            'Alertes stock',
            'Priorité',
            `<div class="grid gap-3 sm:grid-cols-3">
                <div class="rounded-[1rem] bg-red-50 p-4 text-center">
                    <p class="text-2xl font-extrabold text-red-500">${alertesStock}</p>
                    <p class="font-semibold">références à traiter</p>
                </div>
                <div class="rounded-[1rem] bg-market-mint p-4 text-center">
                    <p class="text-2xl font-extrabold text-market-pine">${stockOk}</p>
                    <p class="font-semibold">références OK</p>
                </div>
                <div class="rounded-[1rem] bg-orange-50 p-4 text-center">
                    <p class="text-2xl font-extrabold text-market-gold"><fmt:formatNumber value="${tauxAlerte}" maxFractionDigits="1"/>%</p>
                    <p class="font-semibold">taux d'alerte</p>
                </div>
            </div>
            <div class="mt-4 text-center">
                <a href="${pageContext.request.contextPath}/stock/alertes" class="inline-block rounded-[1rem] bg-market-pine px-4 py-2 text-white">Gérer les alertes</a>
            </div>`
        );
    });

    // Modale Synthèse stock
    document.getElementById('openStockModal')?.addEventListener('click', () => {
        openModal(
            'Synthèse stock',
            'Catalogue',
            `<p class="mb-4 leading-7">Le catalogue contient <strong>${totalProduits}</strong> référence(s). Les alertes représentent <strong><fmt:formatNumber value="${tauxAlerte}" maxFractionDigits="1"/>%</strong> du stock suivi.</p>
            <div class="flex justify-center">
                <a class="rounded-[1rem] bg-market-pine px-4 py-2 font-bold text-white" href="${pageContext.request.contextPath}/stock/alertes">Ouvrir les alertes</a>
            </div>`
        );
    });

    // Modale Top produits avec graphique
    let topModalChart = null;
    document.getElementById('openTopModal')?.addEventListener('click', () => {
        openModal(
            'Comparaison des ventes',
            'Top produits',
            '<div class="h-72"><canvas id="topModalChart"></canvas></div>'
        );
        // Attendre que le modal soit visible pour créer le graphique
        setTimeout(() => {
            const canvas = document.getElementById('topModalChart');
            if (canvas && !topModalChart) {
                topModalChart = new Chart(canvas, {
                    type: 'bar',
                    data: {
                        labels: topLabels,
                        datasets: [{ data: topUnits, backgroundColor: '#1f3fb7', borderRadius: 8 }]
                    },
                    options: {
                        maintainAspectRatio: false,
                        plugins: { legend: { display: false } },
                        scales: { x: { grid: { display: false } }, y: { beginAtZero: true } }
                    }
                });
            }
        }, 100);
    });

    // Sidebar toggle
    const sidebarToggle = document.getElementById('sidebarToggle');
    const appSidebar = document.getElementById('appSidebar');
    if (sidebarToggle && appSidebar) {
        sidebarToggle.addEventListener('click', () => appSidebar.classList.toggle('-translate-x-full'));
    }
</script>
</body>
</html>