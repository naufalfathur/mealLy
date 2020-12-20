"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const path = require("path");
const functionsEmulator_1 = require("../emulator/functionsEmulator");
const emulatorServer_1 = require("../emulator/emulatorServer");
const functionsEmulatorUtils_1 = require("../emulator/functionsEmulatorUtils");
const getProjectId = require("../getProjectId");
module.exports = {
    emulatorServer: undefined,
    async start(options, args) {
        const projectId = getProjectId(options, false);
        const functionsDir = path.join(options.config.projectDir, options.config.get("functions.source"));
        args = Object.assign({ projectId,
            functionsDir, nodeMajorVersion: functionsEmulatorUtils_1.parseRuntimeVersion(options.config.get("functions.runtime")) }, args);
        if (options.host) {
            args.host = options.host;
        }
        if (options.port) {
            const hostingRunning = options.targets && options.targets.indexOf("hosting") >= 0;
            if (hostingRunning) {
                args.port = options.port + 1;
            }
            else {
                args.port = options.port;
            }
        }
        this.emulatorServer = new emulatorServer_1.EmulatorServer(new functionsEmulator_1.FunctionsEmulator(args));
        await this.emulatorServer.start();
    },
    async connect() {
        await this.emulatorServer.connect();
    },
    async stop() {
        await this.emulatorServer.stop();
    },
    get() {
        return this.emulatorServer.get();
    },
};
