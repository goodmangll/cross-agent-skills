import { readFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const extensionDir = dirname(fileURLToPath(import.meta.url));
const packageRoot = resolve(extensionDir, "../..");
const skillsDir = resolve(packageRoot, "skills");

export default function crossAgentSkillsAdapter(pi: ExtensionAPI) {
  // Register skill directory for discovery
  pi.on("resources_discover", async () => ({
    skillPaths: [skillsDir]
  }));

  // Optional: Inject bootstrap guidance
  pi.on("session_start", async () => {
    // Could inject cross-platform usage guidance here
  });

  // Map abstract tool names to Pi tools
  const toolMapping = {
    read: "read",
    write: "write",
    edit: "edit",
    execute: "bash",
    search: "grep",
    find: "find",
    list: "ls"
  };

  // Example: Tool mapping helper
  function mapToolName(abstractTool: string): string {
    return toolMapping[abstractTool] || abstractTool;
  }

  // Example: Cross-platform context injection
  pi.on("context", async (event) => {
    // Could add platform-specific context here
    // For example, mapping abstract tool names to Pi tools
  });

  console.log(`Cross-agent skills adapter loaded from ${skillsDir}`);
}