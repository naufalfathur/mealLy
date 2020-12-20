"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const getProjectNumber = require("../../getProjectNumber");
const loadCJSON = require("../../loadCJSON");
const functions_1 = require("./functions");
const functions_2 = require("./functions");
module.exports = async function (context, options) {
    if (!context) {
        return;
    }
    const filePath = options.config.get("remoteconfig.template");
    if (!filePath) {
        return;
    }
    const template = loadCJSON(filePath);
    const projectNumber = await getProjectNumber(options);
    template.etag = await functions_1.getEtag(projectNumber);
    functions_2.validateInputRemoteConfigTemplate(template);
    context.remoteconfigTemplate = template;
    return;
};
