<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <%@ include file="/WEB-INF/views/partials/head.jspf" %>
    <title>Produits</title>
    <style>
        /* Styles pour le modal */
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
            border-radius: 2rem;
            width: 90%;
            max-width: 800px;
            max-height: 85vh;
            overflow-y: auto;
            padding: 1.5rem;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
        }
        /* Filtres toggle */
        .filters-panel {
            transition: all 0.2s ease;
        }
        .filters-panel.hidden-panel {
            display: none;
        }
        /* Tableau compact */
        .compact-table th, .compact-table td {
            padding: 0.75rem 1rem;
        }
        @media (min-width: 640px) {
            .compact-table th, .compact-table td {
                padding: 1rem 1.5rem;
            }
        }
    </style>
</head>
<body class="app-shell">
<c:set var="activePage" value="products"/>
<c:set var="pageTitle" value="Gestion du Stock"/>
<c:set var="pageSubtitle" value="Inventaire, categories, valeur de stock et actions rapides."/>
<c:set var="topbarSearchPlaceholder" value="Rechercher par nom ou SKU..."/>
<c:set var="topbarSearchValue" value="${search}"/>
<c:set var="categories" value="${fn:split('', '')}" />
<c:forEach items="${produits}" var="p">
   <c:if test="${not fn:contains(categories, p.categorie)}">
      <c:set var="categories" value="${categories} ${p.categorie}" />
   </c:if>
</c:forEach>

