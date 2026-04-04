# Recommended Tool Stack for Canterbury Press

**Date:** April 2026
**Printer:** Bambu Lab P1S
**CAD Tools:** OpenSCAD + FreeCAD + CadQuery
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
| **How to use** | Provide the contents of `lib/printer-profile.scad`, the FDM design rules from `docs/fdm-design-rules.md`, and relevant lib modules as context. Describe the part you need. The LLM generates parametric OpenSCAD code that references our tolerances and utilities. |
| **Strengths** | Fully parametric output, exact dimensions, uses our existing library |
| **Limitations** | LLM spatial reasoning is imperfect; complex parts may need manual refinement. Common failures: axis confusion, scale errors, floating geometry, thin walls. |
| **Reference** | [3D Printer Academy: AI CAD with OpenSCAD and Claude](https://3dprinteracademy.com/blogs/news-1/ai-cad-design-with-openscad-and-anthropic-s-claude-3-5-sonnet) |

#### OpenSCAD MCP Server

| Attribute | Detail |
|-----------|--------|
| **What** | MCP protocol integration that lets Claude drive OpenSCAD directly — send code, render preview, iterate |
| **Setup** | `brew install --cask openscad` + configure MCP server in Claude Code settings |
| **Cost** | Free (open source) |
| **Best implementations** | [jkoets/OpenSCAD-MCP](https://github.com/jkoets/OpenSCAD-MCP), [jhacksman/OpenSCAD-MCP-Server](https://github.com/jhacksman/OpenSCAD-MCP-Server), [quellant](https://github.com/quellant/openscad-mcp), [petrijr](https://github.com/petrijr/openscad-mcp) |
| **Strengths** | Tighter feedback loop than copy-paste; live rendering; conversational iteration |
| **Limitations** | Requires initial MCP configuration |
| **Reference** | [OpenSCAD MCP Server Guide](https://skywork.ai/skypage/en/ai-engineer-openscad-mcp-server/1980872653259997184) |

#### OpenSCAD Agent (Claude Code Skills)

| Attribute | Detail |
|-----------|--------|
| **What** | Claude Code-powered 3D modeling environment with three dedicated skills: `/openscad` (generate versioned SCAD files), `/preview-scad` (render to PNG for visual feedback), `/export-stl` (convert with geometry validation) |
| **Setup** | Clone repo, follow README for Claude Code skill setup |
| **Cost** | Free (open source) |
| **GitHub** | [iancanderson/openscad-agent](https://github.com/iancanderson/openscad-agent) |
| **Strengths** | Versioned iteration (model_001.scad, model_002.scad, ...), self-evaluation of renders, geometry validation before STL export. The closest thing to a "CAD copilot." |
| **Limitations** | Requires OpenSCAD installed locally |
| **Reference** | [AI 3D Printing Design Guide](ai-3d-printing-design-guide.md) |

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

#### Bambu Lab MCP Server

| Attribute | Detail |
|-----------|--------|
| **What** | MCP server with 25 tools for controlling the P1S via local MQTT — print control, monitoring, camera, AMS, temperature, file upload |
| **Setup** | Clone repo, `npm install`, configure with P1S IP, LAN access code, and serial number |
| **Cost** | Free (open source) |
| **GitHub** | [schwarztim/bambu-mcp](https://github.com/schwarztim/bambu-mcp) |
| **Tools** | Print: start/stop/pause/resume/speed/gcode. Monitor: real-time status, firmware. Camera: record/timelapse. AMS: filament change/unload. Hardware: nozzle/bed temp, LEDs. Files: FTP upload of .gcode/.3mf |
| **Safety** | Blocked dangerous G-codes, temperature limits (nozzle max 300°C, bed max 120°C), file type validation, path traversal prevention |
| **Prerequisites** | P1S with Developer Mode (recommended), LAN access code, same network or VPN |
| **Reference** | [AI 3D Printing Design Guide](ai-3d-printing-design-guide.md), [Bambu Lab Third-Party Integration Wiki](https://wiki.bambulab.com/en/software/third-party-integration) |

---

### Tier 2 — High Value, Some Setup Required

These tools require more configuration but provide significant capability upgrades.

#### CadQuery (Python-Based Parametric CAD)

| Attribute | Detail |
|-----------|--------|
| **What** | Python library built on Open CASCADE kernel (same as FreeCAD/Fusion 360). More powerful geometry than OpenSCAD — native fillets, chamfers, sweeps, STEP export. |
| **Setup** | `pip install cadquery` (or `conda install -c cadquery cadquery`) |
| **Cost** | Free (open source) |
| **GitHub** | [CadQuery/cadquery](https://github.com/CadQuery/cadquery) |
| **Output** | STL, STEP, IGES, AMF — STEP is the key advantage over OpenSCAD |
| **LLM generation** | Text-to-CadQuery fine-tuning achieves 69.3% exact match on 170K dataset. [CQAsk](https://github.com/OpenOrion/CQAsk) is an open-source LLM CadQuery tool. |
| **Strengths** | BREP geometry, Python native, fillets/chamfers, STEP export for FreeCAD/Fusion import |
| **Limitations** | Harder to install, less LLM training data than OpenSCAD, requires Python environment |
| **When to use** | When OpenSCAD's CSG-only geometry is insufficient — parts needing fillets, complex sweeps, or STEP output |
| **Reference** | [Text-to-CadQuery (arXiv)](https://arxiv.org/html/2505.06507v1), [AI 3D Printing Design Guide](ai-3d-printing-design-guide.md) |

#### Zoo.dev Text-to-CAD

| Attribute | Detail |
|-----------|--------|
| **What** | Generates **STEP files** (true parametric B-Rep geometry, not meshes) from text descriptions. ML-ephant model with Zookeeper conversational agent. |
| **Setup** | API account at [zoo.dev](https://zoo.dev/text-to-cad) |
| **Cost** | $0.50/min usage time |
| **Output** | STEP + GLTF — importable into FreeCAD with full parametric editing |
| **Strengths** | Best text-to-CAD for engineering parts. B-Rep output. KCL language designed for engineers. Open-source tooling on GitHub. |
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

#### PrintPal

| Attribute | Detail |
|-----------|--------|
| **What** | Text-to-STL and image-to-STL generation purpose-built for 3D printing. Generates in under 60 seconds. |
| **Setup** | Web-based at [printpal.io](https://printpal.io/3dgenerator) |
| **Cost** | Free tier available |
| **Output** | STL, OBJ, GLB |
| **Strengths** | Purpose-built for printing, fast, free. Explicitly compatible with Bambu Studio and OrcaSlicer. Has a dedicated text/nameplate tool. |
| **Limitations** | Less control over parametric dimensions. Better for artistic than mechanical parts. |
| **Best for** | Decorative prints, nameplates, signs, organic shapes |
| **Reference** | [PrintPal Blog: Top ChatGPT Prompts for 3D Models](https://blog.printpal.io/top-10-chatgpt-prompts-of-2026-for-generating-3d-models/) |

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

#### Full Text-to-Print Pipeline

| Attribute | Detail |
|-----------|--------|
| **What** | Combine OpenSCAD agent + Bambu MCP to create an end-to-end text → design → preview → STL → upload → print → monitor pipeline |
| **Current gap** | Slicing step is manual — no MCP server exists for OrcaSlicer/Bambu Studio yet. OrcaSlicer CLI (`orca-slicer --slice`) is a potential workaround with pre-configured profiles. |
| **Pipeline** | User describes part → Agent reads P1S constraints → Generates OpenSCAD → Renders preview → Iterates → Exports STL → User slices in Bambu Studio → Agent uploads .3mf via FTP → Starts print → Monitors via camera |
| **See** | [AI 3D Printing Design Guide](ai-3d-printing-design-guide.md) |

#### LLMto3D Multi-Agent Decomposition

| Attribute | Detail |
|-----------|--------|
| **What** | Academic architecture (Hizmi, Sterman, Austern — IJAC 2025) that splits 3D generation into three specialized agents: Decomposition → Code Generation → Assembly |
| **Why it matters** | Addresses core spatial reasoning weakness by separating "what should this look like?" from "how do I code it?" |
| **Status** | Published research, no production-ready implementation for OpenSCAD/P1S workflow yet |
| **Reference** | [LLMto3D (IJAC)](https://journals.sagepub.com/doi/10.1177/14780771251353792) |

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
| Design a functional part (enclosure, mount, bracket) | Claude + OpenSCAD (or MCP server / openscad-agent) |
| Design with fillets, chamfers, or STEP export | CadQuery or Zoo.dev Text-to-CAD |
| Quick visual prototype of a concept | PromptSCAD (browser) |
| Design in FreeCAD with AI help | FreeCAD MCP server |
| Control my P1S from Claude Code | Bambu MCP server |
| Optimize my Bambu Studio print settings | Slicer Copilot |
| Detect and stop failed prints | Obico (self-hosted) |
| Troubleshoot a print issue | Ask Claude/ChatGPT with your settings |
| Generate a nameplate, sign, or decorative print | PrintPal |
| Create an artistic/organic 3D model | Meshy, Tripo AI, or Hitem3D |
| Autonomous real-time print correction | LLM-3D Print (requires development) |
| End-to-end text → print pipeline | OpenSCAD agent + Bambu MCP (slicing gap remains manual) |

---

## Implementation Roadmap

```
Now          → Set up OpenSCAD MCP server or openscad-agent for AI-assisted design
             → Set up Bambu MCP server for P1S control from Claude Code
             → Install Obico for print failure detection

Next         → Install CadQuery for parts needing fillets/STEP export
             → Try Zoo.dev for STEP output when needed
             → Set up Slicer Copilot for settings optimization
             → Evaluate FreeCAD MCP server and PrintPal

Later        → Build the full text-to-print pipeline
             → Fork and adapt LLM-3D Print for P1S
             → Explore decorative model generation as needed
```
