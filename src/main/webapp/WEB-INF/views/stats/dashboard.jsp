<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <%@ include file="/WEB-INF/views/partials/head.jspf" %>
    <title>Statistiques</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .stats-chart { height: 18rem; }
        .stats-chart-sm { height: 14rem; }
        .modal-overlay {
            position: fixed;
            inset: 0;
            background: rgba(23, 29, 45, 0.46);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            opacity: 0;
            visibility: hidden;
            transition: opacity 160ms ease, visibility 160ms ease;
        }
        .modal-overlay.active {
            opacity: 1;
            visibility: visible;
        }
        .modal-container {
            background: white;
            border-radius: 1.5rem;
            width: 90%;
            max-width: 720px;
            max-height: 85vh;
            overflow-y: auto;
            padding: 1.5rem;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
        }
        @media (max-width: 640px) {
            .stats-chart { height: 14rem; }
            .stats-chart-sm { height: 12rem; }
        }
    </style>
</head>
<body class="app-shell">
<c:set var="activePage" value="stats"/>
<c:set var="pageTitle" value="Analyses &amp; Statistiques"/>
<c:set var="pageSubtitle" value="Performance, catégories et meilleures ventes."/>
<c:set var="topbarSearchPlaceholder" value="Rechercher..."/>
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp"/>
<jsp:include page="/WEB-INF/views/partials/panier-sidebar.jsp"/>

