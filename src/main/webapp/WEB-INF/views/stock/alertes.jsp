<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <%@ include file="/WEB-INF/views/partials/head.jspf" %>
    <title>Alertes stock | Supermarché</title>
    <style>
        .alert-card {
            transition: all 0.2s ease;
        }
        .alert-checkbox {
            width: 1.2rem;
            height: 1.2rem;
            cursor: pointer;
        }
        @media (max-width: 768px) {
            .alert-table th, .alert-table td {
                padding: 0.75rem 1rem;
            }
            .btn-sm {
                padding: 0.5rem 1rem;
                font-size: 0.875rem;
            }
        }
    </style>
</head>
<body class="app-shell">
<c:set var="activePage" value="alerts"/>
<c:set var="pageTitle" value="Alertes Stock"/>
<c:set var="pageSubtitle" value="Suivez les ruptures et stocks critiques."/>
<c:set var="topbarSearchPlaceholder" value="Rechercher un produit ou fournisseur..."/>
<c:set var="topbarSearchValue" value="${search}"/>
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp"/>
<jsp:include page="/WEB-INF/views/partials/panier-sidebar.jsp"/>

<div class="lg:pl-[19rem]">
    <jsp:include page="/WEB-INF/views/partials/topbar.jsp"/>
    <main class="space-y-6 px-4 py-5 sm:px-6 lg:px-8">
        <c:if test="${not empty flashMessage}">
            <div class="rounded-xl border px-4 py-3 shadow-sm ${flashType eq 'success' ? 'border-emerald-200 bg-emerald-50 text-emerald-700' : 'border-red-200 bg-red-50 text-red-700'}">
                <p class="text-base font-semibold">${flashMessage}</p>
            </div>
        </c:if>

        <!-- 3 cartes KPI -->
        <div class="grid gap-4 md:grid-cols-3">
            <!-- Ruptures totales -->
            <div class="page-card p-5">
                <div class="flex items-start justify-between gap-3">
                    <div>
                        <p class="text-sm font-extrabold uppercase tracking-wide text-slate-500">Ruptures totales</p>
                        <p class="mt-2 font-display text-4xl font-extrabold text-red-500">${alertes.size()}</p>
                        <p class="mt-1 text-sm font-semibold text-red-500">+3 depuis hier</p>
                    </div>
                    <div class="rounded-xl bg-red-50 p-3 text-red-500">
                        <svg class="h-7 w-7" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="12" cy="12" r="9"/><path d="M12 7v6"/><path d="M12 16h.01"/></svg>
                    </div>
                </div>
            </div>

            <!-- Stocks critiques -->
            <div class="page-card p-5">
                <div class="flex items-start justify-between gap-3">
                    <div>
                        <p class="text-sm font-extrabold uppercase tracking-wide text-slate-500">Stocks critiques</p>
                        <p class="mt-2 font-display text-4xl font-extrabold text-market-gold">${totalFiltered}</p>
                        <p class="mt-1 text-sm font-semibold text-market-gold">8 seuils atteints</p>
                    </div>
                    <div class="rounded-xl bg-market-mint p-3 text-market-gold">
                        <svg class="h-7 w-7" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 4 3 20h18L12 4Z"/><path d="M12 9v5"/><path d="M12 18h.01"/></svg>
                    </div>
                </div>
            </div>

            <!-- Commandes nécessaires -->
            <div class="page-card p-5">
                <div class="flex items-start justify-between gap-3">
                    <div>
                        <p class="text-sm font-extrabold uppercase tracking-wide text-slate-500">Commandes nécessaires</p>
                        <p class="mt-2 font-display text-4xl font-extrabold text-market-pine">${groupesFournisseurs.size()}</p>
                        <p class="mt-1 text-sm font-semibold text-market-ink">Estimées 2.4M FCFA</p>
                    </div>
                    <div class="rounded-xl bg-market-mint p-3 text-market-pine">
                        <svg class="h-7 w-7" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M6 6h15l-1.5 7.5H8.2L6 4H3"/><path d="M9 19a1 1 0 1 1 0-.01"/><path d="M18 19a1 1 0 1 1 0-.01"/></svg>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bloc filtre + tableau -->
        <div class="page-card overflow-hidden">
            <div class="flex flex-col gap-3 border-b border-market-line px-5 py-4 sm:flex-row sm:items-center sm:justify-between">
                <h2 class="font-display text-xl font-bold text-market-pine sm:text-2xl">Produits en alerte</h2>
                <form method="get" action="${pageContext.request.contextPath}/stock/alertes" class="flex flex-wrap gap-2">
                    <input class="rounded-lg border border-market-line bg-market-cream px-4 py-2 text-base outline-none" type="text" name="search" value="${search}" placeholder="Nom / SKU / Fournisseur">
                    <select class="rounded-lg border border-market-line bg-white px-4 py-2 text-base outline-none" name="categorie">
                        <option value="">Toutes catégories</option>
                        <option value="Alimentation" ${categorie eq 'Alimentation' ? 'selected' : ''}>Alimentation</option>
                        <option value="Hygiene" ${categorie eq 'Hygiene' ? 'selected' : ''}>Hygiène</option>
                        <option value="Electronique" ${categorie eq 'Electronique' ? 'selected' : ''}>Électronique</option>
                    </select>
                    <button class="rounded-lg bg-market-pine px-4 py-2 text-base font-bold text-white" type="submit">Filtrer</button>
                    <a class="rounded-lg border border-market-line bg-white px-4 py-2 text-base font-semibold text-market-ink" href="${pageContext.request.contextPath}/produits?stock=alert&export=csv">Exporter CSV</a>
                </form>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/stock/alertes">
                <!-- Champs cachés pour la pagination / filtres -->
                <input type="hidden" name="search" value="${search}">
                <input type="hidden" name="categorie" value="${categorie}">
                <input type="hidden" name="stockMax" value="${stockMax}">
                <input type="hidden" name="sort" value="${sort}">
                <input type="hidden" name="size" value="${size}">
                <input type="hidden" name="page" value="${page}">

                <div class="overflow-x-auto">
                    <table class="alert-table min-w-[900px] w-full text-left text-sm">
                        <thead class="border-b border-market-line bg-market-cream/30 text-sm font-bold text-market-pine">
                        <tr>
                            <th class="px-4 py-3 w-8"><input id="toggleAllAlerts" type="checkbox" class="alert-checkbox"></th>
                            <th class="px-4 py-3">Produit</th>
                            <th class="px-4 py-3">Fournisseur</th>
                            <th class="px-4 py-3">Stock actuel</th>
                            <th class="px-4 py-3">Seuil alerte</th>
                            <th class="px-4 py-3">Statut</th>
                            <th class="px-4 py-3">Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${alertes}" var="p">
                                <tr class="border-b border-market-line last:border-b-0 hover:bg-market-cream/20">
                                    <td class="px-4 py-3"><input class="alert-checkbox" type="checkbox" name="produitIds" value="${p.id}"></td>
                                    <td class="px-4 py-3">
                                        <div class="flex items-center gap-3">
                                            <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-market-mint text-lg font-bold text-market-pine">${fn:substring(p.designation, 0, 1)}</div>
                                            <div>
                                                <p class="font-semibold text-market-ink">${p.designation}</p>
                                                <p class="text-xs text-slate-500">SKU: ${p.codeBarre}</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-4 py-3">
                                        <p class="font-medium text-market-ink">${p.fournisseur.raisonSociale}</p>
                                        <p class="text-xs text-slate-500">${p.categorie}</p>
                                    </td>
                                    <td class="px-4 py-3 font-bold ${p.stockActuel <= 0 ? 'text-red-500' : 'text-market-gold'}">${p.stockActuel} u.</td>
                                    <td class="px-4 py-3 text-market-ink">${p.stockMinimum} u.</td>
                                    <td class="px-4 py-3">
                                        <span class="rounded-full px-3 py-1 text-sm font-bold ${p.stockActuel <= 0 ? 'bg-red-100 text-red-600' : 'bg-orange-100 text-orange-600'}">
                                            <c:choose>
                                                <c:when test="${p.stockActuel <= 0}">RUPTURE</c:when>
                                                <c:otherwise>CRITIQUE</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td class="px-4 py-3">
                                        <div class="flex flex-wrap gap-2">
                                            <a href="${pageContext.request.contextPath}/fournisseurs/commande?fournisseurId=${p.fournisseur.id}" class="rounded-lg bg-market-gold px-3 py-1.5 text-sm font-bold text-white hover:bg-amber-600">Commander</a>
                                            <a href="${pageContext.request.contextPath}/fournisseurs/commande?fournisseurId=${p.fournisseur.id}&channel=both" class="rounded-lg bg-market-pine px-3 py-1.5 text-sm font-bold text-white hover:bg-opacity-90">Notifier</a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty alertes}">
                                <tr><td colspan="7" class="px-4 py-8 text-center text-base text-slate-500">Aucun produit en alerte.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <!-- Barre d'actions groupées + pagination -->
                <div class="flex flex-col gap-3 border-t border-market-line px-5 py-4 sm:flex-row sm:items-center sm:justify-between">
                    <p class="text-base text-slate-500">Affichage de ${((page - 1) * size) + 1} à ${((page - 1) * size) + fn:length(alertes)} sur ${totalFiltered} alertes</p>
                    <div class="flex flex-wrap gap-3">
                        <button type="submit" name="bulkAction" value="notify" class="rounded-full bg-market-pine px-5 py-2 text-base font-bold text-white shadow-sm hover:bg-opacity-90">
                            Commander groupée
                        </button>
                        <button type="submit" name="bulkAction" value="pdf" class="rounded-full border border-market-line bg-white px-5 py-2 text-base font-semibold text-market-ink hover:bg-market-cream">
                            PDF sélection
                        </button>
                    </div>
                </div>

                <!-- Pagination si nécessaire (à intégrer selon votre logique) -->
                <c:if test="${totalPages > 1}">
                    <div class="flex justify-center gap-2 border-t border-market-line px-5 py-4">
                        <a class="rounded-lg border border-market-line px-3 py-1.5 text-base ${page <= 1 ? 'pointer-events-none opacity-40' : ''}" href="${pageContext.request.contextPath}/stock/alertes?search=${search}&categorie=${categorie}&size=${size}&page=${page - 1}">&lsaquo;</a>
                        <span class="rounded-lg bg-market-pine px-3 py-1.5 text-base text-white">${page}</span>
                        <span class="rounded-lg border border-market-line px-3 py-1.5 text-base">${totalPages}</span>
                        <a class="rounded-lg border border-market-line px-3 py-1.5 text-base ${page >= totalPages ? 'pointer-events-none opacity-40' : ''}" href="${pageContext.request.contextPath}/stock/alertes?search=${search}&categorie=${categorie}&size=${size}&page=${page + 1}">&rsaquo;</a>
                    </div>
                </c:if>
            </form>
        </div>
    </main>
</div>

<script>
    // Sidebar toggle
    const sidebarToggle = document.getElementById('sidebarToggle');
    const appSidebar = document.getElementById('appSidebar');
    if (sidebarToggle && appSidebar) {
        sidebarToggle.addEventListener('click', () => {
            appSidebar.classList.toggle('-translate-x-full');
        });
    }

    // Sélection/déselection tout
    const toggleAll = document.getElementById('toggleAllAlerts');
    const checkboxes = document.querySelectorAll('.alert-checkbox');
    if (toggleAll) {
        toggleAll.addEventListener('change', () => {
            checkboxes.forEach(cb => cb.checked = toggleAll.checked);
        });
    }
</script>
</body>
</html>