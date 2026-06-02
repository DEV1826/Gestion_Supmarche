<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <%@ include file="/views/partials/head.jspf" %>
    <title>Erreur</title>
</head>
<body class="min-h-screen bg-market-grid [background-size:24px_24px]">
<main class="mx-auto flex min-h-screen max-w-5xl items-center justify-center px-4 py-10">
    <section class="w-full max-w-3xl rounded-[2.2rem] border border-white/80 bg-white/95 px-8 py-12 text-center shadow-panel">
        <p class="text-lg font-semibold uppercase tracking-[0.22em] text-red-500">Erreur 500</p>
        <h1 class="mt-5 font-display text-6xl font-extrabold text-market-pine">Erreur interne</h1>
        <p class="mt-5 text-2xl leading-10 text-slate-500">Une erreur est survenue pendant le traitement.</p>
        <div class="mt-10 flex flex-wrap items-center justify-center gap-4">
            <a class="rounded-[1.35rem] bg-market-pine px-6 py-4 text-xl font-bold text-white shadow-float" href="${pageContext.request.contextPath}/dashboard">Retour au dashboard</a>
            <a class="rounded-[1.35rem] border border-market-line bg-white px-6 py-4 text-xl font-semibold text-market-pine" href="${pageContext.request.contextPath}/ventes/nouvelle">Retour a la caisse</a>
        </div>
    </section>
</main>
</body>
</html>
