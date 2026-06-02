<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <%@ include file="/views/partials/head.jspf" %>
    <title>Caisse</title>
</head>
<body class="app-shell overflow-x-hidden">
<c:set var="activePage" value="cashier"/>
<c:set var="pageTitle" value="Gestion Supermarche"/>
<c:set var="topbarSearchPlaceholder" value="Scannez ou recherchez un produit"/>
<jsp:include page="/views/partials/sidebar.jsp"/>
<div class="lg:pl-[19rem]">
    <jsp:include page="/views/partials/topbar.jsp"/>
    <main class="px-4 py-6 sm:px-6 lg:px-10">
        <c:if test="${not empty flashMessage}">
            <div class="mb-6 rounded-[1.6rem] border px-5 py-4 shadow-panel ${flashType eq 'success' ? 'border-emerald-200 bg-emerald-50 text-emerald-700' : 'border-red-200 bg-red-50 text-red-700'}">
                <p class="text-sm font-semibold">${flashMessage}</p>
            </div>
        </c:if>

        <div class="grid gap-6 2xl:grid-cols-[1.2fr_0.8fr]">
            <section class="space-y-6">
                <div class="page-card flex flex-col gap-4 p-5">
                    <div class="flex flex-wrap items-center gap-3 rounded-[1.6rem] border-4 border-market-moss bg-white px-4 py-4 shadow-float sm:flex-nowrap sm:gap-4 sm:px-5">
                        <svg class="h-8 w-8 text-market-pine" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="7"/><path d="m20 20-3.5-3.5"/></svg>
                        <input id="productSearch" class="w-full min-w-0 bg-transparent text-lg text-market-ink outline-none placeholder:text-slate-400 sm:text-2xl" type="text" placeholder="Scannez ou recherchez un produit">
                        <span class="rounded-[1rem] border border-market-line bg-market-cream px-4 py-3 text-base font-bold text-market-pine sm:text-xl">F1</span>
                    </div>
                    <div id="categoryTabs" class="blue-scroll flex gap-3 overflow-x-auto pb-2 text-lg font-semibold sm:text-2xl">
                        <button class="category-tab whitespace-nowrap rounded-full bg-market-pine px-5 py-3 text-white sm:px-8 sm:py-4" data-category="">Tout</button>
                    </div>
                </div>

                <div id="productGrid" class="grid gap-4 sm:grid-cols-2 xl:grid-cols-3 2xl:grid-cols-4">
                    <c:forEach items="${produits}" var="p">
                        <article class="product-card page-card p-4 sm:p-5" data-id="${p.id}" data-name="${fn:toLowerCase(p.designation)}" data-code="${fn:toLowerCase(p.codeBarre)}" data-category="${fn:toLowerCase(p.categorie)}" data-price="${p.prixVente}" data-stock="${p.stockActuel}">
                            <div class="flex h-20 w-20 items-center justify-center rounded-[1.2rem] bg-gradient-to-br from-market-mint to-market-pine/30 text-2xl font-bold text-market-pine sm:h-24 sm:w-24 sm:rounded-[1.4rem] sm:text-3xl">${fn:substring(p.designation, 0, 1)}</div>
                            <p class="safe-wrap mt-5 text-2xl font-semibold text-market-pine sm:mt-6 sm:text-3xl">${p.designation}</p>
                            <p class="mt-3 text-3xl font-bold text-market-gold sm:text-4xl"><fmt:formatNumber value="${p.prixVente}" type="number" maxFractionDigits="0"/> FCFA</p>
                            <p class="mt-3 text-sm uppercase tracking-[0.14em] text-slate-500 sm:text-lg">${p.categorie}</p>
                            <p class="mt-2 text-sm text-slate-500 sm:text-lg">Stock: ${p.stockActuel}</p>
                            <button class="add-product mt-5 w-full rounded-[1.15rem] bg-market-pine px-4 py-3 text-base font-bold text-white sm:text-lg" type="button">Ajouter</button>
                        </article>
                    </c:forEach>
                </div>
            </section>

            <aside class="overflow-hidden rounded-[2rem] border border-market-line bg-white shadow-panel 2xl:sticky 2xl:top-28">
                <div class="flex flex-wrap items-center justify-between gap-4 bg-market-pine px-5 py-5 text-white sm:px-8 sm:py-6">
                    <h2 class="font-display text-3xl font-bold sm:text-4xl">Panier Actuel</h2>
                    <span id="cartCountBadge" class="rounded-full border border-white/25 bg-white/10 px-4 py-2 text-base font-bold sm:px-5 sm:text-xl">0 ARTICLE</span>
                </div>
                <form id="saleForm" method="post" action="${pageContext.request.contextPath}/ventes/nouvelle">
                    <div id="cartItems" class="blue-scroll max-h-[28rem] space-y-4 overflow-y-auto bg-white px-5 py-5 sm:max-h-[33rem] sm:space-y-5 sm:px-8 sm:py-8">
                        <div id="emptyCart" class="rounded-[1.5rem] bg-market-cream px-5 py-6 text-center text-base text-slate-500 sm:text-xl">Aucun produit dans le panier.</div>
                    </div>

                    <div class="border-t border-market-line px-5 py-5 sm:px-8 sm:py-6">
                        <label class="mb-3 block text-base font-semibold text-market-ink sm:text-lg">Mode de paiement</label>
                        <select name="modePaiement" class="w-full rounded-[1.25rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none sm:text-xl">
                            <option value="ESPECES">Especes</option>
                            <option value="CARTE">Carte</option>
                            <option value="MOBILE_MONEY">Mobile Money</option>
                        </select>
                        <div class="mt-8 space-y-4 text-lg text-market-ink sm:text-2xl">
                            <div class="flex items-center justify-between"><span>Sous-total</span><span id="subtotalValue" class="font-semibold">0 FCFA</span></div>
                            <div class="flex items-center justify-between"><span>TVA (18%)</span><span id="taxValue" class="font-semibold">0 FCFA</span></div>
                            <div class="border-t border-market-line pt-5">
                                <div class="flex items-center justify-between gap-4 font-display text-2xl font-extrabold text-market-pine sm:text-4xl">
                                    <span>TOTAL A PAYER</span>
                                    <span id="totalValue">0 FCFA</span>
                                </div>
                            </div>
                        </div>
                        <div id="hiddenInputs"></div>
                        <button class="mt-8 flex w-full items-center justify-center gap-3 rounded-[1.6rem] bg-market-gold px-5 py-4 text-lg font-bold text-white shadow-float sm:gap-4 sm:px-6 sm:py-5 sm:text-3xl" type="submit">
                            <span>VALIDER LA VENTE (Entree)</span>
                        </button>
                        <div class="mt-5 grid gap-4 sm:grid-cols-2">
                            <button type="button" id="printButton" class="rounded-[1.35rem] border-2 border-market-pine px-6 py-4 text-lg font-bold text-market-pine sm:text-2xl">Ticket</button>
                            <button type="button" id="cancelCart" class="rounded-[1.35rem] border-2 border-red-500 px-6 py-4 text-lg font-bold text-red-500 sm:text-2xl">ANNULER (Esc)</button>
                        </div>
                    </div>
                </form>
            </aside>
        </div>
    </main>
    <div class="hidden bg-market-pine px-10 py-4 text-lg text-white lg:flex lg:items-center lg:justify-center lg:gap-8">
        <span class="rounded-xl bg-white/10 px-4 py-2">F1 Recherche</span>
        <span class="rounded-xl bg-white/10 px-4 py-2">F2 Quantite</span>
        <span class="rounded-xl bg-white/10 px-4 py-2">F5 Nouveau Ticket</span>
        <span class="rounded-xl bg-white/10 px-4 py-2">Entree Valider</span>
        <span class="rounded-xl bg-white/10 px-4 py-2">Esc Annuler</span>
    </div>