<jsp:include page="/WEB-INF/views/partials/sidebar.jsp"/>
<jsp:include page="/WEB-INF/views/partials/panier-sidebar.jsp"/>
<div class="lg:pl-[19rem]">
    <jsp:include page="/WEB-INF/views/partials/topbar.jsp"/>
    <main class="space-y-6 px-4 py-5 sm:px-6 lg:px-8">
        <c:if test="${not empty flashMessage}">
            <div class="rounded-[1.2rem] border px-4 py-3 shadow-panel ${flashType eq 'success' ? 'border-emerald-200 bg-emerald-50 text-emerald-700' : 'border-red-200 bg-red-50 text-red-700'}">
                <p class="text-sm font-semibold">${flashMessage}</p>
            </div>
        </c:if>

        <!-- Cartes stats -->
        <section class="grid gap-4 md:grid-cols-3">
            <article class="page-card relative overflow-hidden p-5 md:p-6">
                <div class="absolute right-0 top-0 h-full w-32 bg-[linear-gradient(90deg,transparent,rgba(31,63,183,0.05))]"></div>
                <p class="text-lg font-display font-semibold uppercase text-slate-500 sm:text-2xl">Catalogue total</p>
                <p class="mt-2 font-display text-3xl font-extrabold text-market-pine sm:text-4xl">${totalProduits} articles</p>
                <p class="mt-4 text-base font-semibold text-market-moss sm:text-lg">+12 nouveaux ce mois</p>
            </article>
            <article class="page-card border border-red-200 p-5 md:p-6">
                <p class="text-lg font-display font-semibold uppercase text-red-500 sm:text-2xl">Ruptures</p>
                <p class="mt-2 font-display text-3xl font-extrabold text-red-500 sm:text-4xl">${totalAlertes}</p>
                <p class="mt-4 text-base text-slate-500 sm:text-lg">Nécessite réapprovisionnement</p>
            </article>
            <article class="page-card border border-orange-200 p-5 md:p-6">
                <p class="text-lg font-display font-semibold uppercase text-market-gold sm:text-2xl">Valeur stock</p>
                <p class="mt-2 font-display text-3xl font-extrabold text-market-gold sm:text-4xl">FCFA</p>
                <p class="mt-4 text-base text-slate-500 sm:text-lg">Estimation totale</p>
            </article>
        </section>

        <!-- Barre d'actions : sélecteur catégorie + boutons -->
        <div class="flex flex-wrap items-center justify-between gap-3">
            <!-- Menu déroulant catégories (dynamique) -->
            <div class="flex items-center gap-3">
                <label class="text-sm font-semibold text-slate-600">Catégorie :</label>
                <select id="categorieSelect" class="rounded-full border border-market-line bg-market-cream px-4 py-2 text-sm font-medium outline-none focus:ring-2 focus:ring-market-pine">
                    <option value="">Toutes les catégories</option>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat}" ${categorie eq cat ? 'selected' : ''}>${cat}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="flex gap-3">
                <button id="toggleFiltersBtn" class="inline-flex items-center gap-2 rounded-full bg-market-mint px-4 py-2 text-sm font-bold text-market-pine shadow-sm hover:bg-market-cream">
                    <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.293A1 1 0 013 6.586V4z"/></svg>
                    Filtres
                </button>
                <button id="openModalBtn" class="inline-flex items-center gap-2 rounded-full bg-market-gold px-4 py-2 text-sm font-bold text-white shadow-sm hover:bg-amber-600">
                    <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
                    Nouveau produit
                </button>
            </div>
        </div>

        <!-- Panneau filtres (caché par défaut) -->
        <div id="filtersPanel" class="filters-panel hidden-panel page-card p-4">
            <form method="get" action="${pageContext.request.contextPath}/produits" class="grid gap-3 sm:grid-cols-2 lg:grid-cols-5">
                <input type="hidden" name="categorie" id="hiddenCategorie" value="${categorie}">
                <input class="rounded-xl border border-market-line bg-market-cream px-3 py-2 text-sm outline-none" type="text" name="search" value="${search}" placeholder="Recherche designation / code">
                <select class="rounded-xl border border-market-line bg-market-cream px-3 py-2 text-sm outline-none" name="stock">
                    <option value="">Tous les stocks</option>
                    <option value="alert" ${stock eq 'alert' ? 'selected' : ''}>Stock critique</option>
                    <option value="ok" ${stock eq 'ok' ? 'selected' : ''}>Stock normal</option>
                </select>
                <input class="rounded-xl border border-market-line bg-market-cream px-3 py-2 text-sm outline-none" type="number" step="0.01" name="minPrix" value="${minPrix}" placeholder="Prix min">
                <input class="rounded-xl border border-market-line bg-market-cream px-3 py-2 text-sm outline-none" type="number" step="0.01" name="maxPrix" value="${maxPrix}" placeholder="Prix max">
                <select class="rounded-xl border border-market-line bg-market-cream px-3 py-2 text-sm outline-none" name="sort">
                    <option value="designation_asc" ${sort eq 'designation_asc' ? 'selected' : ''}>Nom A-Z</option>
                    <option value="stock_asc" ${sort eq 'stock_asc' ? 'selected' : ''}>Stock croissant</option>
                    <option value="stock_desc" ${sort eq 'stock_desc' ? 'selected' : ''}>Stock décroissant</option>
                    <option value="prix_desc" ${sort eq 'prix_desc' ? 'selected' : ''}>Prix décroissant</option>
                    <option value="prix_asc" ${sort eq 'prix_asc' ? 'selected' : ''}>Prix croissant</option>
                </select>
                <div class="flex flex-wrap gap-2 sm:col-span-2 lg:col-span-5">
                    <button class="rounded-xl bg-market-pine px-4 py-2 text-sm font-bold text-white" type="submit">Appliquer</button>
                    <a class="rounded-xl border border-market-line bg-white px-4 py-2 text-sm font-semibold text-slate-600" href="${pageContext.request.contextPath}/produits">Réinitialiser</a>
                    <a class="rounded-xl border border-market-line bg-white px-4 py-2 text-sm font-semibold text-slate-600" href="${pageContext.request.contextPath}/produits?export=csv&search=${search}&categorie=${categorie}&stock=${stock}&minPrix=${minPrix}&maxPrix=${maxPrix}&minStock=${minStock}&maxStock=${maxStock}&datePeremptionMin=${datePeremptionMin}&datePeremptionMax=${datePeremptionMax}&sort=${sort}">Exporter CSV</a>
                </div>
            </form>
        </div>

        <!-- Tableau produits (pleine largeur, compact) -->
        <section class="page-card overflow-hidden p-0">
            <div class="overflow-x-auto">
                <table class="w-full text-left compact-table">
                    <thead class="border-b border-market-line bg-market-cream/40 text-sm font-bold text-market-pine sm:text-base">
                        <tr>
                            <th>Image</th>
                            <th>Désignation</th>
                            <th>Catégorie</th>
                            <th>Prix (FCFA)</th>
                            <th>Stock</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${produits}" var="p">
                            <tr class="border-b border-market-line last:border-b-0 hover:bg-market-cream/30">
                                <td class="align-middle">
                                    <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-to-br from-market-mint to-market-pine/20 text-market-pine">
                                        <!-- Icône selon catégorie -->
                                        <c:choose>
                                            <c:when test="${fn:containsIgnoreCase(p.categorie, 'Alimentation')}">
                                                <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/></svg>
                                            </c:when>
                                            <c:when test="${fn:containsIgnoreCase(p.categorie, 'Hygiene')}">
                                                <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
                                            </c:when>
                                            <c:when test="${fn:containsIgnoreCase(p.categorie, 'Electronique')}">
                                                <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/></svg>
                                            </c:when>
                                            <c:otherwise>
                                                <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/></svg>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </td>
                                <td class="font-semibold text-market-ink">
                                    ${p.designation}
                                    <span class="block text-base sm:text-xl text-base  sm:text-xl text-slate-400">SKU: ${p.codeBarre}</span>
                                </td>
                                <td><span class="rounded-full bg-market-cream px-2 py-1 text-base sm:text-xl font-semibold text-market-pine">${p.categorie}</span></td>
                                <td class="font-bold"><fmt:formatNumber value="${p.prixVente}" type="number" maxFractionDigits="0"/> FCFA</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${p.stockActuel <= 0}">
                                            <span class="rounded-t-md rounded-b-xs bg-red-100 px-2 py-1 text-base sm:text-xl font-semibold text-red-500">Rupture</span>
                                        </c:when>
                                        <c:when test="${p.enRupture}">
                                            <span class="rounded-t-md bg-orange-100 px-2 py-1 text-base sm:text-xl font-semibold text-orange-500">${p.stockActuel} (bas)</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="rounded-t-md bg-market-mint px-2 py-1 text-base sm:text-xl font-semibold text-market-pine">${p.stockActuel} unités</span>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="h-2 w-16 rounded-full bg-market-cream">
                                        <div class="h-1.5 rounded-full ${p.stockActuel <= 0 ? 'bg-red-400' : p.enRupture ? 'bg-orange-400' : 'bg-market-moss'}" style="width: ${p.stockActuel <= 0 ? 12 : p.enRupture ? 35 : 88}%"></div>
                                    </div>
                                </td>
                                <td>
                                    <div class="flex items-center gap-3 text-market-pine">
                                        <a href="${pageContext.request.contextPath}/produits/modifier?id=${p.id}" title="Modifier">
                                            <svg class="h-5 w-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M4 20h4l10-10-4-4L4 16v4Z"/><path d="m12 6 4 4"/></svg>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/produits/modifier?id=${p.id}" title="Voir">
                                            <svg class="h-5 w-5 text-slate-500" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M2 12s3.5-6 10-6 10 6 10 6-3.5 6-10 6S2 12 2 12Z"/><circle cx="12" cy="12" r="3"/></svg>
                                        </a>
                                        <form method="post" action="${pageContext.request.contextPath}/produits/supprimer" onsubmit="return confirm('Supprimer ce produit ?');">
                                            <input type="hidden" name="id" value="${p.id}">
                                            <button class="text-red-500" title="Supprimer">
                                                <svg class="h-5 w-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M3 6h18"/><path d="M8 6V4h8v2"/><path d="M19 6l-1 14H6L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/></svg>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <!-- Pagination compacte -->
            <div class="flex flex-wrap items-center justify-between gap-3 border-t border-market-line px-4 py-3 text-sm">
                <p class="text-slate-500">Affichage de ${((page - 1) * size) + 1} à ${((page - 1) * size) + fn:length(produits)} sur ${totalFiltered} produits</p>
                <div class="flex gap-2">
                    <a class="rounded-xl border border-market-line px-3 py-1.5 ${page <= 1 ? 'pointer-events-none opacity-40' : ''}" href="${pageContext.request.contextPath}/produits?search=${search}&categorie=${categorie}&stock=${stock}&minPrix=${minPrix}&maxPrix=${maxPrix}&minStock=${minStock}&maxStock=${maxStock}&datePeremptionMin=${datePeremptionMin}&datePeremptionMax=${datePeremptionMax}&sort=${sort}&size=${size}&page=${page - 1}">&lsaquo;</a>
                    <span class="rounded-xl bg-market-pine px-3 py-1.5 text-white">${page}</span>
                    <span class="rounded-xl border border-market-line px-3 py-1.5">${totalPages}</span>
                    <a class="rounded-xl border border-market-line px-3 py-1.5 ${page >= totalPages ? 'pointer-events-none opacity-40' : ''}" href="${pageContext.request.contextPath}/produits?search=${search}&categorie=${categorie}&stock=${stock}&minPrix=${minPrix}&maxPrix=${maxPrix}&minStock=${minStock}&maxStock=${maxStock}&datePeremptionMin=${datePeremptionMin}&datePeremptionMax=${datePeremptionMax}&sort=${sort}&size=${size}&page=${page + 1}">&rsaquo;</a>
                </div>
            </div>
        </section>
    </main>
