"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const functions_1 = require("./functions");
const getProjectNumber = require("../../getProjectNumber");
module.exports = async function (context, options) {
    if (!(context === null || context === void 0 ? void 0 : context.remoteconfigTemplate)) {
        return;
    }
    const template = context.remoteconfigTemplate;
    const projectNumber = await getProjectNumber(options);
    const etag = await functions_1.getEtag(projectNumber);
    return functions_1.publishTemplate(projectNumber, template, etag, options);
};
