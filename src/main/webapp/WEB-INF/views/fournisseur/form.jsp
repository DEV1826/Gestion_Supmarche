<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <%@ include file="/WEB-INF/views/partials/head.jspf" %>
    <title>Modifier fournisseur</title>
</head>
<body class="app-shell">
<c:set var="activePage" value="suppliers"/>
<c:set var="pageTitle" value="Modifier fournisseur"/>
<c:set var="pageSubtitle" value="Mettre a jour les informations du partenaire."/>
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp"/>
<jsp:include page="/WEB-INF/views/partials/panier-sidebar.jsp"/>
<div class="lg:pl-[19rem]">
    <jsp:include page="/WEB-INF/views/partials/topbar.jsp"/>
    <main class="px-4 py-6 sm:px-6 lg:px-10">
        <section class="page-card p-8">
            <div class="mb-8">
                <p class="text-lg font-semibold uppercase tracking-[0.2em] text-market-pine">Edition</p>
                <h1 class="mt-3 font-display text-5xl font-extrabold text-market-pine">Modifier fournisseur</h1>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/fournisseurs/update" class="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
                <input type="hidden" name="id" value="${fournisseur.id}">
                <input class="md:col-span-2 xl:col-span-4 rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="text" name="raisonSociale" value="${fournisseur.raisonSociale}" placeholder="Raison sociale" required>
                <input class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="text" name="telephone" value="${fournisseur.telephone}" placeholder="Telephone">
                <input class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="email" name="email" value="${fournisseur.email}" placeholder="Email">
                <input class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="number" name="delaiLivraisonJours" value="${fournisseur.delaiLivraisonJours}" placeholder="Delai livraison">
                <input class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="text" name="conditionsPaiement" value="${fournisseur.conditionsPaiement}" placeholder="Conditions paiement">
                <div class="flex flex-wrap gap-3 xl:col-span-4">
                    <button class="rounded-[1.3rem] bg-market-pine px-6 py-4 text-xl font-bold text-white" type="submit">Enregistrer</button>
                    <a class="rounded-[1.3rem] border border-market-line bg-white px-6 py-4 text-xl font-semibold text-market-pine" href="${pageContext.request.contextPath}/fournisseurs">Annuler</a>
                </div>
            </form>
        </section>
    </main>
</div>
<script>
    const sidebarToggle = document.getElementById('sidebarToggle');
    const appSidebar = document.getElementById('appSidebar');
    if (sidebarToggle && appSidebar) {
        sidebarToggle.addEventListener('click', () => {
            appSidebar.classList.toggle('-translate-x-full');
        });
    }
</script>
</body>
</html>