</div>

<!-- MODAL AJOUT PRODUIT -->
<div id="productModal" class="modal-overlay">
    <div class="modal-container">
        <div class="mb-4 flex items-center justify-between">
            <h2 class="font-display text-2xl font-bold text-market-pine">Nouveau produit</h2>
            <button id="closeModalBtn" class="rounded-full p-1 hover:bg-market-cream">
                <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
            </button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/produits/ajouter" class="grid gap-4 sm:grid-cols-2">
            <input class="rounded-xl border border-market-line bg-market-cream px-4 py-2 text-sm outline-none" type="text" name="codeBarre" placeholder="Code barre *" required>
            <input class="rounded-xl border border-market-line bg-market-cream px-4 py-2 text-sm outline-none" type="text" name="designation" placeholder="Désignation *" required>
            <input class="rounded-xl border border-market-line bg-market-cream px-4 py-2 text-sm outline-none" type="text" name="categorie" placeholder="Catégorie *" required>
            <input class="rounded-xl border border-market-line bg-market-cream px-4 py-2 text-sm outline-none" type="number" step="0.01" name="prixAchat" placeholder="Prix achat *" required>
            <input class="rounded-xl border border-market-line bg-market-cream px-4 py-2 text-sm outline-none" type="number" step="0.01" name="prixVente" placeholder="Prix vente *" required>
            <input class="rounded-xl border border-market-line bg-market-cream px-4 py-2 text-sm outline-none" type="number" name="stockActuel" placeholder="Stock actuel *" required>
            <input class="rounded-xl border border-market-line bg-market-cream px-4 py-2 text-sm outline-none" type="number" name="stockMinimum" placeholder="Stock minimum *" required>
            <input class="rounded-xl border border-market-line bg-market-cream px-4 py-2 text-sm outline-none" type="date" name="datePeremption">
            <select class="rounded-xl border border-market-line bg-market-cream px-4 py-2 text-sm outline-none" name="fournisseurId">
                <option value="">Fournisseur (optionnel)</option>
                <c:forEach items="${fournisseurs}" var="f">
                    <option value="${f.id}">${f.raisonSociale}</option>
                </c:forEach>
            </select>
            <div class="sm:col-span-2 flex justify-end gap-3">
                <button type="button" id="modalCancelBtn" class="rounded-xl border border-market-line px-4 py-2 text-sm font-semibold">Annuler</button>
                <button class="rounded-xl bg-market-gold px-4 py-2 text-sm font-bold text-white" type="submit">Ajouter</button>
            </div>
        </form>
    </div>
