import { previewFile, importFile, dimportFile, resetEntorno, getStatus } from "./api.js";
import { VALIDATORS, parseContent, getExtension } from "./validator.js";

const LABELS = {
    user: "Usuarios",
    group: "Grupos",
    dir: "Directorios",
    permission: "Permisos",
    service: "Servicios"
};

const ICONS = {
    user: "ti-user",
    group: "ti-users",
    dir: "ti-folder",
    permission: "ti-lock",
    service: "ti-server"
};

const state = {
    user: null, group: null, dir: null, permission: null, service: null
};

function setSlotLoading(type) {
    const slot = document.getElementById(`slot-${type}`);
    slot.classList.remove("loaded", "error");
    slot.classList.add("loading");
    document.getElementById(`sub-${type}`).textContent = "Analizando...";
}

function setSlotOk(type, filename, count) {
    const slot = document.getElementById(`slot-${type}`);
    slot.classList.remove("loading", "error");
    slot.classList.add("loaded");
    document.getElementById(`sub-${type}`).textContent = filename;
    setBadge(type, `${count} ${count === 1 ? "elemento" : "elementos"}`, false);
}

function setSlotError(type, filename, msg) {
    const slot = document.getElementById(`slot-${type}`);
    slot.classList.remove("loading", "loaded");
    slot.classList.add("error");
    document.getElementById(`sub-${type}`).textContent = `Formato incorrecto: ${msg}`;
    setBadge(type, "error", true);
}

function setBadge(type, text, isErr) {
    const slot = document.getElementById(`slot-${type}`);
    let badge = slot.querySelector(".slot-badge");
    if (!badge) {
        badge = document.createElement("span");
        badge.className = "slot-badge";
        slot.appendChild(badge);
    }
    badge.textContent = text;
    badge.className = `slot-badge${isErr ? " err" : ""}`;
}

async function handleFile(event, type) {
    const file = event.target.files[0];
    if (!file) return;

    const ext = getExtension(file.name);
    const allowed = ["csv", "json", "xml"];
    if (!allowed.includes(ext)) {
        setSlotError(type, file.name, "extensión no permitida");
        state[type] = { file, items: null, error: "extensión no permitida" };
        renderPreview();
        return;
    }

    setSlotLoading(type);

    try {
        const content = await file.text();
        const parsed = parseContent(content, ext);
        const validationError = VALIDATORS[type](parsed);

        if (validationError) {
            setSlotError(type, file.name, validationError);
            state[type] = { file, items: null, error: validationError };
            renderPreview();
            return;
        }

        const preview = await previewFile(file, type);
        setSlotOk(type, file.name, parsed.length);
        state[type] = { file, items: parsed, preview: preview.data, error: null };
    } catch (e) {
        setSlotError(type, file.name, e.message);
        state[type] = { file, items: null, error: e.message };
    }

    renderPreview();
}

function renderPreview() {
    const container = document.getElementById("preview-content");
    const valid = Object.keys(state).filter(k => state[k] && !state[k].error);
    const errors = Object.keys(state).filter(k => state[k] && state[k].error);

    if (!valid.length && !errors.length) {
        container.innerHTML = `<div class="empty-state"><i class="ti ti-file-search" aria-hidden="true"></i>Sube un archivo para ver la vista previa</div>`;
        document.getElementById("total-count").textContent = "0 elementos";
        document.getElementById("apply-btn").disabled = true;
        return;
    }

    let total = 0;
    let html = "";

    for (const type of valid) {
        const { items } = state[type];
        total += items.length;
        const rendered = items.slice(0, 4).map(item => {
            const label = typeof item === "string" ? item : Object.values(item).join(" → ");
            return `<div class="preview-item"><span class="tag">${type}</span>${label}</div>`;
        }).join("");
        const more = items.length > 4
            ? `<div class="preview-more">+${items.length - 4} más</div>`
            : "";
        html += `
            <div class="preview-section">
                <div class="preview-section-title">
                    <i class="ti ${ICONS[type]}" aria-hidden="true"></i>${LABELS[type]}
                </div>
                <div class="preview-items">${rendered}${more}</div>
            </div>`;
    }

    if (errors.length) {
        const errHtml = errors.map(type => `
            <div class="preview-item error-item">
                <i class="ti ti-alert-circle" aria-hidden="true"></i>
                <span>${LABELS[type]}: ${state[type].error}</span>
            </div>`).join("");
        html += `
            <div class="preview-section">
                <div class="preview-section-title error-title">
                    <i class="ti ti-alert-circle" aria-hidden="true"></i>Errores de formato
                </div>
                <div class="preview-items">${errHtml}</div>
            </div>`;
    }

    container.innerHTML = html;
    document.getElementById("total-count").textContent = `${total} ${total === 1 ? "elemento" : "elementos"}`;
    document.getElementById("apply-btn").disabled = valid.length === 0;
}