<div class="lg:pl-[19rem]">
    <jsp:include page="/WEB-INF/views/partials/topbar.jsp"/>
    <main class="space-y-6 px-4 py-5 sm:px-6 lg:px-8">
        <!-- Ligne de titre + boutons période -->
        <div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
            <div>
                <h1 class="font-display text-2xl font-extrabold text-market-pine sm:text-3xl">Analyses &amp; Statistiques</h1>
                <p class="mt-1 text-sm text-slate-500">Lecture compacte des ventes, catégories et risques stock.</p>
            </div>
            <div class="flex flex-wrap gap-2">
                <button class="period-btn rounded-full bg-market-pine px-4 py-2 text-sm font-bold text-white" data-label="7 derniers jours">7 jours</button>
                <button class="period-btn rounded-full border border-market-line bg-white px-4 py-2 text-sm font-semibold text-market-ink" data-label="Vue mensuelle">Mensuel</button>
                <button class="period-btn rounded-full border border-market-line bg-white px-4 py-2 text-sm font-semibold text-market-ink" data-label="Vue annuelle">Annuel</button>
                <button id="openPeriodModal" class="rounded-full border border-market-pine px-4 py-2 text-sm font-bold text-market-pine">Personnalisé</button>
            </div>
        </div>

        <!-- 5 indicateurs clés -->
        <div class="grid gap-4 sm:grid-cols-2 xl:grid-cols-5">
            <div class="page-card p-5">
                <p class="text-sm font-extrabold uppercase tracking-wide text-slate-500">CA total</p>
                <p class="mt-2 font-display text-3xl font-extrabold text-market-pine"><fmt:formatNumber value="${kpis.ca_total}" type="number" maxFractionDigits="0"/></p>
                <p class="mt-1 text-sm font-semibold text-slate-500">FCFA</p>
            </div>
            <div class="page-card p-5">
                <p class="text-sm font-extrabold uppercase tracking-wide text-slate-500">Panier moyen</p>
                <p class="mt-2 font-display text-3xl font-extrabold text-market-pine"><fmt:formatNumber value="${kpis.panier_moyen}" type="number" maxFractionDigits="0"/></p>
                <p class="mt-1 text-sm font-semibold text-market-gold">Objectif 15 000 FCFA</p>
            </div>
            <div class="page-card p-5">
                <p class="text-sm font-extrabold uppercase tracking-wide text-slate-500">Tickets</p>
                <p class="mt-2 font-display text-3xl font-extrabold text-market-ink">${kpis.nb_ventes}</p>
                <p class="mt-1 text-sm font-semibold text-slate-500">transactions</p>
            </div>
            <div class="page-card border-l-4 border-l-red-400 p-5">
                <p class="text-sm font-extrabold uppercase tracking-wide text-red-500">Alertes stock</p>
                <p class="mt-2 font-display text-3xl font-extrabold text-red-500">${alertesStock}</p>
                <p class="mt-1 text-sm font-semibold text-slate-500">références critiques</p>
            </div>
            <div class="page-card p-5">
                <p class="text-sm font-extrabold uppercase tracking-wide text-slate-500">Catalogue</p>
                <p class="mt-2 font-display text-3xl font-extrabold text-market-ink">${totalProduits}</p>
                <p class="mt-1 text-sm font-semibold text-market-moss">${totalFournisseurs} fournisseur(s)</p>
            </div>
        </div>

        <!-- Graphiques principaux -->
        <div class="grid gap-4 xl:grid-cols-[1.45fr_0.75fr]">
            <div class="page-card p-5">
                <div class="flex flex-wrap items-start justify-between gap-3">
                    <div>
                        <h2 class="font-display text-xl font-bold text-market-pine sm:text-2xl">Évolution du CA</h2>
                        <p id="periodLabel" class="mt-1 text-sm text-slate-500">7 derniers jours</p>
                    </div>
                    <div class="flex rounded-lg border border-market-line bg-white p-1">
                        <button class="chart-mode rounded-md bg-market-mint px-3 py-1.5 text-sm font-bold text-market-pine" data-mode="line">Ligne</button>
                        <button class="chart-mode rounded-md px-3 py-1.5 text-sm font-semibold text-slate-500" data-mode="bar">Barres</button>
                    </div>
                </div>
                <div class="stats-chart mt-4 rounded-xl bg-slate-50 p-2">
                    <canvas id="weekChart"></canvas>
                </div>
            </div>

            <div class="page-card p-5">
                <div class="flex items-start justify-between gap-3">
                    <div>
                        <h2 class="font-display text-xl font-bold text-market-pine sm:text-2xl">Répartition catégories</h2>
                        <p class="mt-1 text-sm text-slate-500">CA par famille</p>
                    </div>
                    <button id="openCategoryModal" class="rounded-lg border border-market-line bg-white p-2 text-market-pine hover:bg-market-cream" title="Détails catégories">
                        <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19V5"/><path d="M8 17V9"/><path d="M12 19V3"/><path d="M16 15v-5"/><path d="M20 19V7"/></svg>
                    </button>
                </div>
                <div class="stats-chart-sm mt-4">
                    <canvas id="categoryChart"></canvas>
                </div>
            </div>
        </div>

        <!-- Top catégories et meilleures ventes -->
        <div class="grid gap-4 xl:grid-cols-[0.78fr_1.22fr]">
            <div class="page-card p-5">
                <h2 class="font-display text-xl font-bold text-market-pine sm:text-2xl">Top catégories</h2>
                <div class="mt-4 space-y-4">
                    <c:forEach items="${caParCategorie}" var="row" begin="0" end="5">
                        <c:set var="shareValue" value="${kpis.ca_total > 0 ? (row.ca_total * 100.0) / kpis.ca_total : 0}" />
                        <div>
                            <div class="mb-1 flex items-center justify-between gap-3 text-sm font-bold text-market-ink">
                                <span class="truncate">${row.categorie}</span>
                                <span><fmt:formatNumber value="${shareValue}" maxFractionDigits="0"/>%</span>
                            </div>
                            <div class="h-2 rounded-full bg-market-mint">
                                <div class="h-2 rounded-full bg-market-pine" style="width: ${shareValue > 100 ? 100 : shareValue}%;"></div>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty caParCategorie}">
                        <p class="text-sm text-slate-500">Aucune vente par catégorie.</p>
                    </c:if>
                </div>
            </div>

            <div class="page-card overflow-hidden">
                <div class="flex items-center justify-between gap-3 border-b border-market-line px-5 py-4">
                    <h2 class="font-display text-xl font-bold text-market-pine sm:text-2xl">Meilleures ventes</h2>
                    <button id="openTopModal" class="rounded-full bg-market-mint px-4 py-2 text-sm font-bold text-market-pine hover:bg-market-cream">Détail</button>
                </div>
                <div class="overflow-x-auto">
                    <table class="min-w-[760px] w-full text-left text-sm">
                        <thead class="border-b border-market-line bg-market-cream/40 text-sm uppercase tracking-wide text-slate-500">
                        <tr>
                            <th class="px-4 py-3">Produit</th>
                            <th class="px-4 py-3">Catégorie</th>
                            <th class="px-4 py-3 text-right">Unités</th>
                            <th class="px-4 py-3 text-right">CA</th>
                            <th class="px-4 py-3">Statut</th>
                        </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${topProduits}" var="row" begin="0" end="7">
                                <tr class="border-b border-market-line last:border-b-0 hover:bg-market-cream/30">
                                    <td class="px-4 py-3">
                                        <div class="flex items-center gap-3">
                                            <span class="flex h-8 w-8 items-center justify-center rounded-lg bg-market-mint text-sm font-extrabold text-market-pine">${fn:substring(row.designation, 0, 1)}</span>
                                            <span class="font-semibold text-market-ink">${row.designation}</span>
                                        </div>
                                    </td>
                                    <td class="px-4 py-3 text-slate-500">${row.categorie}</td>
                                    <td class="px-4 py-3 text-right font-bold text-market-ink">${row.quantite_vendue}</td>
                                    <td class="px-4 py-3 text-right font-extrabold text-market-pine"><fmt:formatNumber value="${row.chiffre_affaires}" type="number" maxFractionDigits="0"/> FCFA</td>
                                    <td class="px-4 py-3"><span class="rounded-full bg-market-mint px-3 py-1 text-sm font-bold text-market-pine">Actif</span></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty topProduits}">
                                <tr><td colspan="5" class="px-4 py-8 text-center text-sm text-slate-500">Aucune vente enregistrée.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- Modal générique -->
