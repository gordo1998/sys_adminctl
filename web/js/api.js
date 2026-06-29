const API_BASE = "/api";

async function apiFetch(endpoint, options = {}) {
    let response;
    try {
        response = await fetch(`${API_BASE}${endpoint}`, options);
    } catch {
        throw new Error("No se puede conectar con el servidor");
    }

    const contentType = response.headers.get("content-type") || "";
    if (!contentType.includes("application/json")) {
        throw new Error(`El servidor no está disponible (HTTP ${response.status})`);
    }

    const data = await response.json();
    if (!response.ok) {
        throw new Error(data.error?.message || `HTTP ${response.status}`);
    }
    return data;
}

export async function previewFile(file, type) {
    const form = new FormData();
    form.append("file", file);
    form.append("type", type);
    return apiFetch("/preview", { method: "POST", body: form });
}

export async function importFile(file, type) {
    const form = new FormData();
    form.append("file", file);
    form.append("type", type);
    return apiFetch("/import", { method: "POST", body: form });
}

export async function dimportFile(file, type) {
    const form = new FormData();
    form.append("file", file);
    form.append("type", type);
    return apiFetch("/dimport", { method: "POST", body: form });
}

export async function resetEntorno() {
    return apiFetch("/reset", { method: "POST" });
}

export async function getStatus() {
    return apiFetch("/status");
}
