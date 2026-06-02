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
        <form method="get" action="${pageContext.request.requestURI}" class="flex w-full items-center gap-3 rounded-full border border-market-line bg-market-cream px-4 py-3 text-slate-500 xl:hidden">
            <svg class="h-5 w-5 flex-shrink-0 text-market-pine" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="7"/><path d="m20 20-3.5-3.5"/></svg>
            <input class="w-full min-w-0 bg-transparent text-sm outline-none placeholder:text-slate-400 sm:text-base" type="text" name="search" value="${topbarSearchValue}" placeholder="${not empty topbarSearchPlaceholder ? topbarSearchPlaceholder : 'Rechercher...'}">
        </form>
        <div class="hidden min-w-0 flex-1 items-center justify-end gap-4 xl:flex">
            <form method="get" action="${pageContext.request.requestURI}" class="flex w-full max-w-[30rem] items-center gap-3 rounded-full border border-market-line bg-market-cream px-5 py-3 text-slate-500">
                <svg class="h-5 w-5 flex-shrink-0 text-market-pine" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="7"/><path d="m20 20-3.5-3.5"/></svg>
                <input class="w-full bg-transparent text-base outline-none placeholder:text-slate-400" type="text" name="search" value="${topbarSearchValue}" placeholder="${not empty topbarSearchPlaceholder ? topbarSearchPlaceholder : 'Rechercher...'}">
            </form>
            <div class="flex items-center gap-3">
                <div class="flex h-11 w-11 items-center justify-center rounded-full border border-market-line bg-white text-market-pine">
                    <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M15 17h5l-1.4-1.4A2 2 0 0 1 18 14.2V11a6 6 0 1 0-12 0v3.2a2 2 0 0 1-.6 1.4L4 17h5"/><path d="M10 21a2 2 0 0 0 4 0"/></svg>
                </div>
                <div class="flex items-center gap-3 rounded-full bg-market-cream px-3 py-2">
                    <div class="flex h-11 w-11 items-center justify-center rounded-full bg-market-pine text-sm font-bold text-white">
                        <c:choose>
                            <c:when test="${not empty sessionScope.utilisateurConnecte}">
                                ${fn:substring(sessionScope.utilisateurConnecte.prenom, 0, 1)}${fn:substring(sessionScope.utilisateurConnecte.nom, 0, 1)}
                            </c:when>
                            <c:otherwise>AD</c:otherwise>
                        </c:choose>
                    </div>
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
