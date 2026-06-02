<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <%@ include file="/views/partials/head.jspf" %>
    <title>Produits</title>
</head>
<body class="app-shell">
<c:set var="activePage" value="products"/>
<c:set var="pageTitle" value="Gestion du Stock"/>
<c:set var="pageSubtitle" value="Inventaire, categories, valeur de stock et actions rapides."/>
<c:set var="topbarSearchPlaceholder" value="Rechercher par nom ou SKU..."/>
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

        <section class="grid gap-5 xl:grid-cols-[1.4fr_0.65fr_0.65fr]">
            <article class="page-card relative overflow-hidden p-8">
                <div class="absolute right-0 top-0 h-full w-48 bg-[linear-gradient(90deg,transparent,rgba(31,63,183,0.05))]"></div>
                <p class="text-2xl font-display font-semibold uppercase text-slate-500 sm:text-4xl">Catalogue total</p>
                <p class="mt-5 font-display text-4xl font-extrabold text-market-pine sm:text-5xl">${totalProduits} articles</p>
                <p class="mt-7 text-lg font-semibold text-market-moss sm:text-2xl">+12 nouveaux ce mois</p>
            </article>
            <article class="page-card border border-red-200 p-8">
                <p class="text-2xl font-display font-semibold uppercase text-red-500 sm:text-4xl">Ruptures</p>
                <p class="mt-5 font-display text-4xl font-extrabold text-red-500 sm:text-5xl">${totalAlertes}</p>
                <p class="mt-7 text-lg leading-8 text-slate-500 sm:text-2xl sm:leading-9">Necessite reapprovisionnement</p>
            </article>
            <article class="page-card border border-orange-200 p-8">
                <p class="text-2xl font-display font-semibold uppercase text-market-gold sm:text-4xl">Valeur stock</p>
                <p class="mt-5 font-display text-4xl font-extrabold text-market-gold sm:text-5xl">FCFA</p>
                <p class="mt-7 text-lg leading-8 text-slate-500 sm:text-2xl sm:leading-9">Estimation totale</p>
            </article>
        </section>

        <section class="flex flex-col gap-4 xl:flex-row xl:items-center xl:justify-between">
            <div class="blue-scroll flex flex-nowrap gap-3 overflow-x-auto pb-2 text-base font-semibold sm:flex-wrap sm:overflow-visible sm:text-2xl">
                <a class="whitespace-nowrap rounded-full px-5 py-3 sm:px-8 sm:py-4 ${empty categorie ? 'bg-market-pine text-white shadow-float' : 'bg-market-mint text-market-pine'}" href="${pageContext.request.contextPath}/produits">Toutes les categories</a>
                <a class="whitespace-nowrap rounded-full px-5 py-3 sm:px-8 sm:py-4 ${categorie eq 'Alimentation' ? 'bg-market-pine text-white shadow-float' : 'bg-market-mint text-market-pine'}" href="${pageContext.request.contextPath}/produits?categorie=Alimentation">Produits Frais</a>
                <a class="whitespace-nowrap rounded-full px-5 py-3 sm:px-8 sm:py-4 ${categorie eq 'Hygiene' ? 'bg-market-pine text-white shadow-float' : 'bg-market-mint text-market-pine'}" href="${pageContext.request.contextPath}/produits?categorie=Hygiene">Epicerie</a>
                <a class="whitespace-nowrap rounded-full px-5 py-3 sm:px-8 sm:py-4 ${categorie eq 'Electronique' ? 'bg-market-pine text-white shadow-float' : 'bg-market-mint text-market-pine'}" href="${pageContext.request.contextPath}/produits?categorie=Electronique">Electronique</a>
            </div>
            <a href="#add-product-form" class="inline-flex items-center justify-center gap-3 rounded-[1.5rem] bg-market-gold px-6 py-4 text-xl font-bold text-white shadow-float sm:px-8 sm:py-5 sm:text-3xl">
                <span>+</span>
                <span>Nouveau Produit</span>
            </a>
        </section>

        <section class="page-card p-6">
            <form method="get" action="${pageContext.request.contextPath}/produits" class="grid gap-4 lg:grid-cols-[1.3fr_repeat(4,minmax(0,1fr))]">
                <input class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="text" name="search" value="${search}" placeholder="Recherche designation ou code">
                <select class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" name="stock">
                    <option value="">Tous les stocks</option>
                    <option value="alert" ${stock eq 'alert' ? 'selected' : ''}>Stock critique</option>
                    <option value="ok" ${stock eq 'ok' ? 'selected' : ''}>Stock normal</option>
                </select>
                <input class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="number" step="0.01" name="minPrix" value="${minPrix}" placeholder="Prix min">
                <input class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="number" step="0.01" name="maxPrix" value="${maxPrix}" placeholder="Prix max">
                <select class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" name="sort">
                    <option value="designation_asc" ${sort eq 'designation_asc' ? 'selected' : ''}>Nom A-Z</option>
                    <option value="stock_asc" ${sort eq 'stock_asc' ? 'selected' : ''}>Stock croissant</option>
                    <option value="stock_desc" ${sort eq 'stock_desc' ? 'selected' : ''}>Stock decroissant</option>
                    <option value="prix_desc" ${sort eq 'prix_desc' ? 'selected' : ''}>Prix decroissant</option>
                    <option value="prix_asc" ${sort eq 'prix_asc' ? 'selected' : ''}>Prix croissant</option>
                </select>
                <div class="flex flex-wrap gap-3 lg:col-span-5">
                    <button class="rounded-[1.3rem] bg-market-pine px-6 py-4 text-lg font-bold text-white" type="submit">Filtrer</button>
                    <a class="rounded-[1.3rem] border border-market-line bg-white px-6 py-4 text-lg font-semibold text-slate-600" href="${pageContext.request.contextPath}/produits">Reinitialiser</a>
                    <a class="rounded-[1.3rem] border border-market-line bg-white px-6 py-4 text-lg font-semibold text-slate-600" href="${pageContext.request.contextPath}/produits?export=csv&search=${search}&categorie=${categorie}&stock=${stock}&minPrix=${minPrix}&maxPrix=${maxPrix}&minStock=${minStock}&maxStock=${maxStock}&datePeremptionMin=${datePeremptionMin}&datePeremptionMax=${datePeremptionMax}&sort=${sort}">Exporter CSV</a>
                </div>
            </form>
        </section>

        <section class="page-card overflow-hidden">
            <div class="overflow-x-auto">
                <table class="min-w-[980px] text-left">
                    <thead class="border-b border-market-line bg-white text-lg font-bold text-market-pine sm:text-2xl">
                        <tr>
                            <th class="px-8 py-6">Image</th>
                            <th class="px-8 py-6">Designation</th>
                            <th class="px-8 py-6">Categorie</th>
                            <th class="px-8 py-6">Prix Unitaire (FCFA)</th>
                            <th class="px-8 py-6">Etat du Stock</th>
                            <th class="px-8 py-6">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${produits}" var="p">
                            <tr class="border-b border-market-line last:border-b-0">
                                <td class="px-8 py-6">
                                    <div class="flex h-20 w-20 items-center justify-center rounded-[1.25rem] bg-gradient-to-br from-market-mint to-market-pine/30 text-2xl font-bold text-market-pine">
                                        ${fn:substring(p.designation, 0, 1)}
                                    </div>
                                </td>
                                <td class="px-8 py-6">
                                    <p class="safe-wrap text-xl font-semibold text-market-ink sm:text-3xl">${p.designation}</p>
                                    <p class="mt-2 text-base text-slate-500 sm:text-xl">SKU: ${p.codeBarre}</p>
                                </td>
                                <td class="px-8 py-6">
                                    <span class="rounded-full bg-market-cream px-4 py-2 text-sm font-semibold text-market-pine sm:text-xl">${p.categorie}</span>
                                </td>
                                <td class="px-8 py-6 text-xl font-bold text-market-ink sm:text-3xl"><fmt:formatNumber value="${p.prixVente}" type="number" maxFractionDigits="0"/> FCFA</td>
                                <td class="px-8 py-6">
                                    <c:choose>
                                        <c:when test="${p.stockActuel <= 0}">
                                            <span class="rounded-full bg-red-100 px-4 py-2 text-sm font-semibold text-red-500 sm:text-xl">Rupture de stock</span>
                                        </c:when>
                                        <c:when test="${p.enRupture}">
                                            <span class="rounded-full bg-orange-100 px-4 py-2 text-sm font-semibold text-orange-500 sm:text-xl">${p.stockActuel} unites (Bas)</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="rounded-full bg-market-mint px-4 py-2 text-sm font-semibold text-market-pine sm:text-xl">${p.stockActuel} unites</span>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="mt-3 h-3 w-32 rounded-full bg-market-cream">
                                        <div class="h-3 rounded-full ${p.stockActuel <= 0 ? 'bg-red-400' : p.enRupture ? 'bg-orange-400' : 'bg-market-moss'}" style="width: ${p.stockActuel <= 0 ? 12 : p.enRupture ? 35 : 88}%"></div>
                                    </div>
                                </td>
                                <td class="px-8 py-6">
                                    <div class="flex items-center gap-5 text-market-pine">
                                        <a title="Modifier" href="${pageContext.request.contextPath}/produits/modifier?id=${p.id}">
                                            <svg class="h-7 w-7" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 20h4l10-10-4-4L4 16v4Z"/><path d="m12 6 4 4"/></svg>
                                        </a>
                                        <a title="Voir" href="${pageContext.request.contextPath}/produits/modifier?id=${p.id}">
                                            <svg class="h-7 w-7 text-slate-500" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M2 12s3.5-6 10-6 10 6 10 6-3.5 6-10 6S2 12 2 12Z"/><circle cx="12" cy="12" r="3"/></svg>
                                        </a>
                                        <form method="post" action="${pageContext.request.contextPath}/produits/supprimer" onsubmit="return confirm('Supprimer ce produit ?');">
                                            <input type="hidden" name="id" value="${p.id}">
                                            <button title="Supprimer" class="text-red-500" type="submit">
                                                <svg class="h-7 w-7" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18"/><path d="M8 6V4h8v2"/><path d="M19 6l-1 14H6L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/></svg>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <div class="flex flex-col gap-4 border-t border-market-line px-8 py-6 lg:flex-row lg:items-center lg:justify-between">
                <p class="text-2xl text-slate-500">Affichage de ${((page - 1) * size) + 1} a ${((page - 1) * size) + produits.size()} sur ${totalFiltered} produits</p>
                <div class="flex flex-wrap items-center gap-3 text-xl font-semibold">
                    <a class="rounded-[1.15rem] border border-market-line px-5 py-3 ${page <= 1 ? 'pointer-events-none opacity-40' : ''}" href="${pageContext.request.contextPath}/produits?search=${search}&categorie=${categorie}&stock=${stock}&minPrix=${minPrix}&maxPrix=${maxPrix}&minStock=${minStock}&maxStock=${maxStock}&datePeremptionMin=${datePeremptionMin}&datePeremptionMax=${datePeremptionMax}&sort=${sort}&size=${size}&page=${page - 1}">&lsaquo;</a>
                    <span class="rounded-[1.15rem] bg-market-pine px-5 py-3 text-white">${page}</span>
                    <span class="rounded-[1.15rem] border border-market-line px-5 py-3">${totalPages}</span>
                    <a class="rounded-[1.15rem] border border-market-line px-5 py-3 ${page >= totalPages ? 'pointer-events-none opacity-40' : ''}" href="${pageContext.request.contextPath}/produits?search=${search}&categorie=${categorie}&stock=${stock}&minPrix=${minPrix}&maxPrix=${maxPrix}&minStock=${minStock}&maxStock=${maxStock}&datePeremptionMin=${datePeremptionMin}&datePeremptionMax=${datePeremptionMax}&sort=${sort}&size=${size}&page=${page + 1}">&rsaquo;</a>
                </div>
            </div>
        </section>

        <section id="add-product-form" class="page-card p-8">
            <div class="mb-6">
                <h2 class="font-display text-4xl font-bold text-market-pine">Nouveau produit</h2>
                <p class="mt-2 text-xl text-slate-500">Ajout rapide au catalogue.</p>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/produits/ajouter" class="grid gap-4 md:grid-cols-2 xl:grid-cols-5">
                <input class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="text" name="codeBarre" placeholder="Code barre" required>
                <input class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="text" name="designation" placeholder="Designation" required>
                <input class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="text" name="categorie" placeholder="Categorie" required>
                <input class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="number" step="0.01" name="prixAchat" placeholder="Prix achat" required>
                <input class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="number" step="0.01" name="prixVente" placeholder="Prix vente" required>
                <input class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="number" name="stockActuel" placeholder="Stock actuel" required>
                <input class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="number" name="stockMinimum" placeholder="Stock minimum" required>
                <input class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="date" name="datePeremption">
                <select class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" name="fournisseurId">
                    <option value="">Fournisseur</option>
                    <c:forEach items="${fournisseurs}" var="f">
                        <option value="${f.id}">${f.raisonSociale}</option>
                    </c:forEach>
                </select>
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