</div>

<script>
    // Gestion du modal
    const modal = document.getElementById('productModal');
    const openBtn = document.getElementById('openModalBtn');
    const closeBtns = ['closeModalBtn', 'modalCancelBtn'];
    const openModal = () => modal.classList.add('active');
    const closeModal = () => modal.classList.remove('active');
    openBtn.addEventListener('click', openModal);
    closeBtns.forEach(id => {
        const btn = document.getElementById(id);
        if (btn) btn.addEventListener('click', closeModal);
    });
    modal.addEventListener('click', (e) => { if (e.target === modal) closeModal(); });

    // Toggle filtres
    const filtersPanel = document.getElementById('filtersPanel');
    const toggleBtn = document.getElementById('toggleFiltersBtn');
    toggleBtn.addEventListener('click', () => {
        filtersPanel.classList.toggle('hidden-panel');
    });

    // Synchronisation menu déroulant catégorie avec champ caché du formulaire de filtres
    const categorieSelect = document.getElementById('categorieSelect');
    const hiddenCategorie = document.getElementById('hiddenCategorie');
    if (categorieSelect && hiddenCategorie) {
        categorieSelect.addEventListener('change', function() {
            hiddenCategorie.value = this.value;
            // Soumettre automatiquement le formulaire principal (filtres)
            const filterForm = document.querySelector('#filtersPanel form');
            if (filterForm) filterForm.submit();
        });
    }

    // Gestion du sidebar toggle (inchangé)
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