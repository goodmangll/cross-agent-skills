import { readFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const extensionDir = dirname(fileURLToPath(import.meta.url));
const packageRoot = resolve(extensionDir, "../..");
const skillsDir = resolve(packageRoot, "skills");

export default function crossAgentSkillsPiAdapter(pi: ExtensionAPI) {
  // Register skill directory for discovery
  pi.on("resources_discover", async () => ({
    skillPaths: [skillsDir]
  }));

  // Tool mapping for Pi platform
  const toolMapping = {
    // Abstract tool -> Pi tool
    read: "read",
    write: "write",
    edit: "edit",
    execute: "bash",
    search: "grep",
    find: "find",
    list: "ls"
  };

  // Map abstract tool name to Pi tool name
  function mapToolName(abstractTool: string): string {
    return toolMapping[abstractTool] || abstractTool;
  }

  // Inject cross-platform usage guidance
  pi.on("context", async (event) => {
    // This is where you could add platform-specific context
    // For example, mapping abstract tool names to Pi tools
    
    // For now, we just log that the adapter is loaded
    // In a real implementation, you might want to:
    // 1. Add tool mapping guidance to the system prompt
    // 2. Inject platform-specific examples
    // 3. Handle missing tools gracefully
  });

  // Log successful loading
  console.log(`✓ Cross-agent skills adapter loaded`);
  console.log(`  Skills directory: ${skillsDir}`);
  console.log(`  Tool mapping: ${Object.keys(toolMapping).join(', ')}`);
}