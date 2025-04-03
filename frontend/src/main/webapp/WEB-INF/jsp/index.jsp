<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Productos</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css" integrity="sha512-jnSuA4Ss2PkkikSOLtYs8BlYIeeIK1h99ty4YfvRPAlzr377vr3CXDb7sb7eEEBYjDtcYj+AjBH3FLv5uSJuXg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

  <style>
    body {
      padding-top: 56px; /* Ajuste para navbar fija */
      background-color: #f8f9fa;
    }
    .product-card {
      margin-bottom: 2rem;
      transition: transform .2s ease-in-out, box-shadow .2s ease-in-out;
      height: 100%;
      display: flex;
      flex-direction: column;
    }
    .product-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
    }
    .product-card .card-img-top {
      width: 100%;
      aspect-ratio: 16 / 9;
      object-fit: cover;
      border-top-left-radius: var(--bs-card-inner-border-radius);
      border-top-right-radius: var(--bs-card-inner-border-radius);
      background-color: #eee;
    }
    .product-card .card-body {
      flex-grow: 1;
      display: flex;
      flex-direction: column;
    }
    .product-card .card-title { font-weight: bold; }
    .product-card .card-price {
      font-size: 1.25rem;
      font-weight: bold;
      color: var(--bs-primary);
      margin-top: auto;
      margin-bottom: 0.5rem;
    }
    .admin-controls { margin-top: 0.5rem; display: flex; gap: 0.5rem; }
    .pagination { justify-content: center; }
    #alertMessage, #modalErrorMessage { margin-top: 15px; }
    .loading-indicator { text-align: center; padding: 2rem; font-size: 1.2rem; }

    #imagePreviewArea {
      display: flex;
      flex-wrap: wrap;
      gap: 1rem;
      margin-top: 1rem;
      padding: 1rem;
      border: 1px dashed #ccc;
      border-radius: 0.375rem;
      min-height: 70px;
      background-color: #fff;
    }
    .img-preview-container {
      position: relative;
      width: 100px;
      aspect-ratio: 16 / 9;
      border: 1px solid #eee;
      border-radius: 0.375rem;
      overflow: hidden;
      display: flex;
      justify-content: center;
      align-items: center;
      background-color: #eee;
    }
    .img-preview {
      width: 100%;
      height: 100%;
      object-fit: cover;
      display: block;
    }
    .img-preview-overlay {
      position: absolute; top: 0; left: 0; right: 0; bottom: 0;
      background-color: rgba(0,0,0,0.4);
      display: flex; flex-direction: column; justify-content: center; align-items: center;
      opacity: 0; transition: opacity 0.2s ease-in-out;
    }
    .img-preview-container:hover .img-preview-overlay { opacity: 1; }
    .img-preview-overlay .btn { padding: 0.1rem 0.3rem; font-size: 0.7rem; margin-top: 0.2rem; }
    .img-preview-overlay .spinner-border { width: 1.5rem; height: 1.5rem; color: white; }
    .img-preview-overlay .upload-success { color: limegreen; font-size: 1.5rem; }
    .img-preview-overlay .upload-error { color: red; font-size: 0.7rem; text-align: center; padding: 2px; background-color: rgba(255,255,255,0.8); border-radius: 3px; }
  </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top shadow-sm">
  <div class="container-fluid">
    <a class="navbar-brand" href="#"> <i class="bi bi-shop"></i> Productos</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav ms-auto align-items-center">
        <li class="nav-item" id="add-product-button-li" style="display: none;">
          <button type="button" class="btn btn-success me-2" data-bs-toggle="modal" data-bs-target="#productModal" onclick="openProductModal(null)">
            <i class="bi bi-plus-circle-fill"></i> Añadir Producto
          </button>
        </li>
        <li class="nav-item" id="auth-button-li">
        </li>
      </ul>
    </div>
  </div>
</nav>

<div class="container mt-4">
  <div id="alertMessage" class="alert" role="alert" style="display: none;"></div>
  <div id="productGrid" class="row">
    <div class="loading-indicator">Cargando productos...</div>
  </div>
  <nav aria-label="Page navigation">
    <ul id="paginationControls" class="pagination mt-4"></ul>
  </nav>
</div>