</div>
<script>
    const sidebarToggle = document.getElementById('sidebarToggle');
    const appSidebar = document.getElementById('appSidebar');
    if (sidebarToggle && appSidebar) {
        sidebarToggle.addEventListener('click', () => {
            appSidebar.classList.toggle('-translate-x-full');
        });
    }

    const productSearch = document.getElementById('productSearch');
    const productGrid = document.getElementById('productGrid');
    const productCards = Array.from(document.querySelectorAll('.product-card'));
    const categoryTabs = document.getElementById('categoryTabs');
    const cartItems = document.getElementById('cartItems');
    const emptyCart = document.getElementById('emptyCart');
    const cartCountBadge = document.getElementById('cartCountBadge');
    const subtotalValue = document.getElementById('subtotalValue');
    const taxValue = document.getElementById('taxValue');
    const totalValue = document.getElementById('totalValue');
    const hiddenInputs = document.getElementById('hiddenInputs');
    const cancelCart = document.getElementById('cancelCart');
    const saleForm = document.getElementById('saleForm');
    const printButton = document.getElementById('printButton');
    const cart = new Map();
    let currentCategory = '';

    function formatFcfa(value) {
        return new Intl.NumberFormat('fr-FR', { maximumFractionDigits: 0 }).format(value) + ' FCFA';
    }

    function escapeHtml(value) {
        return value.replace(/[&<>"']/g, (char) => ({
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#39;'
        }[char]));
    }

    function buildCategoryTabs() {
        const categories = [...new Set(productCards.map((card) => card.dataset.category).filter(Boolean))];
        categories.forEach((category) => {
            const button = document.createElement('button');
            button.type = 'button';
            button.dataset.category = category;
            button.className = 'category-tab whitespace-nowrap rounded-full bg-market-mint px-5 py-3 text-market-pine sm:px-8 sm:py-4';
            button.textContent = category.charAt(0).toUpperCase() + category.slice(1);
            categoryTabs.appendChild(button);
        });
    }

    function filterProducts() {
        const term = productSearch.value.trim().toLowerCase();
        productCards.forEach((card) => {
            const matchesSearch = !term || card.dataset.name.includes(term) || card.dataset.code.includes(term) || card.dataset.category.includes(term);
            const matchesCategory = !currentCategory || card.dataset.category === currentCategory;
            card.style.display = matchesSearch && matchesCategory ? '' : 'none';
        });
    }

    function renderCart() {
        const items = Array.from(cart.values());
        emptyCart.style.display = items.length ? 'none' : '';
        cartCountBadge.textContent = items.length + (items.length > 1 ? ' ARTICLES' : ' ARTICLE');
        hiddenInputs.innerHTML = '';

        let subtotal = 0;
        cartItems.querySelectorAll('.cart-item').forEach((node) => node.remove());

        items.forEach((item) => {
            subtotal += item.price * item.quantity;
            const row = document.createElement('div');
            row.className = 'cart-item rounded-[1.6rem] bg-market-cream p-4 sm:p-5';
            row.innerHTML =
                '<div class="flex flex-col gap-4 sm:flex-row sm:items-center">'
                + '<div class="flex h-16 w-16 items-center justify-center rounded-[1rem] bg-white text-xl font-bold text-market-pine sm:h-20 sm:w-20 sm:rounded-[1.2rem] sm:text-2xl">' + escapeHtml(item.name.charAt(0)) + '</div>'
                + '<div class="min-w-0 flex-1">'
                + '<p class="truncate text-xl font-semibold text-market-pine sm:text-3xl">' + escapeHtml(item.name) + '</p>'
                + '<p class="mt-1 text-lg text-slate-500 sm:text-2xl">' + formatFcfa(item.price) + ' / unite</p>'
                + '<p class="mt-1 text-sm text-slate-500 sm:text-lg">Stock: ' + item.stock + '</p>'
                + '</div>'
                + '<div class="text-left sm:text-right">'
                + '<p class="text-xl font-bold text-market-pine sm:text-3xl">' + formatFcfa(item.price * item.quantity) + '</p>'
                + '<div class="mt-4 inline-flex items-center gap-4 rounded-[1rem] border border-market-line bg-white px-4 py-3 text-lg font-bold text-market-pine sm:gap-5 sm:px-5 sm:text-2xl">'
                + '<button type="button" class="qty-minus" data-id="' + item.id + '">-</button>'
                + '<span>' + item.quantity + '</span>'
                + '<button type="button" class="qty-plus" data-id="' + item.id + '">+</button>'
                + '</div>'
                + '</div>'
                + '</div>';
            cartItems.appendChild(row);

            hiddenInputs.insertAdjacentHTML('beforeend', '<input type="hidden" name="produitId" value="' + item.id + '"><input type="hidden" name="quantite" value="' + item.quantity + '">');
        });

        const tax = Math.round(subtotal * 0.18);
        const total = subtotal + tax;
        subtotalValue.textContent = formatFcfa(subtotal);
        taxValue.textContent = formatFcfa(tax);
        totalValue.textContent = formatFcfa(total);

        document.querySelectorAll('.qty-minus').forEach((button) => {
            button.addEventListener('click', () => updateQuantity(button.dataset.id, -1));
        });
        document.querySelectorAll('.qty-plus').forEach((button) => {
            button.addEventListener('click', () => updateQuantity(button.dataset.id, 1));
        });
    }

    function updateQuantity(id, delta) {
        const item = cart.get(id);
        if (!item) return;
        item.quantity += delta;
        if (item.quantity <= 0) {
            cart.delete(id);
        }
        renderCart();
    }

    function addToCart(card) {
        const id = card.dataset.id;
        const existing = cart.get(id);
        if (existing) {
            if (existing.quantity < Number(card.dataset.stock)) {
                existing.quantity += 1;
            }
        } else {
            cart.set(id, {
                id,
                name: card.querySelector('p').textContent.trim(),
                price: Number(card.dataset.price),
                quantity: 1,
                stock: Number(card.dataset.stock)
            });
        }
        renderCart();
    }

    buildCategoryTabs();
    filterProducts();

    productSearch.addEventListener('input', filterProducts);
    categoryTabs.addEventListener('click', (event) => {
        const target = event.target.closest('.category-tab');
        if (!target) return;
        currentCategory = target.dataset.category || '';
        categoryTabs.querySelectorAll('.category-tab').forEach((button) => {
            button.className = 'category-tab whitespace-nowrap rounded-full px-5 py-3 sm:px-8 sm:py-4 ' + (button.dataset.category === currentCategory ? 'bg-market-pine text-white shadow-float' : 'bg-market-mint text-market-pine');
        });
        if (!currentCategory) {
            categoryTabs.querySelector('.category-tab').className = 'category-tab whitespace-nowrap rounded-full bg-market-pine px-5 py-3 text-white shadow-float sm:px-8 sm:py-4';
        }
        filterProducts();
    });

    productGrid.addEventListener('click', (event) => {
        const trigger = event.target.closest('.add-product');
        if (!trigger) return;
        addToCart(trigger.closest('.product-card'));
    });

    cancelCart.addEventListener('click', () => {
        cart.clear();
        renderCart();
    });

    printButton.addEventListener('click', () => {
        window.print();
    });

    saleForm.addEventListener('submit', (event) => {
        if (cart.size === 0) {
            event.preventDefault();
            alert('Ajoute au moins un produit avant de valider la vente.');
        }
    });

    document.addEventListener('keydown', (event) => {
        if (event.key === 'Escape') {
            cart.clear();
            renderCart();
        }
        if (event.key === 'Enter' && document.activeElement !== saleForm.querySelector('select')) {
            event.preventDefault();
            saleForm.requestSubmit();
        }
    });

    renderCart();
</script>
</body>
</html>