async function handleApply() {
    const valid = Object.keys(state).filter(k => state[k] && !state[k].error);
    if (!valid.length) return;

    const confirmed = confirm(`¿Aplicar los cambios? Se crearán ${valid.map(k => LABELS[k]).join(", ")}.`);
    if (!confirmed) return;

    setActionsDisabled(true);
    const log = document.getElementById("action-log");
    log.innerHTML = "";
    log.style.display = "flex";

    for (const type of valid) {
        const { file } = state[type];
        logLine(log, `Importando ${LABELS[type]}...`, "info");
        try {
            await importFile(file, type);
            logLine(log, `${LABELS[type]} importados correctamente.`, "success");
        } catch (e) {
            logLine(log, `Error en ${LABELS[type]}: ${e.message}`, "error");
        }
    }

    logLine(log, "Proceso completado.", "info");
    setActionsDisabled(false);
    await refreshStatus();
}

async function handleReset() {
    const confirmed = confirm("¿Eliminar TODO lo creado en el entorno? Esta acción no se puede deshacer.");
    if (!confirmed) return;

    setActionsDisabled(true);
    const log = document.getElementById("action-log");
    log.innerHTML = "";
    log.style.display = "flex";

    try {
        logLine(log, "Ejecutando reset...", "info");
        await resetEntorno();
        logLine(log, "Entorno reseteado correctamente.", "success");
        clearAll();
    } catch (e) {
        logLine(log, `Error: ${e.message}`, "error");
    }

    setActionsDisabled(false);
    await refreshStatus();
}

function logLine(container, text, type) {
    const el = document.createElement("div");
    el.className = `log-line log-${type}`;
    el.textContent = text;
    container.appendChild(el);
}

function setActionsDisabled(disabled) {
    document.getElementById("apply-btn").disabled = disabled;
    document.getElementById("reset-btn").disabled = disabled;
    document.getElementById("clear-btn").disabled = disabled;
}

async function refreshStatus() {
    try {
        const { data } = await getStatus();
        const counts = [
            data.usuarios.length,
            data.grupos.length,
            data.directorios.length,
            data.servicios.length,
            data.permisos.length
        ].reduce((a, b) => a + b, 0);
        document.getElementById("status-count").textContent = `${counts} elementos en el sistema`;
    } catch {
        document.getElementById("status-count").textContent = "Sin conexión";
    }
}

function clearAll() {
    Object.keys(state).forEach(k => {
        state[k] = null;
        const slot = document.getElementById(`slot-${k}`);
        slot.classList.remove("loaded", "error", "loading");
        document.getElementById(`sub-${k}`).textContent = "CSV, JSON o XML";
        const badge = slot.querySelector(".slot-badge");
        if (badge) badge.remove();
        slot.querySelector("input[type=file]").value = "";
    });
    document.getElementById("action-log").style.display = "none";
    renderPreview();
}

document.addEventListener("DOMContentLoaded", () => {
    document.getElementById("apply-btn").addEventListener("click", handleApply);
    document.getElementById("reset-btn").addEventListener("click", handleReset);
    document.getElementById("clear-btn").addEventListener("click", clearAll);

    Object.keys(state).forEach(type => {
        document.getElementById(`input-${type}`)
            .addEventListener("change", e => handleFile(e, type));
    });

    refreshStatus();
});
