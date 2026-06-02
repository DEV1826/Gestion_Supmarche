<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <%@ include file="/views/partials/head.jspf" %>
    <title>Dashboard</title>
</head>
<body class="app-shell">
<c:set var="activePage" value="dashboard"/>
<c:set var="pageTitle" value="Tableau de bord"/>
<c:set var="pageSubtitle" value="Vue d'ensemble des ventes, du stock et des actions rapides du terminal."/>
<c:set var="topbarSearchPlaceholder" value="Rechercher un produit ou un ticket..."/>
<jsp:include page="/views/partials/sidebar.jsp"/>
<div class="lg:pl-[19rem]">
    <jsp:include page="/views/partials/topbar.jsp"/>
    <main class="space-y-8 px-4 py-6 sm:px-6 lg:px-10">
        <section class="grid gap-5 xl:grid-cols-3">
            <article class="page-card metric-card p-8">
                <div class="flex items-start justify-between gap-4">
                    <div>
                        <p class="text-[1.15rem] text-market-ink">Ventes du jour</p>
                        <p class="mt-7 font-display text-5xl font-extrabold leading-tight text-market-pine">
                            <fmt:formatNumber value="${kpis.ca_total}" type="number" maxFractionDigits="0"/> FCFA
                        </p>
                        <p class="mt-8 text-2xl font-bold text-market-moss">+12% vs hier</p>
                    </div>
                    <div class="rounded-[1.4rem] bg-market-mint p-4 text-market-pine">
                        <svg class="h-9 w-9" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="4" y="6" width="16" height="12" rx="2"/><path d="M7 10h10"/><path d="M8 14h4"/></svg>
                    </div>
                </div>
            </article>
            <article class="page-card p-8">
                <div class="flex items-start justify-between gap-4">
                    <div>
                        <p class="text-[1.15rem] text-market-ink">Alertes stock</p>
                        <p class="mt-7 font-display text-5xl font-extrabold text-market-ink">${alertesStock}</p>
                        <p class="mt-12 text-2xl font-semibold text-red-500">3 critiques</p>
                    </div>
                    <div class="rounded-[1.4rem] bg-red-50 p-4 text-red-500">
                        <svg class="h-9 w-9" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 4 3 20h18L12 4Z"/><path d="M12 9v5"/><path d="M12 18h.01"/></svg>
                    </div>
                </div>
            </article>
            <article class="page-card p-8">
                <div class="flex items-start justify-between gap-4">
                    <div>
                        <p class="text-[1.15rem] text-market-ink">Nouveaux produits</p>
                        <p class="mt-7 font-display text-5xl font-extrabold text-market-ink">${totalProduits}</p>
                        <p class="mt-12 text-2xl font-semibold text-market-pine">Catalogue actif</p>
                    </div>
                    <div class="rounded-[1.4rem] bg-orange-50 p-4 text-market-gold">
                        <svg class="h-9 w-9" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 5v14"/><path d="M5 12h14"/><rect x="4" y="4" width="16" height="16" rx="3"/></svg>
                    </div>
                </div>
            </article>
        </section>

        <section class="grid gap-5 xl:grid-cols-2">
            <a href="${pageContext.request.contextPath}/ventes/nouvelle" class="relative overflow-hidden rounded-[2.1rem] bg-market-pine p-10 text-white shadow-panel">
                <div class="absolute inset-0 bg-[radial-gradient(circle_at_right,_rgba(255,255,255,0.14),_transparent_40%),linear-gradient(135deg,_rgba(255,255,255,0.08),_transparent)]"></div>
                <div class="relative text-center">
                    <svg class="mx-auto h-16 w-16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M4 7h16v4H4z"/><path d="M6 11h12v8H6z"/><path d="M9 15h1"/><path d="M12 15h1"/><path d="M15 15h1"/></svg>
                    <h2 class="mt-6 font-display text-5xl font-bold">Acces Caisse</h2>
                    <p class="mt-4 text-2xl text-white/85">Lancer une nouvelle vente</p>
                </div>
            </a>
            <a href="${pageContext.request.contextPath}/stats" class="relative overflow-hidden rounded-[2.1rem] bg-market-gold p-10 text-white shadow-panel">
                <div class="absolute inset-0 bg-[radial-gradient(circle_at_top,_rgba(255,255,255,0.18),_transparent_45%),linear-gradient(135deg,_rgba(255,255,255,0.08),_transparent)]"></div>
                <div class="relative text-center">
                    <svg class="mx-auto h-16 w-16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M6 19V9"/><path d="M12 19V5"/><path d="M18 19v-7"/></svg>
                    <h2 class="mt-6 font-display text-5xl font-bold">Statistiques</h2>
                    <p class="mt-4 text-2xl text-white/85">Rapports et analyses detaillees</p>
                </div>
            </a>
        </section>

        <section class="page-card overflow-hidden">
            <div class="flex items-center justify-between gap-4 border-b border-market-line px-8 py-6">
                <div class="flex items-center gap-3">
                    <svg class="h-7 w-7 text-red-500" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m13 2-2 9h5l-5 11 2-9H8l5-11Z"/></svg>
                    <h2 class="font-display text-4xl font-bold text-market-ink">Urgences Stock</h2>
                </div>
                <a class="text-2xl font-semibold text-market-pine" href="${pageContext.request.contextPath}/stock/alertes">Voir tout</a>
            </div>
            <div>
                <c:forEach items="${alertes}" var="p" begin="0" end="2">
                    <div class="flex flex-col gap-4 border-b border-market-line px-8 py-7 last:border-b-0 md:flex-row md:items-center md:justify-between">
                        <div class="flex items-center gap-5">
                            <div class="flex h-16 w-16 items-center justify-center rounded-[1.3rem] bg-market-mint text-2xl font-bold text-market-pine">
                                ${fn:substring(p.categorie, 0, 1)}
                            </div>
                            <div>
                                <p class="text-2xl font-semibold text-market-ink">${p.designation}</p>
                                <p class="mt-1 text-xl text-slate-500">Ref: ${p.codeBarre}</p>
                            </div>
                        </div>
                        <div class="text-right">
                            <p class="text-3xl font-bold ${p.stockActuel <= 0 ? 'text-red-500' : p.stockActuel <= 5 ? 'text-orange-500' : 'text-market-gold'}">${p.stockActuel} unite(s) restante(s)</p>
                            <span class="mt-3 inline-flex rounded-full px-4 py-2 text-lg font-semibold ${p.stockActuel <= 0 ? 'bg-red-100 text-red-600' : p.stockActuel <= 5 ? 'bg-orange-100 text-orange-600' : 'bg-orange-100 text-orange-700'}">
                                <c:choose>
                                    <c:when test="${p.stockActuel <= 0}">RUPTURE</c:when>
                                    <c:when test="${p.stockActuel <= 5}">CRITIQUE</c:when>
                                    <c:otherwise>COMMANDE NECESSAIRE</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                </c:forEach>
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
