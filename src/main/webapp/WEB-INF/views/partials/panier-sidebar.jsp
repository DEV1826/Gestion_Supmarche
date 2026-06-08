<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- Sidebar Panier (droit) -->
<div id="cartSidebar" class="fixed inset-y-0 right-0 z-50 w-full max-w-md translate-x-full transform bg-white shadow-xl transition-transform duration-300 border-l border-market-line flex flex-col">
    <div class="flex items-center justify-between border-b border-market-line px-6 py-5">
        <h2 class="font-display text-2xl font-bold text-market-pine">Panier</h2>
        <button id="closeCartSidebar" class="rounded-full p-2 text-market-pine hover:bg-market-cream">
            <svg class="h-6 w-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>
        </button>
    </div>
    <div id="cartItemsSidebar" class="flex-1 overflow-y-auto p-5 space-y-4">
        <div id="emptyCartSidebar" class="text-center text-slate-500 py-10">Votre panier est vide.</div>
    </div>
    <div class="border-t border-market-line p-5 space-y-4">
        <div class="flex justify-between text-lg">
            <span>Sous-total</span>
            <span id="sidebarSubtotal" class="font-semibold">0 FCFA</span>
        </div>
        <div class="flex justify-between text-lg">
            <span>TVA (18%)</span>
            <span id="sidebarTax" class="font-semibold">0 FCFA</span>
        </div>
        <div class="flex justify-between text-2xl font-bold text-market-pine">
            <span>Total</span>
            <span id="sidebarTotal">0 FCFA</span>
        </div>
        <form id="saleFormSidebar" method="post" action="${pageContext.request.contextPath}/ventes/nouvelle">
            <label class="block text-sm font-semibold text-market-ink" for="sidebarModePaiement">Mode de paiement</label>
            <select id="sidebarModePaiement" name="modePaiement" class="w-full rounded-xl border border-market-line bg-market-cream px-4 py-3 text-base outline-none">
                <option value="ESPECES">Especes</option>
                <option value="CARTE">Carte</option>
                <option value="MOBILE_MONEY">Mobile Money</option>
            </select>
            <div id="hiddenInputsSidebar"></div>
            <div class="grid grid-cols-2 gap-4 mt-6">
                <button type="button" id="cancelCartSidebar" class="rounded-xl border border-red-300 bg-white py-3 font-semibold text-red-600 hover:bg-red-50">Annuler</button>
                <button type="submit" class="rounded-xl bg-market-pine py-3 font-semibold text-white hover:bg-market-pine/90">Valider</button>
            </div>
        </form>
    </div>
</div>

<script>
    (function() {
        let cartItemsContainer, emptyCartMsg, hiddenInputsDiv, sidebarSubtotal, sidebarTax, sidebarTotal, saleFormSidebar, cancelCartBtn;
        let cartSidebar, closeCartBtn;

        function formatFcfa(value) {
            return new Intl.NumberFormat('fr-FR').format(value) + ' FCFA';
        }

        function escapeHtml(str) {
            if (!str) return '';
            return str.replace(/[&<>]/g, function(m) {
                if (m === '&') return '&amp;';
                if (m === '<') return '&lt;';
                if (m === '>') return '&gt;';
                return m;
            });
        }

        function renderCartSidebar() {
            const items = CartManager.getItemsArray();
            emptyCartMsg.style.display = items.length ? 'none' : 'block';
            if (cartItemsContainer) {
                const existing = cartItemsContainer.querySelectorAll('.cart-item-sidebar');
                existing.forEach(el => el.remove());
            }
            if (hiddenInputsDiv) hiddenInputsDiv.innerHTML = '';

            let subtotal = 0;
            items.forEach(item => {
                subtotal += item.price * item.quantity;
                const row = document.createElement('div');
                row.className = 'cart-item-sidebar rounded-xl border border-market-line p-3';
                row.innerHTML =
                    '<div class="flex items-center justify-between">' +
                        '<div><strong class="text-market-pine">' + escapeHtml(item.name) + '</strong><br><span class="text-sm">' + formatFcfa(item.price) + '/u</span></div>' +
                        '<div class="flex items-center gap-3">' +
                            '<button class="qty-minus-sidebar" data-id="' + item.id + '">-</button>' +
                            '<span class="w-6 text-center">' + item.quantity + '</span>' +
                            '<button class="qty-plus-sidebar" data-id="' + item.id + '">+</button>' +
                            '<span class="ml-2 font-semibold">' + formatFcfa(item.price * item.quantity) + '</span>' +
                        '</div>' +
                    '</div>';
                cartItemsContainer.appendChild(row);
                hiddenInputsDiv.insertAdjacentHTML('beforeend',
                    '<input type="hidden" name="produitId" value="' + item.id + '">' +
                    '<input type="hidden" name="quantite" value="' + item.quantity + '">'
                );
            });

            const tax = Math.round(subtotal * 0.18);
            const total = subtotal + tax;
            sidebarSubtotal.textContent = formatFcfa(subtotal);
            sidebarTax.textContent = formatFcfa(tax);
            sidebarTotal.textContent = formatFcfa(total);

            // Réattacher événements +/-
            document.querySelectorAll('.qty-minus-sidebar').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    e.stopPropagation();
                    const id = btn.dataset.id;
                    const item = CartManager.getCart().get(id);
                    CartManager.updateQuantity(id, -1, item?.stock);
                    renderCartSidebar();
                });
            });
            document.querySelectorAll('.qty-plus-sidebar').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    e.stopPropagation();
                    const id = btn.dataset.id;
                    const item = CartManager.getCart().get(id);
                    CartManager.updateQuantity(id, 1, item?.stock);
                    renderCartSidebar();
                });
            });
        }

        function init() {
            cartSidebar = document.getElementById('cartSidebar');
            closeCartBtn = document.getElementById('closeCartSidebar');
            cartItemsContainer = document.getElementById('cartItemsSidebar');
            emptyCartMsg = document.getElementById('emptyCartSidebar');
            hiddenInputsDiv = document.getElementById('hiddenInputsSidebar');
            sidebarSubtotal = document.getElementById('sidebarSubtotal');
            sidebarTax = document.getElementById('sidebarTax');
            sidebarTotal = document.getElementById('sidebarTotal');
            saleFormSidebar = document.getElementById('saleFormSidebar');
            cancelCartBtn = document.getElementById('cancelCartSidebar');

            if (closeCartBtn) {
                closeCartBtn.addEventListener('click', () => cartSidebar.classList.add('translate-x-full'));
            }
            if (cancelCartBtn) {
                cancelCartBtn.addEventListener('click', () => {
                    CartManager.clearCart();
                    renderCartSidebar();
                });
            }
            if (saleFormSidebar) {
                saleFormSidebar.addEventListener('submit', (e) => {
                    if (CartManager.getTotalItems() === 0) {
                        e.preventDefault();
                        alert('Ajoutez au moins un produit.');
                    }
                });
            }
            window.addEventListener('cart:updated', () => renderCartSidebar());
            renderCartSidebar();
        }

        if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
        else init();
    })();
</script>
