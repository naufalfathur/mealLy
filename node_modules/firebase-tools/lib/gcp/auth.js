"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateAuthDomains = exports.getAuthDomains = void 0;
const api = require("../api");
async function getAuthDomains(project) {
    var _a;
    const res = await api.request("GET", `/admin/v2/projects/${project}/config`, {
        auth: true,
        origin: api.identityOrigin,
    });
    return (_a = res === null || res === void 0 ? void 0 : res.body) === null || _a === void 0 ? void 0 : _a.authorizedDomains;
}
exports.getAuthDomains = getAuthDomains;
async function updateAuthDomains(project, authDomains) {
    var _a;
    const resp = await api.request("PATCH", `/admin/v2/projects/${project}/config?update_mask=authorizedDomains`, {
        auth: true,
        origin: api.identityOrigin,
        data: {
            authorizedDomains: authDomains,
        },
    });
    return (_a = resp === null || resp === void 0 ? void 0 : resp.body) === null || _a === void 0 ? void 0 : _a.authorizedDomains;
}
exports.updateAuthDomains = updateAuthDomains;
