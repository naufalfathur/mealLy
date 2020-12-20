"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.fetchWebSetup = exports.getCachedWebSetup = void 0;
const api = require("./api");
const getProjectId = require("./getProjectId");
const configstore_1 = require("./configstore");
const CONFIGSTORE_KEY = "webconfig";
function setCachedWebSetup(projectId, config) {
    const allConfigs = configstore_1.configstore.get(CONFIGSTORE_KEY) || {};
    allConfigs[projectId] = config;
    configstore_1.configstore.set(CONFIGSTORE_KEY, allConfigs);
}
function getCachedWebSetup(options) {
    const projectId = getProjectId(options, false);
    const allConfigs = configstore_1.configstore.get(CONFIGSTORE_KEY) || {};
    return allConfigs[projectId];
}
exports.getCachedWebSetup = getCachedWebSetup;
async function fetchWebSetup(options) {
    const projectId = getProjectId(options, false);
    const response = await api.request("GET", `/v1beta1/projects/${projectId}/webApps/-/config`, {
        auth: true,
        origin: api.firebaseApiOrigin,
    });
    const config = response.body;
    setCachedWebSetup(config.projectId, config);
    return config;
}
exports.fetchWebSetup = fetchWebSetup;
