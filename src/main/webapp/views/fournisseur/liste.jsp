<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <%@ include file="/views/partials/head.jspf" %>
    <title>Fournisseurs</title>
</head>
<body class="app-shell">
<c:set var="activePage" value="suppliers"/>
<c:set var="pageTitle" value="Gestion des Fournisseurs"/>
<c:set var="pageSubtitle" value="Gerez vos relations partenaires et suivez vos approvisionnements en temps reel."/>
<c:set var="sidebarBrand" value="MarketPro UI"/>
<c:set var="sidebarSubtitle" value="Terminal Admin v2.0"/>
<c:set var="topbarSearchPlaceholder" value="Rechercher un fournisseur"/>
<c:set var="topbarSearchValue" value="${search}"/>
<jsp:include page="/views/partials/sidebar.jsp"/>
<div class="lg:pl-[19rem]">
    <jsp:include page="/views/partials/topbar.jsp"/>
    <main class="space-y-8 px-4 py-6 sm:px-6 lg:px-10">
        <c:if test="${not empty flashMessage}">
            <div class="rounded-[1.6rem] border px-5 py-4 shadow-panel ${flashType eq 'success' ? 'border-emerald-200 bg-emerald-50 text-emerald-700' : 'border-red-200 bg-red-50 text-red-700'}">
                <p class="text-sm font-semibold">${flashMessage}</p>
            </div>
        </c:if>

        <section class="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
            <div>
                <p class="text-2xl font-semibold text-market-pine">Gestion des Fournisseurs</p>
                <p class="mt-2 max-w-4xl text-2xl text-slate-500">Gerez vos relations partenaires et suivez vos approvisionnements en temps reel.</p>
            </div>
            <a href="#add-supplier-form" class="inline-flex items-center justify-center gap-3 rounded-[1.4rem] bg-market-pine px-8 py-5 text-2xl font-bold text-white shadow-float">
                <span>+</span>
                <span>Nouveau Fournisseur</span>
            </a>
        </section>

        <section class="grid gap-5 xl:grid-cols-4">
            <article class="page-card border-l-4 border-l-market-pine p-8">
                <p class="text-2xl uppercase tracking-tight text-market-ink sm:text-4xl">Total Fournisseurs</p>
                <p class="mt-6 font-display text-4xl font-extrabold text-market-pine sm:text-5xl">${totalFournisseurs}</p>
            </article>
            <article class="page-card border-l-4 border-l-market-gold p-8">
                <p class="text-4xl uppercase tracking-tight text-market-ink">Commandes actives</p>
                <p class="mt-6 font-display text-5xl font-extrabold text-market-gold">${produitsEnAlerte.size()}</p>
            </article>
            <article class="page-card border-l-4 border-l-market-moss p-8">
                <p class="text-4xl uppercase tracking-tight text-market-ink">Livraisons du jour</p>
                <p class="mt-6 font-display text-5xl font-extrabold text-market-moss">${fournisseurs.size()}</p>
            </article>
            <article class="page-card border-l-4 border-l-red-400 p-8">
                <p class="text-4xl uppercase tracking-tight text-market-ink">Alertes rupture</p>
                <p class="mt-6 font-display text-5xl font-extrabold text-red-500">${produitsEnAlerte.size()}</p>
            </article>
        </section>

        <section class="page-card p-6">
            <form method="get" action="${pageContext.request.contextPath}/fournisseurs" class="grid gap-4 lg:grid-cols-[1.5fr_repeat(3,minmax(0,1fr))]">
                <input class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="text" name="search" value="${search}" placeholder="Raison sociale, telephone, email">
                <select class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" name="delai">
                    <option value="">Tous les delais</option>
                    <option value="fast" ${delai eq 'fast' ? 'selected' : ''}>Livraison rapide</option>
                    <option value="slow" ${delai eq 'slow' ? 'selected' : ''}>Delai long</option>
                </select>
                <select class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" name="sort">
                    <option value="raison_asc" ${sort eq 'raison_asc' ? 'selected' : ''}>Nom A-Z</option>
                    <option value="delai_asc" ${sort eq 'delai_asc' ? 'selected' : ''}>Delai croissant</option>
                    <option value="delai_desc" ${sort eq 'delai_desc' ? 'selected' : ''}>Delai decroissant</option>
                </select>
                <div class="flex flex-wrap gap-3">
                    <button class="rounded-[1.3rem] bg-market-pine px-6 py-4 text-lg font-bold text-white" type="submit">Filtrer</button>
                    <a class="rounded-[1.3rem] border border-market-line bg-white px-6 py-4 text-lg font-semibold text-slate-600" href="${pageContext.request.contextPath}/fournisseurs">Reinitialiser</a>
                </div>
            </form>
        </section>

        <section class="page-card overflow-hidden">
            <div class="flex flex-col gap-4 border-b border-market-line px-8 py-6 sm:flex-row sm:items-center sm:justify-between">
                <h2 class="font-display text-3xl font-bold text-market-pine sm:text-4xl">Liste des Partenaires</h2>
                <div class="flex flex-wrap gap-3">
                    <span class="rounded-[1.15rem] border border-market-line px-4 py-3 text-xl text-market-pine">Filtrer</span>
                    <span class="rounded-[1.15rem] border border-market-line px-4 py-3 text-xl text-market-pine">Exporter</span>
                </div>
            </div>
            <div class="overflow-x-auto">
                <table class="min-w-[1040px] text-left">
                    <thead class="border-b border-market-line bg-white text-lg font-bold uppercase tracking-wide text-market-pine sm:text-2xl">
                        <tr>
                            <th class="px-8 py-6">Fournisseur</th>
                            <th class="px-8 py-6">Contact</th>
                            <th class="px-8 py-6">Categorie</th>
                            <th class="px-8 py-6">Commandes</th>
                            <th class="px-8 py-6">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${fournisseurs}" var="f">
                            <tr class="border-b border-market-line last:border-b-0">
                                <td class="px-8 py-6">
                                    <div class="flex items-center gap-5">
                                        <div class="flex h-16 w-16 items-center justify-center rounded-full bg-market-mint text-2xl font-bold text-market-pine">
                                            ${fn:substring(f.raisonSociale, 0, 1)}${fn:substring(f.raisonSociale, 1, 2)}
                                        </div>
                                        <div>
                                            <p class="safe-wrap text-xl font-semibold text-market-ink sm:text-3xl">${f.raisonSociale}</p>
                                            <p class="mt-2 text-base text-slate-500 sm:text-xl">ID: FR-${f.id}</p>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-8 py-6 text-lg leading-8 text-market-ink sm:text-2xl sm:leading-10">
                                    <p>${f.telephone}</p>
                                    <p class="text-slate-500">${f.email}</p>
                                </td>
                                <td class="px-8 py-6">
                                    <span class="rounded-full bg-market-mint px-4 py-2 text-sm font-semibold text-market-pine sm:text-2xl">${f.conditionsPaiement}</span>
                                </td>
                                <td class="px-8 py-6 text-xl font-bold text-market-gold sm:text-3xl">${f.delaiLivraisonJours}</td>
                                <td class="px-8 py-6">
                                    <div class="flex flex-wrap gap-3">
                                        <a class="rounded-full bg-market-gold px-4 py-2 text-sm font-bold text-white sm:text-lg" href="${pageContext.request.contextPath}/fournisseurs/commande?fournisseurId=${f.id}">Bon PDF</a>
                                        <a class="rounded-full bg-market-moss px-4 py-2 text-sm font-bold text-white sm:text-lg" href="${pageContext.request.contextPath}/fournisseurs/commande?fournisseurId=${f.id}&channel=email">Email + PDF</a>
                                        <a class="rounded-full bg-market-pine px-4 py-2 text-sm font-bold text-white sm:text-lg" href="${pageContext.request.contextPath}/fournisseurs/modifier?id=${f.id}">Modifier</a>
                                        <form method="post" action="${pageContext.request.contextPath}/fournisseurs/supprimer" onsubmit="return confirm('Supprimer ce fournisseur ?');">
                                            <input type="hidden" name="id" value="${f.id}">
                                            <button class="rounded-full bg-red-500 px-4 py-2 text-sm font-bold text-white sm:text-lg" type="submit">Supprimer</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <div class="flex flex-col gap-4 border-t border-market-line px-8 py-6 lg:flex-row lg:items-center lg:justify-between">
                <p class="text-2xl text-slate-500">Affichage de ${((page - 1) * size) + 1}-${((page - 1) * size) + fournisseurs.size()} sur ${totalFiltered} fournisseurs</p>
                <div class="flex flex-wrap items-center gap-3 text-xl font-semibold">
                    <a class="rounded-[1.15rem] border border-market-line px-5 py-3 ${page <= 1 ? 'pointer-events-none opacity-40' : ''}" href="${pageContext.request.contextPath}/fournisseurs?search=${search}&delai=${delai}&sort=${sort}&size=${size}&page=${page - 1}">Precedent</a>
                    <span class="rounded-[1.15rem] bg-market-pine px-5 py-3 text-white">${page}</span>
                    <span class="rounded-[1.15rem] border border-market-line px-5 py-3">${totalPages}</span>
                    <a class="rounded-[1.15rem] border border-market-line px-5 py-3 ${page >= totalPages ? 'pointer-events-none opacity-40' : ''}" href="${pageContext.request.contextPath}/fournisseurs?search=${search}&delai=${delai}&sort=${sort}&size=${size}&page=${page + 1}">Suivant</a>
                </div>
            </div>
        </section>

        <section class="grid gap-5 xl:grid-cols-[1.25fr_0.55fr]">
            <article class="overflow-hidden rounded-[2rem] bg-market-pine p-8 text-white shadow-panel">
                <h2 class="font-display text-4xl font-bold">Optimisation des Stocks</h2>
                <p class="mt-6 max-w-4xl text-2xl leading-10 text-white/85">L'algorithme suggere de commander 20% de stock supplementaire aupres des partenaires les plus fiables pour anticiper la demande.</p>
                <a href="${pageContext.request.contextPath}/stock/alertes" class="mt-8 inline-flex rounded-[1.3rem] bg-market-gold px-8 py-4 text-2xl font-bold text-white">Consulter l'analyse</a>
            </article>
            <article class="page-card p-8 text-center">
                <div class="mx-auto flex h-28 w-28 items-center justify-center rounded-full bg-market-mint text-market-pine">
                    <svg class="h-12 w-12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9"><circle cx="12" cy="12" r="9"/><path d="M9.5 9a2.5 2.5 0 1 1 4.5 1.5c-.7 1-1.7 1.4-2 2.5"/><path d="M12 17h.01"/></svg>
                </div>
                <h3 class="mt-6 font-display text-4xl font-bold text-market-pine">Support Partenaire</h3>
                <p class="mt-4 text-2xl leading-10 text-slate-500">Une question sur vos integrations fournisseurs ?</p>
                <p class="mt-6 text-2xl font-bold text-market-pine">Acceder au centre d'aide</p>
            </article>
        </section>

        <section id="add-supplier-form" class="page-card p-8">
            <div class="mb-6">
                <h2 class="font-display text-4xl font-bold text-market-pine">Nouveau fournisseur</h2>
                <p class="mt-2 text-xl text-slate-500">Ajout rapide d'un nouveau partenaire.</p>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/fournisseurs/ajouter" class="grid gap-4 md:grid-cols-2 xl:grid-cols-5">
                <input class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="text" name="raisonSociale" placeholder="Raison sociale" required>
                <input class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="text" name="telephone" placeholder="Telephone">
                <input class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="email" name="email" placeholder="Email">
                <input class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="number" name="delaiLivraisonJours" placeholder="Delai livraison">
                <div class="xl:col-span-2">
                    <input class="w-full rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="text" name="conditionsPaiement" placeholder="Categorie ou conditions paiement">
                </div>
                <button class="rounded-[1.3rem] bg-market-gold px-5 py-4 text-xl font-bold text-white" type="submit">Ajouter</button>
            </form>
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