<div class="modal fade" id="productModal" tabindex="-1" aria-labelledby="productModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="productModalLabel">Producto</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form id="productForm" novalidate>
          <input type="hidden" id="productId">
          <div class="mb-3">
            <label for="productName" class="form-label">Nombre:</label>
            <input type="text" id="productName" class="form-control" required>
            <div class="invalid-feedback">Por favor ingresa un nombre.</div>
          </div>
          <div class="mb-3">
            <label for="productDescription" class="form-label">Descripción:</label>
            <textarea id="productDescription" class="form-control" rows="3" required></textarea>
            <div class="invalid-feedback">Por favor ingresa una descripción.</div>
          </div>
          <div class="mb-3">
            <label for="productPrice" class="form-label">Precio:</label>
            <input type="number" id="productPrice" step="0.01" min="0" class="form-control" required>
            <div class="invalid-feedback">Por favor ingresa un precio válido (>= 0).</div>
          </div>
          <div class="mb-3">
            <label class="form-label">Imágenes:</label>
            <div>
              <input type="file" id="imageUploadInput" accept="image/webp,image/jpeg,image/png" style="display: none;" multiple>
              <button type="button" class="btn btn-secondary btn-sm" onclick="document.getElementById('imageUploadInput').click();">
                <i class="bi bi-upload"></i> Seleccionar Archivo(s)
              </button>
              <small class="form-text text-muted ms-2">Selecciona una o más imágenes.</small>
            </div>
            <div id="imagePreviewArea">
            </div>
            <div id="imageUploadError" class="text-danger small mt-2"></div>
          </div>
        </form>
        <div id="modalErrorMessage" class="alert alert-danger" role="alert" style="display: none;"></div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
        <button type="button" class="btn btn-primary" id="saveProductButton" onclick="saveProduct()">Guardar Cambios</button>
      </div>
    </div>
  </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js" integrity="sha512-7Pi/otdlbbCR+LnW+F7PwFcSDJOuUJB3OxtEHbg4vSMvzvJjde4Po1v4BR9Gdc9aXNUNFVUY+SK51wWT8WF0Gg==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script>
  // --- Funciones JWT Helper ---
  function parseJwt(token) { if (!token) { return null; } try { const base64Url = token.split('.')[1]; const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/'); const jsonPayload = decodeURIComponent(atob(base64).split('').map(function(c) { return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2); }).join('')); return JSON.parse(jsonPayload); } catch (e) { console.error("Error parsing JWT:", e); return null; } }
  function isAdmin(token) { if (!token) { return false; } const decodedToken = parseJwt(token); if (!decodedToken) { return false; } const authorities = decodedToken.authorities || decodedToken.roles || decodedToken.scp || []; return Array.isArray(authorities) && authorities.includes('ROLE_ADMIN'); }
  function getImageUrl(uuid) { if (!uuid) { return 'https://placehold.co/600x400/eee/ccc?text=No+Image'; } return `/api/image/\${uuid}`; } // *** AJUSTA ESTA URL ***
  function getContextPath() { return "${pageContext.request.contextPath}"; }
  // --- Fin Funciones JWT Helper ---

  // --- Referencias DOM ---
  const productGrid = document.getElementById('productGrid');
  const paginationControls = document.getElementById('paginationControls');
  const productModalElement = document.getElementById('productModal');
  const productModal = new bootstrap.Modal(productModalElement);
  const productModalLabel = document.getElementById('productModalLabel');
  const productForm = document.getElementById('productForm');
  const productIdInput = document.getElementById('productId');
  const productNameInput = document.getElementById('productName');
  const productDescriptionInput = document.getElementById('productDescription');
  const productPriceInput = document.getElementById('productPrice');
  const imageUploadInput = document.getElementById('imageUploadInput');
  const imagePreviewArea = document.getElementById('imagePreviewArea');
  const imageUploadErrorDiv = document.getElementById('imageUploadError');
  const alertMessageDiv = document.getElementById('alertMessage');
  const modalErrorMessageDiv = document.getElementById('modalErrorMessage');
  const authButtonLi = document.getElementById('auth-button-li');
  const addProductButtonLi = document.getElementById('add-product-button-li');

  // --- Variables Globales ---
  let currentAuthToken = null;
  let currentUserIsAdmin = false;
  const DEFAULT_PAGE_SIZE = 2;
  let uploadedImageUUIDs = [];
  let selectedFilesMap = new Map();

  // --- Funciones UI ---
  function showMessage(element, message, isSuccess = false) { element.textContent = message; element.className = `alert \${isSuccess ? 'alert-success' : 'alert-danger'}`; element.style.display = 'block'; setTimeout(() => { element.style.display = 'none'; }, 5000); }
  function clearFormErrors() { const inputs = productForm.querySelectorAll('.form-control'); inputs.forEach(input => input.classList.remove('is-invalid')); const errorDivs = productForm.querySelectorAll('.invalid-feedback'); errorDivs.forEach(div => div.textContent = ''); modalErrorMessageDiv.style.display = 'none'; imageUploadErrorDiv.textContent = ''; }
  function showFormError(fieldId, message) { const inputElement = document.getElementById(fieldId); if (inputElement) { inputElement.classList.add('is-invalid'); let errorDiv = inputElement.nextElementSibling; while(errorDiv && !errorDiv.classList.contains('invalid-feedback')) { errorDiv = errorDiv.nextElementSibling; } if (errorDiv) { errorDiv.textContent = message; } } }

  // --- Autenticación y UI ---
  function setupUIBasedOnAuth() {
    currentAuthToken = localStorage.getItem('token');
    currentUserIsAdmin = isAdmin(currentAuthToken);
    let authButtonHTML = '';
    if (currentAuthToken) {
      authButtonHTML = `<button id="logoutButton" class="btn btn-outline-light"><i class="bi bi-box-arrow-right"></i> Cerrar Sesión</button>`;
      addProductButtonLi.style.display = currentUserIsAdmin ? 'block' : 'none';
    } else {
      const loginUrl = getContextPath() + '/login';
      authButtonHTML = '<a href="' + loginUrl + '" class="btn btn-outline-light"><i class="bi bi-box-arrow-in-right"></i> Iniciar Sesión</a>';
      addProductButtonLi.style.display = 'none';
    }
    authButtonLi.innerHTML = authButtonHTML;
    const logoutButton = document.getElementById('logoutButton');
    if (logoutButton) { logoutButton.addEventListener('click', logout); }
  }
  function logout() { localStorage.removeItem('token'); currentAuthToken = null; currentUserIsAdmin = false; setupUIBasedOnAuth(); loadProducts(0); showMessage(alertMessageDiv, "Has cerrado sesión.", true); }

  // --- Lógica de Imágenes ---
  function handleFileSelection(event) {
    imageUploadErrorDiv.textContent = '';
    const files = event.target.files; if (!files) return;
    for (const file of files) {
      if (!file.type.startsWith('image/')) { imageUploadErrorDiv.textContent += `Archivo '\${file.name}' no es una imagen válida. `; continue; }
      const previewId = `preview-\${Date.now()}-\${Math.random().toString(16).substring(2)}`;
      selectedFilesMap.set(previewId, file);
      const reader = new FileReader();
      reader.onload = (e) => { renderSinglePreview(previewId, e.target.result, false); };
      reader.onerror = () => { console.error("Error leyendo archivo:", file.name); imageUploadErrorDiv.textContent += `Error al leer '\${file.name}'. `; selectedFilesMap.delete(previewId); };
      reader.readAsDataURL(file);
    }
    event.target.value = null;
  }
  function renderPreviews() {
    imagePreviewArea.innerHTML = '';
    uploadedImageUUIDs.forEach(uuid => { renderSinglePreview(uuid, getImageUrl(uuid), true); });
    // Renderizar previews pendientes (simplificado)
    if (uploadedImageUUIDs.length === 0 && selectedFilesMap.size === 0) { imagePreviewArea.innerHTML = '<p class="text-muted small w-100 text-center">No hay imágenes seleccionadas.</p>'; }
  }
  function renderSinglePreview(id, src, isUploaded) {
    const noImageMsg = imagePreviewArea.querySelector('p'); if (noImageMsg) noImageMsg.remove();
    const previewContainer = document.createElement('div'); previewContainer.className = 'img-preview-container'; previewContainer.dataset.id = id;
    const img = document.createElement('img'); img.className = 'img-preview'; img.src = src; img.alt = isUploaded ? 'Imagen subida' : 'Preview de imagen'; img.onerror = () => { img.src = 'https://placehold.co/100x100/eee/ccc?text=Error'; }
    const overlay = document.createElement('div'); overlay.className = 'img-preview-overlay';
    if (isUploaded) {
      overlay.innerHTML = `<button type="button" class="btn btn-danger btn-sm remove-btn" title="Eliminar asociación"><i class="bi bi-x-lg"></i></button>`;
    } else {
      overlay.innerHTML = `<div class="spinner-border spinner-border-sm" role="status" style="display: none;"><span class="visually-hidden">Subiendo...</span></div><div class="upload-success" style="display: none;"><i class="bi bi-check-circle-fill"></i></div><div class="upload-error" style="display: none;">Error</div><button type="button" class="btn btn-success btn-sm upload-btn" title="Subir esta imagen"><i class="bi bi-cloud-arrow-up-fill"></i> Subir</button><button type="button" class="btn btn-danger btn-sm remove-btn" title="Descartar selección"><i class="bi bi-x-lg"></i></button>`;
    }
    previewContainer.appendChild(img); previewContainer.appendChild(overlay); imagePreviewArea.appendChild(previewContainer);
  }
  function handlePreviewAreaClick(event) {
    const target = event.target; const removeButton = target.closest('.remove-btn'); const uploadButton = target.closest('.upload-btn'); const container = target.closest('.img-preview-container'); if (!container) return; const id = container.dataset.id;
    if (removeButton) {
      const uuidIndex = uploadedImageUUIDs.indexOf(id);
      if (uuidIndex > -1) { uploadedImageUUIDs.splice(uuidIndex, 1); container.remove(); if (uploadedImageUUIDs.length === 0 && selectedFilesMap.size === 0) { renderPreviews(); } }
      else if (selectedFilesMap.has(id)) { selectedFilesMap.delete(id); container.remove(); if (uploadedImageUUIDs.length === 0 && selectedFilesMap.size === 0) { renderPreviews(); } }
    } else if (uploadButton) {
      if (selectedFilesMap.has(id)) { const fileToUpload = selectedFilesMap.get(id); uploadImage(fileToUpload, container, id); }
    }
  }
  async function uploadImage(file, previewContainer, previewId) {
    if (!currentUserIsAdmin || !currentAuthToken) return;
    const overlay = previewContainer.querySelector('.img-preview-overlay'); const spinner = overlay.querySelector('.spinner-border'); const uploadBtn = overlay.querySelector('.upload-btn'); const removeBtn = overlay.querySelector('.remove-btn'); const successIcon = overlay.querySelector('.upload-success'); const errorDiv = overlay.querySelector('.upload-error');
    spinner.style.display = 'block'; errorDiv.style.display = 'none'; if(uploadBtn) uploadBtn.style.display = 'none'; if(removeBtn) removeBtn.style.display = 'none';
    const formData = new FormData(); formData.append('file', file);
    try {
      const response = await fetch(`\${getContextPath()}/api/image`, { method: 'POST', headers: { 'Authorization': `Bearer \${currentAuthToken}` }, body: formData });
      spinner.style.display = 'none';
      if (!response.ok) {
        const errorData = await response.json().catch(() => ({ message: `Error \${response.status}` })); throw new Error(errorData.message || `Error \${response.status}`);
      }
      const newUuid = await response.text();
      uploadedImageUUIDs.push(newUuid); selectedFilesMap.delete(previewId);
      previewContainer.dataset.id = newUuid; successIcon.style.display = 'block';
      overlay.innerHTML = `<button type="button" class="btn btn-danger btn-sm remove-btn" title="Eliminar asociación"><i class="bi bi-x-lg"></i></button>`;
    } catch (error) {
      console.error("Error subiendo imagen:", error); spinner.style.display = 'none'; errorDiv.textContent = error.message.substring(0, 50); errorDiv.style.display = 'block';
      if(uploadBtn) uploadBtn.style.display = 'inline-block'; if(removeBtn) removeBtn.style.display = 'inline-block';
    }
  }

  // --- Funciones CRUD API ---
  async function loadProducts(page = 0, size = DEFAULT_PAGE_SIZE) {
    productGrid.innerHTML = '<div class="loading-indicator">Cargando productos...</div>'; paginationControls.innerHTML = '';
    const url = `\${getContextPath()}/api/product?page=\${page}&size=\${size}`;
    try {
      const response = await fetch(url);
      if (!response.ok) { throw new Error(`Error \${response.status}: No se pudieron cargar los productos.`); }
      const pageInfo = await response.json();
      renderProducts(pageInfo.elements); renderPagination(pageInfo.actualPage, pageInfo.totalPages);
    } catch (error) {
      console.error('Error cargando productos:', error);
      productGrid.innerHTML = `<div class="col-12"><p class="text-center text-danger">Error al cargar productos: \${error.message}</p></div>`;
      showMessage(alertMessageDiv, error.message, false);
    }
  }
  function renderProducts(products) {
    productGrid.innerHTML = ''; if (!products || products.length === 0) { productGrid.innerHTML = '<div class="col-12"><p class="text-center">No hay productos para mostrar.</p></div>'; return; }
    products.forEach(product => {
      const firstImageId = (product.imageIds && product.imageIds.length > 0) ? product.imageIds[0] : null;
      const imageUrl = getImageUrl(firstImageId);
      const cardCol = document.createElement('div'); cardCol.className = 'col-sm-6 col-md-4 col-lg-3';
      let adminButtons = '';
      if (currentUserIsAdmin) { adminButtons = `<div class="admin-controls"><button class="btn btn-sm btn-warning" title="Editar" onclick="openProductModal(\${product.id})"><i class="bi bi-pencil-square"></i> Editar</button> <button class="btn btn-sm btn-danger" title="Eliminar" onclick="deleteProduct(\${product.id})"><i class="bi bi-trash3"></i> Eliminar</button></div>`; }
      cardCol.innerHTML = `<div class="card product-card shadow-sm"><img src="\${imageUrl}" class="card-img-top" alt="\${product.name || 'Producto'}" onerror="this.onerror=null; this.src='https://placehold.co/600x400/eee/ccc?text=Image+Error';"><div class="card-body"><h5 class="card-title">\${product.name || 'Sin nombre'}</h5><p class="card-text text-muted small">\${(product.description || '').substring(0, 80)}\${ (product.description || '').length > 80 ? '...' : ''}</p><p class="card-price">$\${product.price != null ? parseFloat(product.price).toFixed(2) : 'N/A'}</p>\${adminButtons}</div></div>`;
      productGrid.appendChild(cardCol);
    });
  }
  function renderPagination(currentPage, totalPages) {
    paginationControls.innerHTML = ''; if (totalPages <= 1) return;
    const createPageItem = (content, pageNum, isDisabled = false, isActive = false) => { const li = document.createElement('li'); li.className = `page-item \${isDisabled ? 'disabled' : ''} \${isActive ? 'active' : ''}`; li.innerHTML = `<a class="page-link" href="#" onclick="\${(pageNum !== null && !isDisabled) ? `loadProducts(\${pageNum})` : 'event.preventDefault()'}">\${content}</a>`; return li; };
    paginationControls.appendChild(createPageItem('&laquo;', currentPage - 1, currentPage === 0));
    let startPage = Math.max(0, currentPage - 2);let endPage = Math.min(totalPages - 1, currentPage + 2); if (currentPage < 2) { endPage = Math.min(totalPages - 1, 4); } if (currentPage > totalPages - 3) { startPage = Math.max(0, totalPages - 5); }
    if (startPage > 0) { paginationControls.appendChild(createPageItem('1', 0)); if (startPage > 1) { paginationControls.appendChild(createPageItem('...', null, true)); } }
    for (let i = startPage; i <= endPage; i++) { paginationControls.appendChild(createPageItem(i + 1, i, false, i === currentPage)); }
    if (endPage < totalPages - 1) { if (endPage < totalPages - 2) { paginationControls.appendChild(createPageItem('...', null, true)); } paginationControls.appendChild(createPageItem(totalPages, totalPages - 1)); }
    paginationControls.appendChild(createPageItem('&raquo;', currentPage + 1, currentPage >= totalPages - 1));
  }

  function openProductModal(productId) {
    if (!currentUserIsAdmin) return;
    clearFormErrors(); productForm.reset(); productIdInput.value = ''; uploadedImageUUIDs = []; selectedFilesMap.clear(); imagePreviewArea.innerHTML = '<p class="text-muted small w-100 text-center">No hay imágenes seleccionadas.</p>';
    if (productId) {
      productModalLabel.textContent = 'Editar Producto';
      fetch(`\${getContextPath()}/api/product/\${productId}`, { headers: { 'Authorization': `Bearer \${currentAuthToken}` } })
              .then(response => {
                if (!response.ok) { if (response.status === 401 || response.status === 403) { logout(); } throw new Error(`Error \${response.status} al cargar producto \${productId}`); }
                return response.json();
              })
              .then(product => {
                productIdInput.value = product.id; productNameInput.value = product.name; productDescriptionInput.value = product.description; productPriceInput.value = product.price;
                uploadedImageUUIDs = product.imageIds || []; renderPreviews(); productModal.show();
              })
              .catch(error => { console.error(error); showMessage(alertMessageDiv, error.message, false); });
    } else { productModalLabel.textContent = 'Nuevo Producto'; }
  }

  async function saveProduct() {
    if (!currentUserIsAdmin || !currentAuthToken) return; clearFormErrors();
    if (!productForm.checkValidity()) { productForm.classList.add('was-validated'); return; } productForm.classList.remove('was-validated');
    if (selectedFilesMap.size > 0) { showMessage(modalErrorMessageDiv, "Hay imágenes seleccionadas que no se han subido. Súbelas o elimínalas antes de guardar.", false); return; }
    if (uploadedImageUUIDs.length === 0) { imagePreviewArea.style.borderColor = 'var(--bs-danger)'; imageUploadErrorDiv.textContent = 'Debes subir y asociar al menos una imagen.'; showMessage(modalErrorMessageDiv, "El producto debe tener al menos una imagen asociada.", false); setTimeout(() => { imagePreviewArea.style.borderColor = '#ccc'; imageUploadErrorDiv.textContent = ''; }, 3000); return; }
    const productId = productIdInput.value; const isUpdating = !!productId;
    let requestBody; let url = `\${getContextPath()}/api/product`; let method;
    if (isUpdating) { method = 'PUT'; requestBody = { id: parseInt(productId), name: productNameInput.value.trim(), description: productDescriptionInput.value.trim(), price: parseFloat(productPriceInput.value), imageIds: uploadedImageUUIDs }; }
    else { method = 'POST'; requestBody = { name: productNameInput.value.trim(), description: productDescriptionInput.value.trim(), price: parseFloat(productPriceInput.value), imageIds: uploadedImageUUIDs }; }
    try {
      const response = await fetch(url, { method: method, headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer \${currentAuthToken}` }, body: JSON.stringify(requestBody) });
      const responseBody = await response.json().catch(() => null);
      if (!response.ok) {
        if (response.status === 401 || response.status === 403) { logout(); return; }
        let errorMessage = `Error al \${isUpdating ? 'actualizar' : 'crear'} el producto.`;
        if (responseBody && responseBody.message) { errorMessage = responseBody.message; }
        if (responseBody && responseBody.errors && typeof responseBody.errors === 'object') {
          errorMessage = "Error de validación.";
          for (const field in responseBody.errors) {
            let fieldId = field; if (field === 'name') fieldId = 'productName'; if (field === 'description') fieldId = 'productDescription'; if (field === 'price') fieldId = 'productPrice';
            if (field === 'imageIds') { showMessage(modalErrorMessageDiv, responseBody.errors[field], false); continue; }
            showFormError(fieldId, responseBody.errors[field]);
          }
        }
        showMessage(modalErrorMessageDiv, errorMessage, false); return;
      }
      productModal.hide(); loadProducts();
      showMessage(alertMessageDiv, `Producto \${isUpdating ? 'actualizado' : 'creado'} correctamente.`, true);
    } catch (error) {
      console.error('Error guardando producto:', error);
      showMessage(modalErrorMessageDiv, `Error inesperado: \${error.message}`, false);
    }
  }

  async function deleteProduct(productId) {
    if (!currentUserIsAdmin || !currentAuthToken) return;
    if (confirm(`¿Estás seguro de que quieres eliminar el producto con ID \${productId}?\n¡Esta acción no se puede deshacer!`)) {
      try {
        const response = await fetch(`\${getContextPath()}/api/product/\${productId}`, { method: 'DELETE', headers: { 'Authorization': `Bearer \${currentAuthToken}` } });
        if (!response.ok) {
          if (response.status === 401 || response.status === 403) { logout(); return; }
          const errorText = await response.text().catch(()=> `Error \${response.status}`); throw new Error(`No se pudo eliminar el producto: \${errorText}`);
        }
        loadProducts(); showMessage(alertMessageDiv, 'Producto eliminado correctamente.', true);
      } catch (error) {
        console.error('Error eliminando producto:', error);
        showMessage(alertMessageDiv, error.message, false);
      }
    }
  }

  // --- Inicialización y Event Listeners ---
  document.addEventListener('DOMContentLoaded', () => { setupUIBasedOnAuth(); loadProducts(); });
  imageUploadInput.addEventListener('change', handleFileSelection);
  imagePreviewArea.addEventListener('click', handlePreviewAreaClick);
  productModalElement.addEventListener('hidden.bs.modal', function (event) { clearFormErrors(); productForm.classList.remove('was-validated'); uploadedImageUUIDs = []; selectedFilesMap.clear(); imagePreviewArea.innerHTML = '<p class="text-muted small w-100 text-center">No hay imágenes seleccionadas.</p>'; });

</script>

</body>
</html>
