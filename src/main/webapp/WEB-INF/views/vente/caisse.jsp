<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <%@ include file="/WEB-INF/views/partials/head.jspf" %>
    <title>Caisse | Supermarché</title>
    <style>
        /* Ajustements supplémentaires pour la page caisse */
        .product-card {
            transition: transform 0.15s ease, box-shadow 0.15s ease;
        }
        .product-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px -8px rgba(0, 0, 0, 0.12);
        }
        .category-tab {
            transition: all 0.2s ease;
        }
        .search-bar {
            transition: all 0.2s ease;
        }
        .search-bar:focus-within {
            border-color: #1f3fb7;
            box-shadow: 0 0 0 3px rgba(31, 63, 183, 0.1);
        }
        @media (max-width: 640px) {
            .product-card {
                padding: 1rem;
            }
            .product-card .product-icon {
                width: 4rem;
                height: 4rem;
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body class="app-shell overflow-x-hidden">
<c:set var="activePage" value="cashier"/>
<c:set var="pageTitle" value="Caisse enregistreuse"/>
<c:set var="pageSubtitle" value="Scannez, recherchez et ajoutez rapidement les produits au panier."/>
<c:set var="topbarSearchPlaceholder" value="Rechercher un produit..."/>
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp"/>
<jsp:include page="/WEB-INF/views/partials/panier-sidebar.jsp"/>

<div class="lg:pl-[19rem]">
    <jsp:include page="/WEB-INF/views/partials/topbar.jsp"/>
    <main class="px-4 py-5 sm:px-6 lg:px-8">
        <c:if test="${not empty flashMessage}">
            <div class="mb-5 rounded-xl border px-4 py-3 shadow-sm ${flashType eq 'success' ? 'border-emerald-200 bg-emerald-50 text-emerald-700' : 'border-red-200 bg-red-50 text-red-700'}">
                <p class="text-base font-semibold">${flashMessage}</p>
            </div>
        </c:if>

        <!-- Bloc recherche + catégories -->
        <div class="page-card p-3 mb-6 space-y-2">
            
            <div class="flex w-full max-w-full items-center gap-3 rounded-full border border-market-line bg-market-cream px-5 py-1 text-slate-500 ">
                <svg class="h-5 w-5 flex-shrink-0 text-market-pine" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="7"/><path d="m20 20-3.5-3.5"/></svg>
                <input id="productSearch" class="w-full bg-transparent text-base outline-none placeholder:text-slate-400" type="text" name="search" value="${topbarSearchValue}" placeholder="${not empty topbarSearchPlaceholder ? topbarSearchPlaceholder : 'Rechercher...'}">
            </div>
            <div id="categoryTabs" class="blue-scroll flex gap-2 overflow-x-auto pb-1">
                <!-- Les catégories seront injectées ici par JavaScript -->
            </div>
        </div>

        <!-- Grille produits : responsive 1/2/3/4 colonnes -->
        <div id="productGrid" class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
            <c:forEach items="${produits}" var="p">
                <article class="product-card bg-white rounded-xl border border-market-line p-4 shadow-sm hover:shadow-md transition-all"
                         data-id="${p.id}"
                         data-name="${fn:toLowerCase(p.designation)}"
                         data-code="${fn:toLowerCase(p.codeBarre)}"
                         data-category="${fn:toLowerCase(p.categorie)}"
                         data-price="${p.prixVente}"
                         data-stock="${p.stockActuel}">
                    <div class="product-icon flex h-16 w-16 items-center justify-center rounded-xl bg-gradient-to-br from-market-mint to-market-pine/20 text-2xl font-bold text-market-pine sm:h-20 sm:w-20 sm:text-3xl">
                           <!-- Icône selon catégorie -->
                                        <c:choose>
                                            <c:when test="${fn:containsIgnoreCase(p.categorie, 'Alimentation')}">
                                                <svg class="size-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/></svg>
                                            </c:when>
                                            <c:when test="${fn:containsIgnoreCase(p.categorie, 'Hygiene')}">
                                                <svg class="size-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
                                            </c:when>
                                            <c:when test="${fn:containsIgnoreCase(p.categorie, 'Electronique')}">
                                                <svg class="size-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/></svg>
                                            </c:when>
                                            <c:otherwise>
                                                <svg class="size-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/></svg>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                    <h3 class="mt-3 text-lg font-bold text-market-pine sm:text-xl">${p.designation}</h3>
                    <p class="mt-1 text-xl font-extrabold text-market-gold sm:text-2xl">
                        <fmt:formatNumber value="${p.prixVente}" type="number" maxFractionDigits="0"/> FCFA
                    </p>
                    <p class="mt-2 text-sm font-semibold uppercase text-slate-500">${p.categorie}</p>
                    <p class="text-sm text-slate-500">Stock: ${p.stockActuel}</p>
                    <button class="add-product flex items-center justify-center gap-2 mt-4 w-full rounded-lg bg-market-pine py-2.5 text-sm font-bold text-white transition-colors hover:bg-market-pine/90 sm:text-base">
                         <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M6 6h15l-1.5 9h-12L5 6H3"/>
                        <circle cx="8" cy="19" r="1.5"/>
                        <circle cx="17" cy="19" r="1.5"/>
                    </svg>
                        <span>Ajouter au panier</span>
                    </button>
                </article>
            </c:forEach>
        </div>
    </main>
</div>


<!-- Script spécifique pour la page Caisse (filtres, ajout au panier) -->
<script>
    (function() {
        let productSearch, productGrid, categoryTabsDiv;
        let productCards = [];
        let currentCategory = '';

        function addToCart(card) {
            const product = {
                id: card.dataset.id,
                name: card.querySelector('h3').innerText,
                price: Number(card.dataset.price),
                stock: Number(card.dataset.stock),
                quantity: 1
            };
            const success = CartManager.addItem(product);
            if (!success) {
                alert('Stock insuffisant pour ' + product.name);
            } else {
                const cartSidebar = document.getElementById('cartSidebar');
                if (cartSidebar) cartSidebar.classList.remove('translate-x-full');
            }
        }

        function filterProducts() {
            if (!productSearch || !productCards.length) return;
            const term = productSearch.value.trim().toLowerCase();
            productCards.forEach(card => {
                const matchSearch = !term ||
                    card.dataset.name.includes(term) ||
                    card.dataset.code.includes(term) ||
                    card.dataset.category.includes(term);
                const matchCat = !currentCategory || card.dataset.category === currentCategory;
                card.style.display = (matchSearch && matchCat) ? '' : 'none';
            });
        }

        function buildCategoryTabs() {
            if (!categoryTabsDiv) return;
            const cats = [...new Set(productCards.map(c => c.dataset.category).filter(Boolean))];
            categoryTabsDiv.innerHTML = '';
            const allBtn = document.createElement('button');
            allBtn.textContent = 'Tout';
            allBtn.dataset.category = '';
            allBtn.className = 'category-tab whitespace-nowrap rounded-full bg-market-pine px-5 py-3 text-white shadow-float';
            categoryTabsDiv.appendChild(allBtn);
            cats.forEach(cat => {
                const btn = document.createElement('button');
                btn.textContent = cat.charAt(0).toUpperCase() + cat.slice(1);
                btn.dataset.category = cat;
                btn.className = 'category-tab whitespace-nowrap rounded-full bg-market-mint px-5 py-3 text-market-pine';
                categoryTabsDiv.appendChild(btn);
            });
            categoryTabsDiv.addEventListener('click', (e) => {
                const target = e.target.closest('.category-tab');
                if (!target) return;
                currentCategory = target.dataset.category || '';
                document.querySelectorAll('.category-tab').forEach(btn => {
                    if (btn.dataset.category === currentCategory) {
                        btn.className = 'category-tab whitespace-nowrap rounded-full bg-market-pine px-5 py-3 text-white shadow-float';
                    } else {
                        btn.className = 'category-tab whitespace-nowrap rounded-full bg-market-mint px-5 py-3 text-market-pine';
                    }
                });
                filterProducts();
            });
        }

        function init() {
            productSearch = document.getElementById('productSearch');
            productGrid = document.getElementById('productGrid');
            categoryTabsDiv = document.getElementById('categoryTabs');
            if (productGrid) {
                productCards = Array.from(document.querySelectorAll('.product-card'));
                buildCategoryTabs();
                filterProducts();
                if (productSearch) productSearch.addEventListener('input', filterProducts);
                productGrid.addEventListener('click', (e) => {
                    const btn = e.target.closest('.add-product');
                    if (btn) addToCart(btn.closest('.product-card'));
                });
            }
        }

        if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
        else init();
    })();
</script>

</body>
</html>



