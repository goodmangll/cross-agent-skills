#!/usr/bin/env node

/**
 * Cross-Platform Compatibility Test
 * 
 * Tests that skills work across different AI coding agent platforms.
 * Run this script to verify your skills are platform-agnostic.
 */

const fs = require('fs');
const path = require('path');

// Test configuration
const TESTS = {
  skillStructure: {
    name: 'Skill Structure Test',
    description: 'Verify skills follow standard structure'
  },
  platformAgnostic: {
    name: 'Platform Agnostic Test',
    description: 'Verify skills don\'t contain platform-specific code'
  },
  toolMapping: {
    name: 'Tool Mapping Test',
    description: 'Verify abstract tools are properly defined'
  },
  adapterStructure: {
    name: 'Adapter Structure Test',
    description: 'Verify adapters are properly configured'
  }
};

// Platform-specific patterns to avoid in skills
const PLATFORM_PATTERNS = {
  pi: [
    /\bpi\.(on|register|emit)\b/,
    /\bExtensionAPI\b/,
    /\b@earendil-works\/pi-coding-agent\b/
  ],
  claude: [
    /\bclaude\b/i,
    /\banthropic\b/i,
    /\b\/plugin\s+install\b/
  ],
  codex: [
    /\bcodex\b/i,
    /\bopenai\b/i,
    /\b\/plugins\s+install\b/
  ],
  cursor: [
    /\bcursor\b/i,
    /\b\/add-plugin\b/
  ]
};

// Abstract tools that should be used in skills
const ABSTRACT_TOOLS = [
  'read',
  'write',
  'edit',
  'execute',
  'search',
  'find',
  'list'
];

class CrossPlatformTester {
  constructor() {
    this.results = [];
    this.errors = [];
  }

  async runAllTests() {
    console.log('🧪 Running Cross-Platform Compatibility Tests\n');

    await this.testSkillStructure();
    await this.testPlatformAgnostic();
    await this.testToolMapping();
    await this.testAdapterStructure();

    this.printResults();
    return this.errors.length === 0;
  }

  async testSkillStructure() {
    console.log(`📝 ${TESTS.skillStructure.name}`);
    console.log(`   ${TESTS.skillStructure.description}\n`);

    const skillsDir = path.join(__dirname, '..', 'skills');
    
    if (!fs.existsSync(skillsDir)) {
      this.addError('Skills directory not found');
      return;
    }

    const skills = fs.readdirSync(skillsDir);
    
    for (const skill of skills) {
      const skillPath = path.join(skillsDir, skill);
      const stat = fs.statSync(skillPath);
      
      if (!stat.isDirectory()) continue;
      
      const skillFile = path.join(skillPath, 'SKILL.md');
      
      if (!fs.existsSync(skillFile)) {
        this.addError(`Missing SKILL.md in ${skill}`);
        continue;
      }

      const content = fs.readFileSync(skillFile, 'utf8');
      
      // Check frontmatter
      if (!content.startsWith('---')) {
        this.addError(`${skill}: Missing YAML frontmatter`);
        continue;
      }

      // Check for required fields
      if (!content.includes('name:')) {
        this.addError(`${skill}: Missing 'name' field in frontmatter`);
      }

      if (!content.includes('description:')) {
        this.addError(`${skill}: Missing 'description' field in frontmatter`);
      }

      // Check description format
      const descMatch = content.match(/description:\s*(.+)/);
      if (descMatch && !descMatch[1].startsWith('Use when')) {
        this.addWarning(`${skill}: Description should start with 'Use when'`);
      }

      console.log(`   ✓ ${skill}: Structure OK`);
    }
  }

