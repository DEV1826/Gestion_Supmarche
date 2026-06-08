<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <%@ include file="/WEB-INF/views/partials/head.jspf" %>
    <title>Connexion</title>
</head>
<body class="min-h-screen bg-market-grid [background-size:24px_24px]">
<main class="mx-auto flex min-h-screen max-w-7xl flex-col items-center justify-center px-4 py-10">
    <div class="mb-10 flex items-center gap-4">
        <div class="flex h-16 w-16 items-center justify-center rounded-2xl bg-market-pine text-white shadow-float">
            <svg class="h-8 w-8" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 7a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v10H4z"/><path d="M9 11h6"/><path d="M10 5v3"/><path d="M14 5v3"/></svg>
        </div>
        <p class="font-display text-5xl font-extrabold text-market-pine">Supermarche</p>
    </div>

    <section class="w-full max-w-2xl rounded-[2.3rem] border border-white/80 bg-white/95 px-6 py-10 shadow-panel sm:px-10 sm:py-12">
        <div class="mx-auto max-w-xl text-center">
            <h1 class="font-display text-5xl font-extrabold text-market-ink sm:text-6xl">Bienvenue</h1>
            <p class="mt-4 text-lg leading-8 text-slate-500">Veuillez vous identifier pour acceder au terminal de gestion.</p>
        </div>

        <% if (request.getAttribute("erreur") != null) { %>
        <div class="mx-auto mt-8 max-w-xl rounded-[1.4rem] border border-red-200 bg-red-50 px-5 py-4 text-sm font-semibold text-red-700"><%= request.getAttribute("erreur") %></div>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/login" class="mx-auto mt-9 max-w-xl space-y-7">
            <div>
                <label class="mb-3 block text-lg font-bold text-market-ink">Login</label>
                <div class="flex items-center gap-4 rounded-[1.55rem] border border-market-line bg-slate-50 px-5 py-4">
                    <svg class="h-7 w-7 text-slate-400" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="4"/><path d="M16 8v1"/><path d="M20 12a8 8 0 1 1-2.34-5.66"/></svg>
                    <input class="w-full bg-transparent text-2xl text-market-ink outline-none placeholder:text-slate-400" type="text" name="login" placeholder="super" required>
                </div>
            </div>
            <div>
                <div class="mb-3 flex items-center justify-between gap-4">
                    <label class="block text-lg font-bold text-market-ink">Mot de passe</label>
                    <span class="font-semibold text-market-pine">Oublie ?</span>
                </div>
                <div class="flex items-center gap-4 rounded-[1.55rem] border border-market-line bg-slate-50 px-5 py-4">
                    <svg class="h-7 w-7 text-slate-400" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="5" y="11" width="14" height="9" rx="2"/><path d="M8 11V8a4 4 0 1 1 8 0v3"/></svg>
                    <input class="w-full bg-transparent text-2xl text-market-ink outline-none placeholder:text-slate-400" type="password" name="motDePasse" placeholder="••••••••••" required>
                    <svg class="h-7 w-7 text-slate-400" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M2 12s3.5-6 10-6 10 6 10 6-3.5 6-10 6S2 12 2 12Z"/><circle cx="12" cy="12" r="3"/></svg>
                </div>
            </div>
            <label class="flex items-center gap-3 text-lg text-slate-500">
                <input class="h-6 w-6 rounded border-market-line text-market-pine focus:ring-market-pine" type="checkbox">
                <span>Rester connecte sur cet appareil</span>
            </label>
            <button class="flex w-full items-center justify-center gap-4 rounded-[1.45rem] bg-market-pine px-6 py-5 text-2xl font-bold text-white shadow-float transition hover:bg-market-moss" type="submit">
                <span>Connexion</span>
                <svg class="h-7 w-7" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4"><path d="M5 12h14"/><path d="m13 5 7 7-7 7"/></svg>
            </button>
        </form>

        <div class="mx-auto mt-10 max-w-xl rounded-[1.55rem] border border-slate-100 bg-slate-50 px-5 py-5">
            <div class="flex items-center justify-center gap-4 text-center">
                <span class="inline-flex h-7 w-7 rounded-full bg-gradient-to-r from-blue-400 to-market-pine shadow"></span>
                <p class="text-lg font-bold uppercase tracking-[0.18em] text-market-pine">Systeme operationnel</p>
            </div>
        </div>

        <p class="mt-10 text-center text-lg text-slate-500">Besoin d'aide ? <span class="font-bold text-market-pine">Contacter le support IT</span></p>
    </section>
</main>
</body>
</html>
