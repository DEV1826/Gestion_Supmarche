<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <%@ include file="/views/partials/head.jspf" %>
    <title>Modifier produit</title>
</head>
<body class="app-shell">
<c:set var="activePage" value="products"/>
<c:set var="pageTitle" value="Modifier produit"/>
<c:set var="pageSubtitle" value="Mettre a jour les informations du catalogue."/>
<jsp:include page="/views/partials/sidebar.jsp"/>
<div class="lg:pl-[19rem]">
    <jsp:include page="/views/partials/topbar.jsp"/>
    <main class="px-4 py-6 sm:px-6 lg:px-10">
        <section class="page-card p-8">
            <div class="mb-8">
                <p class="text-lg font-semibold uppercase tracking-[0.2em] text-market-pine">Edition</p>
                <h1 class="mt-3 font-display text-5xl font-extrabold text-market-pine">Modifier produit</h1>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/produits/update" class="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
                <input type="hidden" name="id" value="${produit.id}">
                <input class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="text" name="codeBarre" value="${produit.codeBarre}" placeholder="Code barre" required>
                <input class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="text" name="designation" value="${produit.designation}" placeholder="Designation" required>
                <input class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="text" name="categorie" value="${produit.categorie}" placeholder="Categorie" required>
                <input class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="number" step="0.01" name="prixAchat" value="${produit.prixAchat}" placeholder="Prix achat" required>
                <input class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="number" step="0.01" name="prixVente" value="${produit.prixVente}" placeholder="Prix vente" required>
                <input class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="number" name="stockActuel" value="${produit.stockActuel}" placeholder="Stock actuel" required>
                <input class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="number" name="stockMinimum" value="${produit.stockMinimum}" placeholder="Stock minimum" required>
                <input class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" type="date" name="datePeremption" value="${produit.datePeremption}">
                <select class="rounded-[1.3rem] border border-market-line bg-market-cream px-5 py-4 text-lg outline-none" name="fournisseurId">
                    <option value="">Fournisseur</option>
                    <c:forEach items="${fournisseurs}" var="f">
                        <option value="${f.id}" <c:if test="${produit.fournisseurId == f.id}">selected</c:if>>${f.raisonSociale}</option>
                    </c:forEach>
                </select>
                <div class="flex flex-wrap gap-3 xl:col-span-4">
                    <button class="rounded-[1.3rem] bg-market-pine px-6 py-4 text-xl font-bold text-white" type="submit">Enregistrer</button>
                    <a class="rounded-[1.3rem] border border-market-line bg-white px-6 py-4 text-xl font-semibold text-market-pine" href="${pageContext.request.contextPath}/produits">Annuler</a>
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