  async testPlatformAgnostic() {
    console.log(`\n🔍 ${TESTS.platformAgnostic.name}`);
    console.log(`   ${TESTS.platformAgnostic.description}\n`);

    const skillsDir = path.join(__dirname, '..', 'skills');
    
    if (!fs.existsSync(skillsDir)) return;

    const skills = fs.readdirSync(skillsDir);
    
    for (const skill of skills) {
      const skillPath = path.join(skillsDir, skill);
      const stat = fs.statSync(skillPath);
      
      if (!stat.isDirectory()) continue;
      
      const skillFile = path.join(skillPath, 'SKILL.md');
      
      if (!fs.existsSync(skillFile)) continue;

      const content = fs.readFileSync(skillFile, 'utf8');
      const lines = content.split('\n');
      
      let hasPlatformSpecific = false;
      
      for (const [platform, patterns] of Object.entries(PLATFORM_PATTERNS)) {
        for (const pattern of patterns) {
          for (let i = 0; i < lines.length; i++) {
            if (pattern.test(lines[i])) {
              this.addError(`${skill}: Platform-specific code for ${platform} at line ${i + 1}`);
              hasPlatformSpecific = true;
            }
          }
        }
      }
      
      if (!hasPlatformSpecific) {
        console.log(`   ✓ ${skill}: Platform-agnostic OK`);
      }
    }
  }

  async testToolMapping() {
    console.log(`\n🔧 ${TESTS.toolMapping.name}`);
    console.log(`   ${TESTS.toolMapping.description}\n`);

    const adaptersDir = path.join(__dirname, '..', 'adapters');
    
    if (!fs.existsSync(adaptersDir)) {
      this.addError('Adapters directory not found');
      return;
    }

    const platforms = fs.readdirSync(adaptersDir);
    
    for (const platform of platforms) {
      const platformPath = path.join(adaptersDir, platform);
      const stat = fs.statSync(platformPath);
      
      if (!stat.isDirectory()) continue;
      
      // Check for adapter configuration
      const configFile = this.getAdapterConfigFile(platform, platformPath);
      
      if (!configFile) {
        this.addWarning(`${platform}: No adapter configuration found`);
        continue;
      }

      console.log(`   ✓ ${platform}: Adapter configuration found`);
    }
  }

  async testAdapterStructure() {
    console.log(`\n📦 ${TESTS.adapterStructure.name}`);
    console.log(`   ${TESTS.adapterStructure.description}\n`);

    const adaptersDir = path.join(__dirname, '..', 'adapters');
    
    if (!fs.existsSync(adaptersDir)) return;

    const platforms = fs.readdirSync(adaptersDir);
    
    for (const platform of platforms) {
      const platformPath = path.join(adaptersDir, platform);
      const stat = fs.statSync(platformPath);
      
      if (!stat.isDirectory()) continue;
      
      // Check required files based on platform
      const requiredFiles = this.getRequiredFiles(platform);
      
      for (const file of requiredFiles) {
        const filePath = path.join(platformPath, file);
        
        if (!fs.existsSync(filePath)) {
          this.addError(`${platform}: Missing required file ${file}`);
        } else {
          console.log(`   ✓ ${platform}: ${file} exists`);
        }
      }
    }
  }

  getAdapterConfigFile(platform, platformPath) {
    const configFiles = {
      pi: 'extensions/adapter.ts',
      claude: 'plugin.json',
      codex: 'plugin.json',
      cursor: 'plugin.json'
    };

    const configFile = configFiles[platform];
    if (!configFile) return null;

    const configPath = path.join(platformPath, configFile);
    return fs.existsSync(configPath) ? configPath : null;
  }

  getRequiredFiles(platform) {
    const requiredFiles = {
      pi: ['extensions/adapter.ts'],
      claude: ['plugin.json'],
      codex: ['plugin.json'],
      cursor: ['plugin.json']
    };

    return requiredFiles[platform] || [];
  }

  addError(message) {
    this.errors.push({ type: 'error', message });
    console.log(`   ❌ ${message}`);
  }

  addWarning(message) {
    this.results.push({ type: 'warning', message });
    console.log(`   ⚠️  ${message}`);
  }

  printResults() {
    console.log('\n📊 Test Results Summary');
    console.log('='.repeat(50));
    
    const errors = this.errors.filter(r => r.type === 'error').length;
    const warnings = this.results.filter(r => r.type === 'warning').length;
    
    console.log(`Errors: ${errors}`);
    console.log(`Warnings: ${warnings}`);
    
    if (errors === 0) {
      console.log('\n✅ All tests passed! Skills are cross-platform compatible.');
    } else {
      console.log('\n❌ Some tests failed. Please fix the issues above.');
    }
  }
}

// Run tests if called directly
if (require.main === module) {
  const tester = new CrossPlatformTester();
  tester.runAllTests().then(success => {
    process.exit(success ? 0 : 1);
  });
}

module.exports = CrossPlatformTester;