<div id="statsModal" class="modal-overlay">
    <div class="modal-container">
        <div class="flex items-center justify-between gap-3 border-b border-market-line pb-3">
            <div>
                <p id="statsModalEyebrow" class="text-sm font-extrabold uppercase tracking-wide text-market-gold">Analyse</p>
                <h2 id="statsModalTitle" class="font-display text-xl font-bold text-market-pine sm:text-2xl">Détails</h2>
            </div>
            <button id="closeStatsModal" class="rounded-lg p-2 text-slate-500 hover:bg-market-cream">
                <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 18 18 6"/><path d="m6 6 12 12"/></svg>
            </button>
        </div>
        <div id="statsModalBody" class="pt-4 text-sm text-slate-600"></div>
    </div>
</div>

<script>
    // Données JSON (injection JSP)
    const weekLabels = [
        <c:forEach items="${ventesHebdo}" var="row" varStatus="status">'S${row.semaine}'<c:if test="${!status.last}">,</c:if></c:forEach>
    ];
    const weekValues = [
        <c:forEach items="${ventesHebdo}" var="row" varStatus="status">${row.ca_semaine}<c:if test="${!status.last}">,</c:if></c:forEach>
    ];
    const categoryLabels = [
        <c:forEach items="${caParCategorie}" var="row" varStatus="status">'${fn:replace(row.categorie, "'", "\\'")}'<c:if test="${!status.last}">,</c:if></c:forEach>
    ];
    const categoryValues = [
        <c:forEach items="${caParCategorie}" var="row" varStatus="status">${row.ca_total}<c:if test="${!status.last}">,</c:if></c:forEach>
    ];
    const topLabels = [
        <c:forEach items="${topProduits}" var="row" begin="0" end="7" varStatus="status">'${fn:replace(row.designation, "'", "\\'")}'<c:if test="${!status.last}">,</c:if></c:forEach>
    ];
    const topValues = [
        <c:forEach items="${topProduits}" var="row" begin="0" end="7" varStatus="status">${row.chiffre_affaires}<c:if test="${!status.last}">,</c:if></c:forEach>
    ];

    Chart.defaults.font.family = 'Manrope, sans-serif';
    Chart.defaults.color = '#5d697e';

    const chartData = {
        labels: [...weekLabels].reverse(),
        datasets: [{
            data: [...weekValues].reverse(),
            borderColor: '#1f3fb7',
            backgroundColor: 'rgba(31, 63, 183, 0.13)',
            fill: true,
            borderWidth: 3,
            tension: 0.35,
            pointBackgroundColor: '#f5a000',
            pointRadius: 4
        }]
    };

    let weekChart = new Chart(document.getElementById('weekChart'), {
        type: 'line',
        data: chartData,
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

    // Graphique catégories (donut)
    new Chart(document.getElementById('categoryChart'), {
        type: 'doughnut',
        data: {
            labels: categoryLabels,
            datasets: [{ data: categoryValues, backgroundColor: ['#1f3fb7', '#f5a000', '#2448d8', '#ff4d4f', '#7aa5ff', '#171d2d'], borderWidth: 0 }]
        },
        options: { maintainAspectRatio: false, cutout: '64%', plugins: { legend: { position: 'bottom', labels: { boxWidth: 10, usePointStyle: true, font: { size: 11 } } } } }
    });

    // Changement type graphique (ligne/barres)
    document.querySelectorAll('.chart-mode').forEach(btn => {
        btn.addEventListener('click', () => {
            document.querySelectorAll('.chart-mode').forEach(b => {
                b.classList.remove('bg-market-mint', 'text-market-pine');
                b.classList.add('text-slate-500');
            });
            btn.classList.add('bg-market-mint', 'text-market-pine');
            btn.classList.remove('text-slate-500');
            weekChart.destroy();
            weekChart = new Chart(document.getElementById('weekChart'), {
                type: btn.dataset.mode,
                data: chartData,
                options: {
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false }, tooltip: { callbacks: { label: ctx => Number(ctx.raw).toLocaleString('fr-FR') + ' FCFA' } } },
                    scales: { y: { beginAtZero: true }, x: { grid: { display: false } } }
                }
            });
        });
    });

    // Sélecteur de période (simulation UI)
    document.querySelectorAll('.period-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            document.querySelectorAll('.period-btn').forEach(b => {
                b.classList.remove('bg-market-pine', 'text-white');
                b.classList.add('border', 'border-market-line', 'bg-white', 'text-market-ink');
            });
            btn.classList.add('bg-market-pine', 'text-white');
            btn.classList.remove('border', 'border-market-line', 'bg-white', 'text-market-ink');
            document.getElementById('periodLabel').textContent = btn.dataset.label;
            // Ici, vous pourriez appeler une API pour recharger les données
        });
    });

    // Modal générique
    const modal = document.getElementById('statsModal');
    const modalTitle = document.getElementById('statsModalTitle');
    const modalEyebrow = document.getElementById('statsModalEyebrow');
    const modalBody = document.getElementById('statsModalBody');
    const closeModalBtn = document.getElementById('closeStatsModal');

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

    // Modal période personnalisée
    document.getElementById('openPeriodModal')?.addEventListener('click', () => {
        openModal(
            'Période personnalisée',
            'Filtre',
            `<form class="grid gap-4 sm:grid-cols-2">
                <input class="rounded-xl border border-market-line bg-market-cream px-4 py-2 text-sm outline-none" type="date" placeholder="Date début">
                <input class="rounded-xl border border-market-line bg-market-cream px-4 py-2 text-sm outline-none" type="date" placeholder="Date fin">
                <button type="button" class="sm:col-span-2 rounded-xl bg-market-pine px-4 py-2 text-sm font-bold text-white">Appliquer</button>
            </form>`
        );
    });

    // Modal catégories (graphique en barres)
    document.getElementById('openCategoryModal')?.addEventListener('click', () => {
        openModal(
            'Détail par catégorie',
            'Chiffre d\'affaires',
            '<div class="h-80"><canvas id="categoryModalChart"></canvas></div>'
        );
        setTimeout(() => {
            const canvas = document.getElementById('categoryModalChart');
            if (canvas && !canvas.dataset.ready) {
                canvas.dataset.ready = 'true';
                new Chart(canvas, {
                    type: 'bar',
                    data: { labels: categoryLabels, datasets: [{ data: categoryValues, backgroundColor: '#1f3fb7', borderRadius: 8 }] },
                    options: { maintainAspectRatio: false, plugins: { legend: { display: false } }, scales: { y: { beginAtZero: true, ticks: { callback: val => val.toLocaleString('fr-FR') + ' FCFA' } } } }
                });
            }
        }, 150);
    });

    // Modal top produits (graphique horizontal)
    document.getElementById('openTopModal')?.addEventListener('click', () => {
        openModal(
            'Top produits (CA)',
            'Comparaison',
            '<div class="h-96"><canvas id="topModalChart"></canvas></div>'
        );
        setTimeout(() => {
            const canvas = document.getElementById('topModalChart');
            if (canvas && !canvas.dataset.ready) {
                canvas.dataset.ready = 'true';
                new Chart(canvas, {
                    type: 'bar',
                    data: { labels: topLabels, datasets: [{ data: topValues, backgroundColor: '#f5a000', borderRadius: 8 }] },
                    options: { indexAxis: 'y', maintainAspectRatio: false, plugins: { legend: { display: false } }, scales: { x: { beginAtZero: true, ticks: { callback: val => val.toLocaleString('fr-FR') + ' FCFA' } }, y: { grid: { display: false } } } }
                });
            }
        }, 150);
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