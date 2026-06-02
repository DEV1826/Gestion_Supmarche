<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<nav class="sticky top-0 z-20 border-b border-market-pine/10 bg-market-pine/90 text-white shadow-[0_12px_30px_rgba(23,53,42,0.14)] backdrop-blur-xl">
    <div class="mx-auto flex w-full max-w-7xl flex-col gap-4 px-4 py-4 sm:px-6 lg:flex-row lg:items-center lg:justify-between">
        <div class="flex items-center gap-3">
            <div class="flex h-11 w-11 items-center justify-center rounded-2xl bg-white/10 text-lg font-black text-market-gold ring-1 ring-white/10">S</div>
            <div>
                <p class="text-[11px] uppercase tracking-[0.34em] text-white/55">Gestion Supermarche</p>
                <p class="font-display text-xl font-bold">Pilotage magasin</p>
            </div>
        </div>
        <div class="grid w-full grid-cols-2 gap-2 text-sm font-semibold sm:grid-cols-3 lg:flex lg:w-auto lg:flex-wrap">
            <a class="rounded-2xl border border-white/10 bg-white/8 px-4 py-2.5 text-center transition hover:-translate-y-0.5 hover:bg-white/18" href="${pageContext.request.contextPath}/produits">Produits</a>
            <a class="rounded-2xl border border-white/10 bg-white/8 px-4 py-2.5 text-center transition hover:-translate-y-0.5 hover:bg-white/18" href="${pageContext.request.contextPath}/fournisseurs">Fournisseurs</a>
            <a class="rounded-2xl border border-white/10 bg-white/8 px-4 py-2.5 text-center transition hover:-translate-y-0.5 hover:bg-white/18" href="${pageContext.request.contextPath}/stock/alertes">Alertes</a>
            <a class="rounded-2xl border border-white/10 bg-white/8 px-4 py-2.5 text-center transition hover:-translate-y-0.5 hover:bg-white/18" href="${pageContext.request.contextPath}/ventes/nouvelle">Caisse</a>
            <a class="rounded-2xl border border-white/10 bg-white/8 px-4 py-2.5 text-center transition hover:-translate-y-0.5 hover:bg-white/18" href="${pageContext.request.contextPath}/stats">Stats</a>
            <a class="rounded-2xl bg-market-gold px-4 py-2.5 text-center text-slate-950 transition hover:-translate-y-0.5 hover:brightness-95" href="${pageContext.request.contextPath}/logout">Deconnexion</a>
        </div>
    </div>
</nav>
