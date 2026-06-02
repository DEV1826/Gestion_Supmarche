<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<aside id="appSidebar" class="blue-scroll fixed inset-y-0 left-0 z-40 flex w-[17.5rem] max-w-[88vw] -translate-x-full flex-col border-r border-market-line bg-white shadow-panel transition-transform duration-300 lg:w-[19rem] lg:translate-x-0">
    <div class="border-b border-market-line px-7 py-7">
        <p class="font-display text-[2rem] font-extrabold tracking-tight text-market-pine sm:text-[2.5rem]">
            <c:choose>
                <c:when test="${not empty sidebarBrand}">${sidebarBrand}</c:when>
                <c:otherwise>Supermarche</c:otherwise>
            </c:choose>
        </p>
        <c:if test="${not empty sidebarSubtitle}">
            <p class="mt-2 text-sm text-slate-500">${sidebarSubtitle}</p>
        </c:if>
    </div>
    <nav class="flex-1 space-y-2 overflow-y-auto px-4 py-5 text-base font-semibold sm:px-5 sm:py-6 sm:text-[1.08rem]">
        <a class="sidebar-link ${activePage eq 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/dashboard">
            <svg class="sidebar-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9"><path d="M4 4h6v6H4zM14 4h6v10h-6zM4 14h6v6H4zM14 18h6v2h-6z"/></svg>
            <span>Dashboard</span>
        </a>
        <a class="sidebar-link ${activePage eq 'products' ? 'active' : ''}" href="${pageContext.request.contextPath}/produits">
            <svg class="sidebar-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9"><path d="M5 4h14v4H5z"/><path d="M6 8h12v11H6z"/><path d="M9 12h6"/></svg>
            <span>Produits</span>
        </a>
        <a class="sidebar-link ${activePage eq 'suppliers' ? 'active' : ''}" href="${pageContext.request.contextPath}/fournisseurs">
            <svg class="sidebar-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9"><path d="M7 7h10l3 5-8 8-8-8z"/><path d="M7 7 4 12"/><path d="M17 7 20 12"/></svg>
            <span>Fournisseurs</span>
        </a>
        <a class="sidebar-link ${activePage eq 'alerts' ? 'active' : ''}" href="${pageContext.request.contextPath}/stock/alertes">
            <svg class="sidebar-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9"><path d="M12 4 3 20h18L12 4Z"/><path d="M12 9v5"/><path d="M12 18h.01"/></svg>
            <span>Alertes Stock</span>
        </a>
        <a class="sidebar-link ${activePage eq 'cashier' ? 'active' : ''}" href="${pageContext.request.contextPath}/ventes/nouvelle">
            <svg class="sidebar-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9"><path d="M4 7h16v4H4z"/><path d="M6 11h12v8H6z"/><path d="M9 15h1"/><path d="M12 15h1"/><path d="M15 15h1"/></svg>
            <span>Caisse</span>
        </a>
        <a class="sidebar-link ${activePage eq 'stats' ? 'active' : ''}" href="${pageContext.request.contextPath}/stats">
            <svg class="sidebar-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9"><path d="M4 18 10 12l4 4 6-8"/><path d="M4 6v12h16"/></svg>
            <span>Stats</span>
        </a>
    </nav>
    <div class="border-t border-market-line px-5 py-5">
        <c:choose>
            <c:when test="${not empty sessionScope.utilisateurConnecte}">
                <div class="mb-5 flex items-center gap-3 rounded-[1.4rem] bg-market-cream px-4 py-3">
                    <div class="flex h-12 w-12 items-center justify-center rounded-full bg-market-mint text-lg font-bold text-market-pine">
                        ${fn:substring(sessionScope.utilisateurConnecte.prenom, 0, 1)}${fn:substring(sessionScope.utilisateurConnecte.nom, 0, 1)}
                    </div>
                    <div>
                        <p class="font-semibold text-market-pine">${sessionScope.utilisateurConnecte.prenom} ${sessionScope.utilisateurConnecte.nom}</p>
                        <p class="text-sm text-slate-500">${sessionScope.utilisateurConnecte.role}</p>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="mb-5 rounded-[1.4rem] bg-market-cream px-4 py-3 text-sm text-slate-500">Session admin</div>
            </c:otherwise>
        </c:choose>
        <a class="flex items-center justify-center gap-3 rounded-[1.3rem] bg-market-gold px-4 py-3 text-lg font-bold text-white shadow-float" href="${pageContext.request.contextPath}/logout">
            <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 6H5v12h4"/><path d="m16 17 5-5-5-5"/><path d="M21 12H9"/></svg>
            <span>Deconnexion</span>
        </a>
    </div>
</aside>
