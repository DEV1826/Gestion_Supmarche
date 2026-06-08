<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <%@ include file="/WEB-INF/views/partials/head.jspf" %>
    <title>Fournisseurs</title>
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
            border-radius: 2rem;
            width: 90%;
            max-width: 800px;
            max-height: 85vh;
            overflow-y: auto;
            padding: 1.5rem;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
        }
    </style>
</head>
<body class="app-shell">
<c:set var="activePage" value="suppliers"/>
<c:set var="pageTitle" value="Gestion des Fournisseurs"/>
<c:set var="pageSubtitle" value="Gérez vos relations partenaires et suivez vos approvisionnements."/>
<c:set var="topbarSearchPlaceholder" value="Rechercher un fournisseur..."/>
<c:set var="topbarSearchValue" value="${search}"/>
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp"/>
<jsp:include page="/WEB-INF/views/partials/panier-sidebar.jsp"/>
<div class="lg:pl-[19rem]">
    <jsp:include page="/WEB-INF/views/partials/topbar.jsp"/>
    <main class="space-y-6 px-4 py-5 sm:px-6 lg:px-8">
        <c:if test="${not empty flashMessage}">
            <div class="rounded-[1.2rem] border px-4 py-3 shadow-panel ${flashType eq 'success' ? 'border-emerald-200 bg-emerald-50 text-emerald-700' : 'border-red-200 bg-red-50 text-red-700'}">
                <p class="text-base font-semibold">${flashMessage}</p>
            </div>
        </c:if>

        <!-- Cartes statistiques (style identique à produits) -->
        <section class="grid gap-4 md:grid-cols-4">
            <article class="page-card relative overflow-hidden p-5 md:p-6">
                <div class="absolute right-0 top-0 h-full w-32 bg-[linear-gradient(90deg,transparent,rgba(31,63,183,0.05))]"></div>
                <p class="text-lg font-display font-semibold uppercase text-slate-500 sm:text-xl">Total Fournisseurs</p>
                <p class="mt-2 font-display text-3xl font-extrabold text-market-pine sm:text-4xl">${totalFournisseurs}</p>
                <p class="mt-4 text-base text-market-moss sm:text-lg">+2 ce trimestre</p>
            </article>
            <article class="page-card border-l-4 border-l-market-gold p-5 md:p-6">
                <p class="text-lg font-display font-semibold uppercase text-market-gold sm:text-xl">Commandes actives</p>
                <p class="mt-2 font-display text-3xl font-extrabold text-market-gold sm:text-4xl">${produitsEnAlerte.size()}</p>
                <p class="mt-4 text-base text-slate-500 sm:text-lg">En attente de livraison</p>
            </article>
            <article class="page-card border-l-4 border-l-market-moss p-5 md:p-6">
                <p class="text-lg font-display font-semibold uppercase text-market-moss sm:text-xl">Livraisons aujourd'hui</p>
                <p class="mt-2 font-display text-3xl font-extrabold text-market-moss sm:text-4xl">${fournisseurs.size()}</p>
                <p class="mt-4 text-base text-slate-500 sm:text-lg">Dont 3 urgentes</p>
            </article>
            <article class="page-card border-l-4 border-l-red-400 p-5 md:p-6">
                <p class="text-lg font-display font-semibold uppercase text-red-500 sm:text-xl">Alertes rupture</p>
                <p class="mt-2 font-display text-3xl font-extrabold text-red-500 sm:text-4xl">${produitsEnAlerte.size()}</p>
                <p class="mt-4 text-base text-slate-500 sm:text-lg">Stocks critiques</p>
            </article>
        </section>

        <!-- Barre d'actions : bouton Nouveau + Filtres toggle -->
        <div class="flex flex-wrap items-center justify-between gap-3">
            <button id="openModalBtn" class="inline-flex items-center gap-2 rounded-full bg-market-pine px-5 py-2.5 text-base font-bold text-white shadow-sm hover:bg-opacity-90">
                <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
                Nouveau fournisseur
            </button>
            <button id="toggleFiltersBtn" class="inline-flex items-center gap-2 rounded-full bg-market-mint px-5 py-2.5 text-base font-bold text-market-pine shadow-sm">
                <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.293A1 1 0 013 6.586V4z"/></svg>
                Filtres
            </button>
        </div>

        <!-- Panneau filtres (caché par défaut) -->
        <div id="filtersPanel" class="hidden-panel page-card p-4" style="display: none;">
            <form method="get" action="${pageContext.request.contextPath}/fournisseurs" class="grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
                <input class="rounded-xl border border-market-line bg-market-cream px-4 py-2 text-base outline-none" type="text" name="search" value="${search}" placeholder="Raison sociale, tel, email">
                <select class="rounded-xl border border-market-line bg-market-cream px-4 py-2 text-base outline-none" name="delai">
                    <option value="">Tous les délais</option>
                    <option value="fast" ${delai eq 'fast' ? 'selected' : ''}>Livraison rapide</option>
                    <option value="slow" ${delai eq 'slow' ? 'selected' : ''}>Délai long</option>
                </select>
                <select class="rounded-xl border border-market-line bg-market-cream px-4 py-2 text-base outline-none" name="sort">
                    <option value="raison_asc" ${sort eq 'raison_asc' ? 'selected' : ''}>Nom A-Z</option>
                    <option value="delai_asc" ${sort eq 'delai_asc' ? 'selected' : ''}>Délai croissant</option>
                    <option value="delai_desc" ${sort eq 'delai_desc' ? 'selected' : ''}>Délai décroissant</option>
                </select>
                <div class="flex flex-wrap gap-2">
                    <button class="rounded-xl bg-market-pine px-5 py-2 text-base font-bold text-white" type="submit">Appliquer</button>
                    <a class="rounded-xl border border-market-line bg-white px-5 py-2 text-base font-semibold text-slate-600" href="${pageContext.request.contextPath}/fournisseurs">Réinitialiser</a>
                </div>
            </form>
        </div>

        <!-- Tableau des fournisseurs (pleine largeur, compact, icônes d'entreprise) -->
        <section class="page-card overflow-hidden p-0">
            <div class="overflow-x-auto">
                <table class="w-full text-left">
                    <thead class="border-b border-market-line bg-market-cream/30 text-base font-bold text-market-pine sm:text-lg">
                        <tr>
                            <th class="px-6 py-4">Fournisseur</th>
                            <th class="px-6 py-4">Contact</th>
                            <th class="px-6 py-4">Catégorie / Paiement</th>
                            <th class="px-6 py-4">Délai (jours)</th>
                            <th class="px-6 py-4">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${fournisseurs}" var="f">
                            <tr class="border-b border-market-line last:border-b-0 hover:bg-market-cream/30">
                                <td class="px-6 py-4">
                                    <div class="flex items-center gap-4">
                                        <!-- Icône entreprise générique (bâtiment) -->
                                        <div class="flex h-12 w-12 items-center justify-center rounded-full bg-market-mint text-market-pine">
                                            <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 4h1m-1 4h1m4-4h1m-1 4h1"/>
                                            </svg>
                                        </div>
                                        <div>
                                            <p class="text-lg font-semibold text-market-ink">${f.raisonSociale}</p>
                                            <p class="text-sm text-slate-500">ID: FR-${f.id}</p>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-6 py-4 text-base">
                                    <p>${f.telephone}</p>
                                    <p class="text-sm text-slate-500">${f.email}</p>
                                </td>
                                <td class="px-6 py-4">
                                    <span class="rounded-full bg-market-cream px-3 py-1.5 text-sm font-semibold text-market-pine">${f.conditionsPaiement}</span>
                                </td>
                                <td class="px-6 py-4 text-lg font-bold text-market-gold">${f.delaiLivraisonJours} j</td>
                                <td class="px-6 py-4">
                                    <div class="flex items-center gap-3 text-market-pine">
                                        <a href="${pageContext.request.contextPath}/fournisseurs/commande?fournisseurId=${f.id}" title="Générer bon de commande (PDF)">
                                            <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"/>
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 13h4m-4 4h4"/>
                                            </svg>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/fournisseurs/commande?fournisseurId=${f.id}&channel=email" title="Envoyer par email + PDF">
                                            <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                                            </svg>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/fournisseurs/modifier?id=${f.id}" title="Modifier">
                                            <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"/>
                                            </svg>
                                        </a>
                                        <form method="post" action="${pageContext.request.contextPath}/fournisseurs/supprimer" onsubmit="return confirm('Supprimer ce fournisseur ?');">
                                            <input type="hidden" name="id" value="${f.id}">
                                            <button class="text-red-500" title="Supprimer">
                                                <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                                </svg>
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
            <div class="flex flex-wrap items-center justify-between gap-3 border-t border-market-line px-6 py-4 text-sm">
                <p class="text-slate-500 text-base">Affichage de ${((page - 1) * size) + 1} à ${((page - 1) * size) + fn:length(fournisseurs)} sur ${totalFiltered} fournisseurs</p>
                <div class="flex gap-2">
                    <a class="rounded-xl border border-market-line px-3 py-1.5 text-base ${page <= 1 ? 'pointer-events-none opacity-40' : ''}" href="${pageContext.request.contextPath}/fournisseurs?search=${search}&delai=${delai}&sort=${sort}&size=${size}&page=${page - 1}">&lsaquo;</a>
                    <span class="rounded-xl bg-market-pine px-3 py-1.5 text-base text-white">${page}</span>
                    <span class="rounded-xl border border-market-line px-3 py-1.5 text-base">${totalPages}</span>
                    <a class="rounded-xl border border-market-line px-3 py-1.5 text-base ${page >= totalPages ? 'pointer-events-none opacity-40' : ''}" href="${pageContext.request.contextPath}/fournisseurs?search=${search}&delai=${delai}&sort=${sort}&size=${size}&page=${page + 1}">&rsaquo;</a>
                </div>
            </div>
        </section>

        <!-- Carte d'optimisation (identique à produits) -->
        <section class="grid gap-5 md:grid-cols-[1.3fr_0.7fr]">
            <article class="overflow-hidden rounded-[2rem] bg-market-pine p-6 text-white shadow-panel">
                <h2 class="font-display text-2xl font-bold sm:text-3xl">Optimisation des Stocks</h2>
                <p class="mt-4 text-base leading-7 text-white/85 sm:text-lg">L'algorithme suggère de commander 20% de stock supplémentaire auprès des partenaires les plus fiables pour anticiper la demande.</p>
                <a href="${pageContext.request.contextPath}/stock/alertes" class="mt-5 inline-flex rounded-[1.2rem] bg-market-gold px-6 py-2.5 text-base font-bold text-white">Consulter l'analyse</a>
            </article>
            <article class="page-card p-6 text-center">
                <div class="mx-auto flex h-20 w-20 items-center justify-center rounded-full bg-market-mint text-market-pine">
                    <svg class="h-8 w-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M18.364 5.636L16.95 7.05M7.05 16.95L5.636 18.364M12 4v2m0 12v2M4 12H2m4.343-5.657L4.93 7.05m13.435 9.9l-1.414 1.414M12 8a4 4 0 110 8 4 4 0 010-8z"/>
                    </svg>
                </div>
                <h3 class="mt-4 font-display text-2xl font-bold text-market-pine">Support Partenaire</h3>
                <p class="mt-2 text-base text-slate-500">Une question sur vos intégrations fournisseurs ?</p>
                <p class="mt-4 text-lg font-bold text-market-pine">Accéder au centre d'aide</p>
            </article>
        </section>
    </main>
</div>

<!-- MODAL AJOUT FOURNISSEUR -->
<div id="supplierModal" class="modal-overlay">
    <div class="modal-container">
        <div class="mb-4 flex items-center justify-between">
            <h2 class="font-display text-2xl font-bold text-market-pine">Nouveau fournisseur</h2>
            <button id="closeModalBtn" class="rounded-full p-1 hover:bg-market-cream">
                <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
            </button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/fournisseurs/ajouter" class="grid gap-4 sm:grid-cols-2">
            <input class="rounded-xl border border-market-line bg-market-cream px-4 py-2.5 text-base outline-none" type="text" name="raisonSociale" placeholder="Raison sociale *" required>
            <input class="rounded-xl border border-market-line bg-market-cream px-4 py-2.5 text-base outline-none" type="text" name="telephone" placeholder="Téléphone">
            <input class="rounded-xl border border-market-line bg-market-cream px-4 py-2.5 text-base outline-none" type="email" name="email" placeholder="Email">
            <input class="rounded-xl border border-market-line bg-market-cream px-4 py-2.5 text-base outline-none" type="number" name="delaiLivraisonJours" placeholder="Délai livraison (jours)">
            <div class="sm:col-span-2">
                <input class="w-full rounded-xl border border-market-line bg-market-cream px-4 py-2.5 text-base outline-none" type="text" name="conditionsPaiement" placeholder="Catégorie / Conditions de paiement">
            </div>
            <div class="sm:col-span-2 flex justify-end gap-3">
                <button type="button" id="modalCancelBtn" class="rounded-xl border border-market-line px-5 py-2.5 text-base font-semibold">Annuler</button>
                <button class="rounded-xl bg-market-gold px-5 py-2.5 text-base font-bold text-white" type="submit">Ajouter</button>
            </div>
        </form>
    </div>
</div>

<script>
    // Gestion du modal
    const modal = document.getElementById('supplierModal');
    const openBtn = document.getElementById('openModalBtn');
    const closeModal = () => modal.classList.remove('active');
    const openModal = () => modal.classList.add('active');
    openBtn.addEventListener('click', openModal);
    document.getElementById('closeModalBtn')?.addEventListener('click', closeModal);
    document.getElementById('modalCancelBtn')?.addEventListener('click', closeModal);
    modal.addEventListener('click', (e) => { if (e.target === modal) closeModal(); });

    // Toggle filtres
    const filtersPanel = document.getElementById('filtersPanel');
    const toggleBtn = document.getElementById('toggleFiltersBtn');
    toggleBtn.addEventListener('click', () => {
        if (filtersPanel.style.display === 'none') {
            filtersPanel.style.display = 'block';
        } else {
            filtersPanel.style.display = 'none';
        }
    });

    // Sidebar toggle
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