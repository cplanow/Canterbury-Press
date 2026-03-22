# Recommended Tool Stack for Canterbury Press

**Date:** March 2026
**Printer:** Bambu Lab P1S
**CAD Tools:** OpenSCAD + FreeCAD
**Primary Use:** Functional mechanical parts (electronics enclosures, mounts, brackets)

---

## Implementation Tiers

### Tier 1 — Use Now (Zero to Minimal Setup)

These tools provide immediate value with little or no configuration.

#### Claude / ChatGPT Generating OpenSCAD Code

| Attribute | Detail |
|-----------|--------|
| **What** | Prompt an LLM to write `.scad` code using our `lib/` shared modules |
| **Setup** | None — already available in any Claude or ChatGPT session |
| **Cost** | Included in existing LLM subscription |
| **How to use** | Provide the contents of `lib/printer-profile.scad` and relevant lib modules as context. Describe the part you need. The LLM generates parametric OpenSCAD code that references our tolerances and utilities. |
| **Strengths** | Fully parametric output, exact dimensions, uses our existing library |
| **Limitations** | LLM spatial reasoning is imperfect; complex parts may need manual refinement |
| **Reference** | [3D Printer Academy: AI CAD with OpenSCAD and Claude](https://3dprinteracademy.com/blogs/news-1/ai-cad-design-with-openscad-and-anthropic-s-claude-3-5-sonnet) |

#### OpenSCAD MCP Server

| Attribute | Detail |
|-----------|--------|
| **What** | MCP protocol integration that lets Claude drive OpenSCAD directly — send code, render preview, iterate |
| **Setup** | `brew install --cask openscad` + configure MCP server in Claude Code settings |
| **Cost** | Free (open source) |
| **Best implementations** | [jkoets/OpenSCAD-MCP](https://github.com/jkoets/OpenSCAD-MCP), [jhacksman](https://playbooks.com/mcp/jhacksman-openscad), [quellant](https://github.com/quellant/openscad-mcp), [petrijr](https://github.com/petrijr/openscad-mcp) |
| **Strengths** | Tighter feedback loop than copy-paste; live rendering; conversational iteration |
| **Limitations** | Requires initial MCP configuration |
| **Reference** | [OpenSCAD MCP Server Guide](https://skywork.ai/skypage/en/ai-engineer-openscad-mcp-server/1980872653259997184) |

#### Obico (Self-Hosted Print Monitoring)

| Attribute | Detail |
|-----------|--------|
| **What** | AI-powered print failure detection — spaghetti, warping, bed adhesion, layer shift |
| **Setup** | Docker container or Raspberry Pi; connect to P1S via native Bambu integration |
| **Cost** | Free (all Pro features when self-hosted) |
| **GitHub** | [TheSpaghettiDetective/obico-server](https://github.com/TheSpaghettiDetective/obico-server) |
| **P1S integration paths** | Native Obico Bambu, [OctoPrint bridge](https://github.com/bdwilson/obico-bambu-octoprint), [Home Assistant](https://github.com/nberktumer/ha-bambu-lab-p1-spaghetti-detection) |
| **Track record** | 89.8M+ hours monitored, 1M+ failures detected |
| **Strengths** | Production-ready, massive community, complements P1S built-in detection |
| **Reference** | [Obico for Bambu Lab](https://www.obico.io/blog/ai-failure-detection-remote-control-bambu-lab-3d-printers/) |

---

### Tier 2 — High Value, Some Setup Required

These tools require more configuration but provide significant capability upgrades.

#### Zoo.dev Text-to-CAD

| Attribute | Detail |
|-----------|--------|
| **What** | Generates **STEP files** (true parametric B-Rep geometry, not meshes) from text descriptions |
| **Setup** | API account at [zoo.dev](https://zoo.dev/text-to-cad) |
| **Cost** | $0.50/min usage time |
| **Output** | STEP + GLTF — importable into FreeCAD with full parametric editing |
| **Strengths** | Best text-to-CAD for engineering parts. B-Rep output is a class above mesh generation. KCL language designed for engineers. Open-source tooling on GitHub. |
| **Limitations** | Accuracy drops for complex multi-feature designs. Paid service. |
| **Best for** | Parts that need FreeCAD/Fusion import; when STEP format is preferred over OpenSCAD |
| **Reference** | [Zoo.dev Tutorial](https://zoo.dev/docs/developer-tools/tutorials/text-to-cad) |

#### Slicer Copilot

| Attribute | Detail |
|-----------|--------|
| **What** | Open-source LLM that reads Bambu Studio `.3mf` files and suggests print setting optimizations |
| **Setup** | Node.js 20+, OpenAI-compatible API key |
| **Cost** | Free (open source); you pay for your own LLM API usage |
| **GitHub** | [pfrankov/slicer-copilot](https://github.com/pfrankov/slicer-copilot) |
| **Optimization targets** | Strength, Speed, Visual Quality, or custom goals |
| **Strengths** | Works directly with Bambu Studio workflow; explains every change; never modifies geometry |
| **Reference** | [GitHub README](https://github.com/pfrankov/slicer-copilot) |

#### FreeCAD MCP Server

| Attribute | Detail |
|-----------|--------|
| **What** | Claude drives FreeCAD's visual CAD environment via MCP protocol |
| **Setup** | FreeCAD addon + MCP configuration |
| **Cost** | Free (open source) |
| **GitHub** | [neka-nat/freecad-mcp](https://github.com/neka-nat/freecad-mcp) (343+ stars) |
| **Strengths** | Visual parametric CAD with AI assistance; good for users who prefer GUI-based design |
| **Limitations** | LLMs struggle with highly constrained models; multiple refinement rounds often needed |
| **Reference** | [FreeCAD MCP Deep Dive](https://skywork.ai/skypage/en/ai-cad-freecad-mcp/1980468264448598016) |

#### PromptSCAD

| Attribute | Detail |
|-----------|--------|
| **What** | Free browser-based tool — type a description, get OpenSCAD code, preview in-browser via WASM |
| **Setup** | None — runs in browser |
| **Cost** | Free |
| **Website** | [promptscad.com](https://promptscad.com/) |
| **Strengths** | Zero friction; good for quick experiments and concept validation |
| **Limitations** | Uses DeepSeek v3; may be less capable than Claude/GPT-4o for complex parts |

---

### Tier 3 — Future / Experimental Projects

These require significant development effort but offer unique capabilities.

#### LLM-3D Print (CMU) — P1S Adaptation

| Attribute | Detail |
|-----------|--------|
| **What** | Fork the CMU framework to run autonomous print error detection and correction on the P1S |
| **Effort** | 2-4 weeks development |
| **Key work** | Replace Moonraker API with Bambu MQTT; adapt camera capture; implement layer detection |
| **GitHub** | [BaratiLab/LLM-3D-Print](https://github.com/BaratiLab/LLM-3D-Print-Large-Language-Models-To-Monitor-and-Control-3D-Printing) |
| **Python libraries needed** | [bambulabs-api](https://pypi.org/project/bambulabs-api/), [OpenBambuAPI docs](https://github.com/Doridian/OpenBambuAPI) |
| **Prerequisites** | P1S in LAN Only Mode; Python 3.12+; OpenAI API key; camera setup |
| **Strengths** | Only system that autonomously corrects print parameters in real-time |
| **See** | [Detailed report](llm-3d-print.md) |

#### Hitem3D / Meshy / Tripo AI — Decorative Elements

| Attribute | Detail |
|-----------|--------|
| **What** | AI-generated organic/artistic 3D meshes from images or text |
| **When to use** | When you need a figurine, decorative knob, sculpted cover, or artistic element |
| **How to integrate** | Generate mesh → export STL → import into OpenSCAD with `import()` or combine in Blender |
| **Limitations** | No dimensional precision; must manually scale; high-polygon meshes may need decimation |
| **See** | [Detailed Hitem3D report](hitem3d.md), [Landscape overview](ai-3d-printing-landscape.md) |

---

## Quick Decision Matrix

| I need to... | Use this |
|---|---|
| Design a functional part (enclosure, mount, bracket) | Claude + OpenSCAD (or MCP server) |
| Get a STEP file for FreeCAD import | Zoo.dev Text-to-CAD |
| Quick visual prototype of a concept | PromptSCAD (browser) |
| Design in FreeCAD with AI help | FreeCAD MCP server |
| Optimize my Bambu Studio print settings | Slicer Copilot |
| Detect and stop failed prints | Obico (self-hosted) |
| Troubleshoot a print issue | Ask Claude/ChatGPT with your settings |
| Create a decorative/artistic 3D model | Meshy, Tripo AI, or Hitem3D |
| Autonomous real-time print correction | LLM-3D Print (requires development) |

---

## Implementation Roadmap

```
Now          → Set up OpenSCAD MCP server for AI-assisted design
             → Install Obico for print failure detection

Next         → Try Zoo.dev for STEP output when needed
             → Set up Slicer Copilot for settings optimization
             → Evaluate FreeCAD MCP server

Later        → Fork and adapt LLM-3D Print for P1S
             → Explore decorative model generation as needed
```
