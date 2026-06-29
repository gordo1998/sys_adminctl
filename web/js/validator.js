export const VALIDATORS = {
    user: items => {
        if (!Array.isArray(items)) return "debe ser un array";
        const invalid = items.find(i => typeof i !== "object" || !i.user || !i.path);
        return invalid ? "cada elemento debe tener {user, path}" : null;
    },
    group: items => {
        if (!Array.isArray(items)) return "debe ser un array";
        const invalid = items.find(i => typeof i !== "string");
        return invalid ? "debe ser un array de strings" : null;
    },
    dir: items => {
        if (!Array.isArray(items)) return "debe ser un array";
        const invalid = items.find(i => typeof i !== "string");
        return invalid ? "debe ser un array de strings" : null;
    },
    permission: items => {
        if (!Array.isArray(items)) return "debe ser un array";
        const invalid = items.find(i => typeof i !== "object" || !i.dir || !i.permiso);
        return invalid ? "cada elemento debe tener {dir, permiso}" : null;
    },
    service: items => {
        if (!Array.isArray(items)) return "debe ser un array";
        const invalid = items.find(i => typeof i !== "string");
        return invalid ? "debe ser un array de strings" : null;
    }
};

export function parseContent(content, ext) {
    if (ext === "json") {
        return JSON.parse(content);
    }
    if (ext === "csv") {
        return content.split("\n").map(l => l.trim()).filter(Boolean);
    }
    if (ext === "xml") {
        const doc = new DOMParser().parseFromString(content, "text/xml");
        return Array.from(doc.querySelectorAll("*")).slice(1).map(n => {
            const attrs = Object.fromEntries(Array.from(n.attributes).map(a => [a.name, a.value]));
            return Object.keys(attrs).length ? attrs : n.textContent.trim();
        }).filter(Boolean);
    }
    throw new Error(`Extensión no soportada: ${ext}`);
}

export function getExtension(filename) {
    return filename.split(".").pop().toLowerCase();
}
