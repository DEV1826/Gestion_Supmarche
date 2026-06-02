<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <%@ include file="/views/partials/head.jspf" %>
    <title>Alertes stock</title>
</head>
<body class="app-shell">
<c:set var="activePage" value="alerts"/>
<c:set var="pageTitle" value="Alertes Stock"/>
<c:set var="sidebarBrand" value="MarketPro UI"/>
<c:set var="sidebarSubtitle" value="Terminal Admin v2.0"/>
<c:set var="topbarSearchPlaceholder" value="Rechercher un produit..."/>
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

        <section class="grid gap-5 xl:grid-cols-3">
            <article class="page-card p-8">
                <div class="flex items-start justify-between gap-4">
                    <div>
                        <p class="text-2xl font-display font-semibold text-market-ink sm:text-4xl">Ruptures totales</p>
                        <p class="mt-5 font-display text-5xl font-extrabold text-red-500 sm:text-6xl">${alertes.size()}</p>
                        <p class="mt-5 text-lg text-red-500 sm:text-2xl">+3 depuis hier</p>
                    </div>
                    <div class="rounded-[1.4rem] bg-red-50 p-4 text-red-500">
                        <svg class="h-10 w-10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="12" cy="12" r="9"/><path d="M12 7v6"/><path d="M12 16h.01"/></svg>
                    </div>
                </div>
            </article>
            <article class="page-card p-8">
                <div class="flex items-start justify-between gap-4">
                    <div>
                        <p class="text-2xl font-display font-semibold text-market-ink sm:text-4xl">Stocks critiques</p>
                        <p class="mt-5 font-display text-5xl font-extrabold text-market-gold sm:text-6xl">${totalFiltered}</p>
                        <p class="mt-5 text-lg text-market-gold sm:text-2xl">8 seuils atteints</p>
                    </div>
                    <div class="rounded-[1.4rem] bg-market-mint p-4 text-market-gold">
                        <svg class="h-10 w-10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 4 3 20h18L12 4Z"/><path d="M12 9v5"/><path d="M12 18h.01"/></svg>
                    </div>
                </div>
            </article>
            <article class="page-card p-8">
                <div class="flex items-start justify-between gap-4">
                    <div>
                        <p class="text-2xl font-display font-semibold text-market-ink sm:text-4xl">Commandes necessaires</p>
                        <p class="mt-5 font-display text-5xl font-extrabold text-market-pine sm:text-6xl">${groupesFournisseurs.size()}</p>
                        <p class="mt-5 text-lg text-market-ink sm:text-2xl">Estimees a 2.4M FCFA</p>
                    </div>
                    <div class="rounded-[1.4rem] bg-market-mint p-4 text-market-pine">
                        <svg class="h-10 w-10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M6 6h15l-1.5 7.5H8.2L6 4H3"/><path d="M9 19a1 1 0 1 1 0-.01"/><path d="M18 19a1 1 0 1 1 0-.01"/></svg>
                    </div>
                </div>
            </article>
        </section>

        <section class="page-card overflow-hidden">
            <div class="flex flex-col gap-4 border-b border-market-line px-8 py-6 lg:flex-row lg:items-center lg:justify-between">
                <h2 class="font-display text-3xl font-bold text-market-pine sm:text-4xl">Liste des produits en alerte</h2>
                <form method="get" action="${pageContext.request.contextPath}/stock/alertes" class="flex flex-wrap gap-3">
                    <input class="rounded-[1.2rem] border border-market-line bg-market-cream px-5 py-3 text-lg outline-none" type="text" name="search" value="${search}" placeholder="Produit ou fournisseur">
                    <select class="rounded-[1.2rem] border border-market-line bg-white px-5 py-3 text-lg outline-none" name="categorie">
                        <option value="">Categorie</option>
                        <option value="Alimentation" ${categorie eq 'Alimentation' ? 'selected' : ''}>Alimentation</option>
                        <option value="Hygiene" ${categorie eq 'Hygiene' ? 'selected' : ''}>Hygiene</option>
                        <option value="Electronique" ${categorie eq 'Electronique' ? 'selected' : ''}>Electronique</option>
                    </select>
                    <button class="rounded-[1.2rem] border border-market-line bg-white px-5 py-3 text-lg font-semibold text-market-ink" type="submit">Filtrer</button>
                    <a class="rounded-[1.2rem] border border-market-line bg-white px-5 py-3 text-lg font-semibold text-market-ink" href="${pageContext.request.contextPath}/produits?stock=alert&export=csv">Exporter CSV</a>
                </form>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/stock/alertes">
                <input type="hidden" name="search" value="${search}">
                <input type="hidden" name="categorie" value="${categorie}">
                <input type="hidden" name="stockMax" value="${stockMax}">
                <input type="hidden" name="sort" value="${sort}">
                <input type="hidden" name="size" value="${size}">
                <input type="hidden" name="page" value="${page}">
                <div class="overflow-x-auto">
                    <table class="min-w-[1040px] text-left">
                        <thead class="border-b border-market-line bg-white text-lg font-bold text-market-ink sm:text-2xl">
                            <tr>
                                <th class="px-8 py-6"><input id="toggleAllAlerts" type="checkbox"></th>
                                <th class="px-8 py-6">Produit</th>
                                <th class="px-8 py-6">Fournisseur</th>
                                <th class="px-8 py-6">Stock actuel</th>
                                <th class="px-8 py-6">Seuil d'alerte</th>
                                <th class="px-8 py-6">Statut</th>
                                <th class="px-8 py-6">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${alertes}" var="p">
                                <tr class="border-b border-market-line last:border-b-0">
                                    <td class="px-8 py-6"><input class="alert-checkbox" type="checkbox" name="produitIds" value="${p.id}"></td>
                                    <td class="px-8 py-6">
                                        <div class="flex items-center gap-4">
                                            <div class="flex h-14 w-14 items-center justify-center rounded-[1rem] bg-market-mint text-xl font-bold text-market-pine">${fn:substring(p.designation, 0, 1)}</div>
                                            <div>
                                                <p class="safe-wrap text-xl font-semibold text-market-ink sm:text-3xl">${p.designation}</p>
                                                <p class="mt-2 text-base text-slate-500 sm:text-xl">SKU: ${p.codeBarre}</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-8 py-6 text-lg leading-8 text-market-ink sm:text-2xl sm:leading-10">
                                        <p>${p.fournisseur.raisonSociale}</p>
                                        <p class="text-slate-500">${p.categorie}</p>
                                    </td>
                                    <td class="px-8 py-6 text-xl font-bold ${p.stockActuel <= 0 ? 'text-red-500' : 'text-market-gold'} sm:text-3xl">${p.stockActuel} unites</td>
                                    <td class="px-8 py-6 text-lg text-market-ink sm:text-2xl">${p.stockMinimum} unites</td>
                                    <td class="px-8 py-6">
                                        <span class="rounded-full px-4 py-2 text-sm font-semibold sm:text-xl ${p.stockActuel <= 0 ? 'bg-red-100 text-red-500' : 'bg-market-mint text-market-gold'}">
                                            <c:choose>
                                                <c:when test="${p.stockActuel <= 0}">RUPTURE</c:when>
                                                <c:otherwise>CRITIQUE</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td class="px-8 py-6">
                                        <div class="flex flex-wrap gap-3">
                                            <a class="rounded-full bg-market-gold px-5 py-3 text-sm font-bold text-white sm:text-lg" href="${pageContext.request.contextPath}/fournisseurs/commande?fournisseurId=${p.fournisseur.id}">Commander</a>
                                            <a class="rounded-full bg-market-pine px-5 py-3 text-sm font-bold text-white sm:text-lg" href="${pageContext.request.contextPath}/fournisseurs/commande?fournisseurId=${p.fournisseur.id}&channel=both">Notifier</a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div class="flex flex-col gap-5 border-t border-market-line px-8 py-6 lg:flex-row lg:items-center lg:justify-between">
                    <p class="text-2xl text-slate-500">Affichage de ${((page - 1) * size) + 1}-${((page - 1) * size) + alertes.size()} sur ${totalFiltered} produits en alerte</p>
                    <div class="flex flex-wrap items-center gap-3">
                        <button class="rounded-full bg-market-pine px-8 py-4 text-2xl font-bold text-white shadow-float" type="submit" name="bulkAction" value="notify">Commande Groupee Rapide</button>
                        <button class="rounded-full border border-market-line bg-white px-6 py-4 text-xl font-semibold text-market-ink" type="submit" name="bulkAction" value="pdf">PDF selection</button>
                    </div>
                </div>
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

    const toggleAllAlerts = document.getElementById('toggleAllAlerts');
    const alertCheckboxes = Array.from(document.querySelectorAll('.alert-checkbox'));
    if (toggleAllAlerts) {
        toggleAllAlerts.addEventListener('change', () => {
            alertCheckboxes.forEach((checkbox) => {
                checkbox.checked = toggleAllAlerts.checked;
            });
        });
    }
</script>
</body>
</html>
