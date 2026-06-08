<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <%@ include file="/WEB-INF/views/partials/head.jspf" %>
    <title>Caisse</title>
</head>
<body class="app-shell overflow-x-hidden">
<c:set var="activePage" value="cashier"/>
<c:set var="pageTitle" value="Gestion Supermarche"/>
<c:set var="topbarSearchPlaceholder" value="Scannez ou recherchez un produit"/>
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp"/>
<jsp:include page="/WEB-INF/views/partials/panier-sidebar.jsp"/>

<div class="lg:pl-[19rem]">
    <jsp:include page="/WEB-INF/views/partials/topbar.jsp"/>
    <main class="px-4 py-6 sm:px-6 lg:px-10">
        <c:if test="${not empty flashMessage}">
            <div class="mb-6 rounded-[1.6rem] border px-5 py-4 shadow-panel ${flashType eq 'success' ? 'border-emerald-200 bg-emerald-50 text-emerald-700' : 'border-red-200 bg-red-50 text-red-700'}">
                <p class="text-sm font-semibold">${flashMessage}</p>
            </div>
        </c:if>

        <!-- Barre de recherche et catégories -->
        <div class="page-card flex flex-col gap-4 p-5 mb-8">
            <div class="flex flex-wrap items-center gap-3 rounded-[1.6rem] border-4 border-market-moss bg-white px-4 py-4 shadow-float sm:flex-nowrap">
                <svg class="h-8 w-8 text-market-pine" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="7"/><path d="m20 20-3.5-3.5"/></svg>
                <input id="productSearch" class="w-full bg-transparent text-lg outline-none placeholder:text-slate-400 sm:text-2xl" type="text" placeholder="Rechercher un produit (code barre, nom, catégorie)">
            </div>
            <div id="categoryTabs" class="blue-scroll flex gap-3 overflow-x-auto pb-2 text-lg font-semibold sm:text-xl">
                <button class="category-tab whitespace-nowrap rounded-full bg-market-pine px-5 py-3 text-white" data-category="">Tout</button>
            </div>
        </div>

        <!-- Grille produits : 4 colonnes -->
        <div id="productGrid" class="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
            <c:forEach items="${produits}" var="p">
                <article class="product-card group relative rounded-2xl border border-market-line bg-white p-4 shadow-panel transition-all hover:scale-[1.02]" 
                         data-id="${p.id}" 
                         data-name="${fn:toLowerCase(p.designation)}" 
                         data-code="${fn:toLowerCase(p.codeBarre)}" 
                         data-category="${fn:toLowerCase(p.categorie)}" 
                         data-price="${p.prixVente}" 
                         data-stock="${p.stockActuel}">
                    <div class="flex h-28 w-28 items-center justify-center rounded-2xl bg-gradient-to-br from-market-mint to-market-pine/20 text-4xl font-bold text-market-pine">
                        ${fn:substring(p.designation, 0, 1)}
                    </div>
                    <h3 class="mt-4 text-xl font-semibold text-market-pine">${p.designation}</h3>
                    <p class="mt-1 text-2xl font-bold text-market-gold"><fmt:formatNumber value="${p.prixVente}" type="number" maxFractionDigits="0"/> FCFA</p>
                    <p class="mt-2 text-sm uppercase text-slate-500">${p.categorie}</p>
                    <p class="text-sm text-slate-500">Stock: ${p.stockActuel}</p>
                    <button class="add-product mt-5 w-full rounded-xl bg-market-pine py-3 font-bold text-white transition-colors hover:bg-market-pine/90">Ajouter au panier</button>
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