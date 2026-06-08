<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<header class="sticky top-0 z-30 border-b border-market-line bg-white/92 backdrop-blur-xl">
    <div class="flex min-h-[5.75rem] flex-wrap items-center justify-between gap-4 px-4 py-3 sm:px-6 lg:flex-nowrap lg:px-10">
        <div class="min-w-0 flex items-center gap-4">
            <button id="sidebarToggle" type="button" class="inline-flex h-11 w-11 items-center justify-center rounded-2xl border border-market-line text-market-pine lg:hidden">
                <svg class="h-6 w-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 7h16M4 12h16M4 17h16"/></svg>
            </button>
            <div class="min-w-0">
                <p class="truncate font-display text-2xl font-extrabold text-market-pine sm:text-3xl lg:text-4xl">${pageTitle}</p>
                <c:if test="${not empty pageSubtitle}">
                    <p class="mt-1 hidden max-w-2xl truncate text-sm text-slate-500 md:block">${pageSubtitle}</p>
                </c:if>
            </div>
        </div>
        <form method="get" action="${pageContext.request.requestURI}" class="flex w-full items-center gap-3 rounded-full border border-market-line bg-market-cream px-4 py-1 text-slate-500 xl:hidden">
            <svg class="h-5 w-5 flex-shrink-0 text-market-pine" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="7"/><path d="m20 20-3.5-3.5"/></svg>
            <input class="w-full min-w-0 bg-transparent text-sm outline-none placeholder:text-slate-400 sm:text-base" type="text" name="search" value="${topbarSearchValue}" placeholder="${not empty topbarSearchPlaceholder ? topbarSearchPlaceholder : 'Rechercher...'}">
        </form>
        <div class="hidden min-w-0 flex-1 items-center justify-end gap-4 xl:flex">
            <form method="get" action="${pageContext.request.requestURI}" class="flex w-full max-w-[30rem] items-center gap-3 rounded-full border border-market-line bg-market-cream px-5 py-1 text-slate-500">
                <svg class="h-5 w-5 flex-shrink-0 text-market-pine" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="7"/><path d="m20 20-3.5-3.5"/></svg>
                <input class="w-full bg-transparent text-base outline-none placeholder:text-slate-400" type="text" name="search" value="${topbarSearchValue}" placeholder="${not empty topbarSearchPlaceholder ? topbarSearchPlaceholder : 'Rechercher...'}">
            </form>
            <div class="flex items-center gap-3">
                <button id="cartIconButton" class="relative flex h-11 w-11 items-center justify-center rounded-full border border-market-line bg-white text-market-pine">
                    <svg class="h-6 w-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M6 6h15l-1.5 9h-12L5 6H3"/>
                        <circle cx="8" cy="19" r="1.5"/>
                        <circle cx="17" cy="19" r="1.5"/>
                    </svg>
                    <span id="cartBadgeCount" class="absolute -top-1 -right-1 flex h-5 w-5 items-center justify-center rounded-full bg-market-gold text-xs font-bold text-white">0</span>
                </button>
          
                <!-- Avatar utilisateur avec DiceBear -->
                <div class="flex items-center gap-3 rounded-full bg-market-cream px-3 py-2">
                    <c:choose>
                        <c:when test="${not empty sessionScope.utilisateurConnecte}">
                            <c:set var="userFullName" value="${sessionScope.utilisateurConnecte.prenom} ${sessionScope.utilisateurConnecte.nom}" />
                            <c:set var="avatarSeed" value="${fn:replace(userFullName, ' ', '%20')}" />
                        </c:when>
                        <c:otherwise>
                            <c:set var="avatarSeed" value="Admin" />
                        </c:otherwise>
                    </c:choose>
                    <img src="https://api.dicebear.com/10.x/adventurer/svg?seed=${avatarSeed}&backgroundColor=ecfdf5&radius=50"
                         alt="Avatar"
                         class="h-11 w-11 rounded-full object-cover border border-market-line" />
                    <div class="pr-2">
                        <p class="font-semibold text-market-pine">
                            <c:choose>
                                <c:when test="${not empty sessionScope.utilisateurConnecte}">${sessionScope.utilisateurConnecte.prenom} ${sessionScope.utilisateurConnecte.nom}</c:when>
                                <c:otherwise>Admin</c:otherwise>
                            </c:choose>
                        </p>
                        <p class="text-xs uppercase tracking-[0.2em] text-slate-500">
                            <c:choose>
                                <c:when test="${not empty sessionScope.utilisateurConnecte}">${sessionScope.utilisateurConnecte.role}</c:when>
                                <c:otherwise>Gestion</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const cartIcon = document.getElementById('cartIconButton');
        if (cartIcon) {
            cartIcon.addEventListener('click', function(e) {
                e.preventDefault();
                const cartSidebar = document.getElementById('cartSidebar');
                if (cartSidebar) {
                    cartSidebar.classList.remove('translate-x-full');
                } else {
                    const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1)) || '';
                    window.location.href = contextPath + '/caisse';
                }
            });
        }
    });
</script>