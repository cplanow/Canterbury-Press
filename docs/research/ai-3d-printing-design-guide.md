# Using AI and LLMs to Design 3D Printable Components for the Bambu Lab P1S

## Executive Summary

AI-assisted 3D model generation for FDM printing has reached a genuinely useful — but not yet reliable — state as of early 2026. The landscape spans three distinct approaches, each with different trade-offs:

1. *Code-generation pipelines* (LLM → OpenSCAD/CadQuery → STL) — the most controllable and print-ready approach. LLMs generate parametric code that produces manifold, dimensionally accurate geometry. This is where the P1S's design constraints (wall thickness, clearances, tolerances) can be embedded as rules the AI follows.

2. *Text-to-CAD platforms* (Zoo/KittyCAD, PrintPal, Meshy) — cloud services that generate mesh geometry directly from text prompts. Faster for organic/artistic shapes, but output quality varies wildly and prints often require manual repair.

3. *Agentic workflows* (Claude Code + OpenSCAD MCP + Bambu MCP) — the most powerful approach, where an AI agent iteratively designs, previews, validates, and even sends prints to your P1S. This is the bleeding edge but has real working implementations.

The critical finding across all sources: *LLMs are surprisingly good at generating syntactically correct CAD code, but spatial reasoning remains their primary weakness* [1]. Models mix up axes, miscalculate clearances, and produce geometry that "looks right" in renders but fails mechanically. The solution is not better models — it's better workflows: embedding your printer's constraints into the prompt/system context, using visual feedback loops, and validating geometry before printing.

Your P1S's design constraints (0.4mm nozzle, 0.8mm min wall, 0.2mm XY clearance, etc.) are exactly the kind of structured rules that LLMs follow well when provided as system context. The enclosed chamber and AMS multi-material capability open up design possibilities (ABS, ASA, multi-color) that most AI workflows don't yet account for — a gap you can fill with custom prompting.

---

## Approach 1: Code-Generation Pipelines (Most Reliable for Functional Parts)

### Why Code-Based CAD Is the Best Fit

LLMs produce text. CAD code is text. The alignment is natural, and the outputs are:
- *Parametric*: Change a dimension and the whole model updates
- *Manifold by construction*: OpenSCAD's CSG operations produce watertight geometry
- *Inspectable*: You can read the code and verify the design logic
- *Version-controllable*: Git-friendly, diffable, reviewable
- *Constraint-embeddable*: Your printer profile becomes part of the prompt

### OpenSCAD: The Default Choice

OpenSCAD is the most commonly used target for LLM-generated CAD code [1][2]. It's declarative, functional, and produces guaranteed-manifold output via CSG (Constructive Solid Geometry). Every `union()`, `difference()`, and `intersection()` produces a valid solid.

*How it works with LLMs:*
1. You describe the part in natural language: "Design a cable management clip that snaps onto a 25mm desk edge with a 10mm cable channel"
2. The LLM generates OpenSCAD code with your printer constraints baked in
3. OpenSCAD renders a preview image
4. You iterate: "The snap tab is too thin, make it 2mm and add a 15° draft angle"
5. Export STL → slice in Bambu Studio → print

*Strengths:* Guaranteed manifold output, parametric, inspectable, free
*Weaknesses:* Limited to CSG primitives (no fillets natively until OpenSCAD 2025+), verbose syntax, no STEP export

### CadQuery: The More Powerful Alternative

CadQuery is a Python-based parametric CAD library built on the Open CASCADE kernel (the same kernel as FreeCAD and Fusion 360) [3]. It's significantly more capable than OpenSCAD:

- Native fillets and chamfers
- STEP, IGES, and STL export
- Full BREP (Boundary Representation) modeling — not just CSG
- Python ecosystem integration (numpy, scipy for calculations)
- Better for mechanical parts with complex geometry

Recent research (Text-to-CadQuery, May 2025) fine-tuned LLMs specifically for CadQuery code generation, achieving 69.3% exact match on a 170K annotation dataset [3]. This means LLMs can generate CadQuery code with reasonable accuracy.

*Strengths:* More powerful geometry, STEP export, Python native, fillets/chamfers
*Weaknesses:* Harder to install than OpenSCAD, less LLM training data, requires Python environment

### Embedding Your P1S Constraints

The most important optimization for print-ready AI-generated models: *give the LLM your printer profile as system context*. Here's a template based on Chris's P1S specs:

```
## 3D Printing Design Constraints (Bambu Lab P1S, 0.4mm nozzle, PLA)

### Dimensional Rules (MUST follow)
- Minimum wall thickness: 0.8mm (2 perimeters × 0.4mm nozzle)
- Standard wall thickness: 1.2mm (3 perimeters — use as default)
- Structural/screw boss walls: 2.0mm minimum
- XY clearance for loose fit (lid on box): 0.2mm per side
- Press-fit interference: 0.1mm per side
- Hole clearance for screws/pins: +0.3mm over nominal diameter
- Maximum build volume: 256 × 256 × 256mm

### Layer Height Options
- Fine detail: 0.08mm (slow, high quality)
- Standard: 0.20mm (good default)
- Draft: 0.28mm (fast prototyping)
- Standard floor/ceiling: 1.2mm (6 layers at 0.20mm)

### FDM Design Rules (MUST follow)
- No unsupported overhangs beyond 45° without designing in support or bridging
- Bridges up to 20mm are reliable; beyond that, add support geometry
- Minimum horizontal hole diameter: 2mm (smaller holes close up)
- Vertical holes print well; horizontal holes need teardrop/keyhole shapes
- Elephant foot compensation: first layer expands ~0.1-0.2mm
- Snap fits: design flexure arms minimum 1.2mm thick, 8-12mm long
- Thread features: use heat-set inserts over printed threads for M3+
- Chamfer bottom edges 0.4mm to avoid elephant foot visibility

### Material Notes
- PLA: Standard, easiest, good for prototypes. Glass transition ~60°C.
- PETG: Better layer adhesion, slight stringing. Good for functional parts.
- ABS/ASA: Requires enclosed chamber (P1S has this). Warp-prone. Best for high-temp or outdoor.
- TPU: Flexible. Slow print speeds (30-40mm/s). Direct drive compatible.

### Multi-Material (AMS)
- Available: 4 filament slots
- Color changes add ~30s per change
- Purge tower required (~3-5g waste per change)
- Design for minimal color transitions where possible
```

This block, included in the system prompt or CLAUDE.md/AGENTS.md of your CAD agent, dramatically improves output quality because the LLM can check every dimension against concrete rules rather than guessing.

### Practical Prompt Engineering for OpenSCAD

Based on practitioner reports [1][4], these prompting strategies produce the best results:

*Good prompts:*
- "Design a parametric phone stand for a phone that is 75mm wide and 8mm thick. The stand should hold the phone at a 65° angle. Use the printer constraints above. Add a cable pass-through at the bottom center, 15mm wide × 8mm tall."
- "Create a snap-fit enclosure for a Raspberry Pi 4B (85.6 × 56.5 × 17mm PCB). The case should have a 1.2mm wall, 0.2mm clearance on all sides, ventilation slots on top, and access ports for USB, Ethernet, micro-HDMI, and power."

*Bad prompts:*
- "Make a cool phone stand" (too vague — no dimensions, no constraints)
- "Design a complex gearbox" (too ambitious — gears require precise involute curves that LLMs can't reliably generate)

*Iteration patterns that work:*
- "The cable slot is too close to the edge — move it 5mm inward"
- "Add 0.5mm fillets to all external edges" (OpenSCAD 2025+ or use `minkowski()`)
- "The snap tab broke during testing. Increase thickness from 1.2mm to 2mm and extend the arm to 15mm"
- "That hole is for an M3 screw — apply the 0.3mm hole clearance from the constraints"

*Common LLM failures to watch for:*
- *Axis confusion*: "Rotate 90° around X" and the model rotates around Z. Ask the LLM to add orientation comments and render a preview.
- *Scale errors*: LLMs sometimes produce models in inches instead of mm, or get an order of magnitude wrong. Always check the overall bounding box.
- *Floating geometry*: Parts that look connected in the render but aren't actually joined via `union()`. Validate in the slicer.
- *Thin walls*: LLMs default to aesthetically thin features. Your constraint block prevents this if included in context.

---

## Approach 2: Text-to-CAD Platforms (Best for Organic/Artistic Models)

### Zoo (formerly KittyCAD) — Zookeeper

[zoo.dev/text-to-cad](https://zoo.dev/text-to-cad) [5]

Zoo's ML-ephant model generates CAD geometry from text prompts, exportable as STL, STEP, OBJ, and more. Their Zookeeper agent (built into Zoo Design Studio) adds conversational refinement with engine-level geometry inspection.

- *Strengths:* Produces actual CAD (not mesh), STEP export, open-source UI, fast
- *Weaknesses:* Geometry quality varies, complex functional parts often need manual cleanup, primarily for simple shapes
- *Print readiness:* Medium. Output may need manifold repair before slicing
- *Your P1S:* Export STL → open in Bambu Studio → slice. No direct printer integration.

### PrintPal

[printpal.io](https://printpal.io/) [6]

Text-to-STL and image-to-STL generation. Explicitly designed for 3D printing — outputs are optimized for printability. Generates in under 60 seconds. Free tier available.

- *Strengths:* Purpose-built for printing, fast, free, exports STL/OBJ/GLB
- *Weaknesses:* Less control over parametric dimensions, better for artistic than mechanical parts
- *Print readiness:* High for organic shapes, medium for functional parts
- *Your P1S:* Explicitly compatible with Bambu Studio and OrcaSlicer

### Meshy

[meshy.ai](https://www.meshy.ai/) [7]

AI 3D model generator focused on game assets and artistic models. Text-to-3D and image-to-3D. Produces mesh geometry (not parametric CAD).

- *Strengths:* Best visual quality for organic/artistic models, texturing included
- *Weaknesses:* Output is mesh, not parametric. Often not manifold. Poor for functional/mechanical parts.
- *Print readiness:* Low without manual repair. Meshes often have non-manifold edges, inverted normals, or thin walls below printable threshold.
- *Your P1S:* Would need mesh repair (Meshmixer, Blender) before slicing

### When to Use Platforms vs. Code

| Use Case | Best Approach |
|----------|--------------|
| Functional mechanical part | Code (OpenSCAD/CadQuery) |
| Snap-fit enclosure | Code |
| Decorative figurine | Platform (Meshy, PrintPal) |
| Custom nameplate/sign | PrintPal (has a dedicated text tool) |
| Replacement bracket/clip | Code |
| Organic sculpture | Platform (Meshy) |
| Parametric design (adjustable dimensions) | Code |
| Quick concept visualization | Platform |

---

## Approach 3: Agentic Workflows (The Full Pipeline)

This is where it gets exciting for your P1S setup. Two MCP servers exist that, combined with Claude Code (or any MCP-capable agent), create a complete text-to-print pipeline.

### The OpenSCAD Agent (openscad-agent)

[github.com/iancanderson/openscad-agent](https://github.com/iancanderson/openscad-agent) [8]

A Claude Code-powered 3D modeling environment with three custom skills:
- `/openscad` — generates versioned SCAD files with automatic iteration
- `/preview-scad` — renders any SCAD file to PNG for visual feedback
- `/export-stl` — converts to STL with geometry validation

*Workflow:* Describe → Generate → Preview → Critique → Iterate → Validate → Export

The agent maintains version history (model_001.scad, model_002.scad, ...) and self-evaluates renders before presenting them. This is the closest thing to a "CAD copilot" that exists today.

### The OpenSCAD MCP Server

[github.com/jhacksman/OpenSCAD-MCP-Server](https://github.com/jhacksman/OpenSCAD-MCP-Server) [9]

An MCP server that gives any MCP-capable AI agent the ability to:
- Generate OpenSCAD code from text descriptions
- Render previews
- Export in parametric formats (CSG, AMF, 3MF, SCAD)
- Perform multi-view reconstruction from images
- Discover and send to 3D printers on the network

Can be added to Claude Code with:
```bash
claude mcp add-json "openscad-mcp-server" '{"command":"python","args":["src/main.py"]}'
```

### The Bambu Lab MCP Server

[github.com/schwarztim/bambu-mcp](https://github.com/schwarztim/bambu-mcp) [10]

An MCP server with 25 tools for controlling Bambu Lab printers (including the P1S) via local MQTT:

*Print Control:* start, stop, pause, resume, set speed, send G-code, print file
*Monitoring:* real-time status, cached status, firmware version
*Camera:* record video, timelapse
*AMS:* change filament, unload
*Hardware:* set temperature (nozzle/bed), nozzle selection, LED control
*File Management:* FTP upload of .gcode/.3mf files

*Connection:* Local MQTT over TLS (port 8883) using the printer's LAN access code. No cloud dependency.

*Safety guardrails:* Blocked dangerous G-codes, temperature limits (nozzle max 300°C, bed max 120°C), file type validation, path traversal prevention.

### The Dream Pipeline: Text → Design → Slice → Print

Combining these tools creates a pipeline where an AI agent can:

```
1. User: "Design a cable organizer for 4 USB-C cables,
          mount it under my desk with 3M VHB tape"
   ↓
2. Agent reads printer-profile constraints from CLAUDE.md
   ↓
3. Agent generates OpenSCAD code (via openscad-agent skills or MCP)
   ↓
4. Agent renders PNG preview → evaluates → iterates
   ↓
5. Agent exports STL with geometry validation
   ↓
6. User slices in Bambu Studio / OrcaSlicer (manual step)
   ↓
7. Agent uploads .3mf to P1S via Bambu MCP
   ↓
8. Agent starts print, monitors via camera + status polling
   ↓
9. Agent alerts when print completes or detects failure
```

Step 6 (slicing) is the current manual gap. No MCP server exists for OrcaSlicer/Bambu Studio yet. OrcaSlicer does have a CLI mode (`orca-slicer --slice`) that an agent could invoke, but profile management and material selection still require human judgment.

### Setting This Up

*Prerequisites:*
- Claude Code (or another MCP-capable agent) installed on your dev machine
- OpenSCAD installed locally (for rendering)
- Node.js 18+ (for Bambu MCP server)
- P1S with Developer Mode enabled (recommended) and LAN access code
- Network access to P1S (same LAN or VPN)

*Install:*
```bash
# 1. Clone and configure OpenSCAD agent
git clone https://github.com/iancanderson/openscad-agent
cd openscad-agent
# Follow README for Claude Code skill setup

# 2. Add Bambu MCP server
git clone https://github.com/schwarztim/bambu-mcp
cd bambu-mcp
npm install
# Configure with P1S IP, access code, and serial number

# 3. Add your printer profile to CLAUDE.md
# (Use the constraint block from Approach 1 above)
```

---

## The LLMto3D Research Framework

Worth noting: academic research on this exact problem is active. The LLMto3D paper [11] (Hizmi, Sterman, Austern — published in IJAC, 2025) describes a multi-agent architecture specifically for generating parametric 3D printable objects:

- *Agent 1 (Decomposition):* Breaks a text prompt into geometric primitives and spatial relationships
- *Agent 2 (Code Generation):* Translates descriptions into Rhino.Geometry code
- *Agent 3 (Assembly):* Reassembles components and adds parametric control interfaces

This three-agent approach addresses the core spatial reasoning problem by separating "what should this look like?" from "how do I code it?" — a pattern that applies directly to OpenSCAD/CadQuery workflows with Claude Code's agent teams.

---

## Contradictions Found

### 1. "OpenSCAD is the best target for LLM CAD" vs. "CadQuery produces better geometry"

*Position A:* OpenSCAD is the most common LLM target because it has more training data, simpler syntax, and guaranteed manifold output via CSG [1][2].

*Position B:* CadQuery's BREP kernel produces more sophisticated geometry (native fillets, chamfers, sweeps) and recent fine-tuning achieves 69.3% exact match on Text-to-CadQuery tasks [3].

*Evidence quality:* Multiple practitioner reports support OpenSCAD's ease-of-use advantage. The CadQuery research is a controlled study with quantitative results.

*Verdict:* For most 3D printing use cases, OpenSCAD is the pragmatic choice — it's simpler, better supported by existing tools (MCP servers, agents), and CSG guarantees printable geometry. CadQuery is better when you need fillets, complex sweeps, or STEP export for further editing in Fusion 360/FreeCAD. Start with OpenSCAD, graduate to CadQuery when you hit its limits. High confidence.

### 2. "AI can generate print-ready models" vs. "Spatial reasoning is fundamentally broken"

*Position A:* Tools like PrintPal and PromptSCAD generate "print-ready" models in under 60 seconds [6].

*Position B:* Research consistently finds LLM spatial reasoning is "really bad" — models mix up axes, miscalculate proportions, and produce mechanically unsound geometry [1].

*Evidence quality:* PrintPal's claim is marketing copy. The spatial reasoning limitation is documented across multiple academic and practitioner sources.

*Verdict:* Both are true for different use cases. Simple geometry (boxes, brackets, nameplates) is genuinely print-ready from AI. Complex functional parts (snap fits, gears, interlocking assemblies) require human review and iteration. The iterate-and-preview workflow is not a workaround — it's the core methodology. High confidence.

### 3. "Full automation: text to print" vs. "Slicing requires human judgment"

*Position A:* The OpenSCAD MCP + Bambu MCP pipeline can automate from text to print start [9][10].

*Position B:* Slicing decisions (layer height, infill, support placement, material selection) require understanding of the part's mechanical requirements that AI doesn't have.

*Evidence quality:* The MCP servers exist and work. The slicing gap is acknowledged by tool creators.

*Verdict:* The pipeline can be automated for known-good profiles (e.g., "PLA, 0.2mm, 15% infill" for non-structural parts). For functional parts where print orientation, support strategy, or infill pattern matters structurally, human judgment at the slicing step remains essential. OrcaSlicer's CLI mode could be agent-invoked with pre-configured profiles, but selecting the right profile is the hard part. Medium confidence that this gap closes within 12 months as slicer AI features improve.

---

## Recommendations

### High Confidence

- *Start with the OpenSCAD + Claude Code workflow.* The openscad-agent project provides a working skill-based setup. Add your P1S printer profile as system context. This is the fastest path to useful results.
- *Embed your printer constraints in the LLM context.* The constraint block above (walls, clearances, tolerances, FDM rules) is the single highest-impact optimization. Without it, LLMs generate aesthetically reasonable but mechanically broken geometry.
- *Use visual feedback loops.* Generate → render PNG → evaluate → iterate. Never export STL without previewing first. LLMs are better at correcting errors they can "see" in a render than errors described in text.
- *Validate geometry before slicing.* Import STL into Bambu Studio — it will flag non-manifold geometry, thin walls, and other printability issues. Fix in the CAD stage, not the slicer.

### Medium Confidence

- *Add the Bambu MCP server for print control.* Being able to upload and start prints from your AI agent is a genuine workflow improvement, especially for iterative prototyping. The safety guardrails are well-designed.
- *Use CadQuery for parts that need fillets, chamfers, or STEP export.* If you're designing parts that will be further refined in Fusion 360 or FreeCAD, CadQuery's BREP output is significantly better than OpenSCAD's mesh-only export.
- *Consider PrintPal for artistic/decorative prints.* It's purpose-built for printability and works well for non-functional geometry (decorations, signs, figurines). Free tier is sufficient for evaluation.

### Low Confidence

- *The multi-agent decomposition approach (LLMto3D pattern) may produce better results for complex parts.* Separating spatial reasoning from code generation is theoretically sound, but no production-ready implementation exists yet for the OpenSCAD/P1S workflow.
- *OrcaSlicer CLI automation may become viable soon.* The CLI exists, but agent-driven profile selection is unsolved. Worth watching but not ready for production workflows.

---

## Coverage Gaps & Limitations

### Well-Covered
- Code-generation pipelines (OpenSCAD, CadQuery) — 8+ sources from academic papers, practitioner guides, and tool documentation
- Text-to-CAD platforms (Zoo, PrintPal, Meshy) — 5+ sources
- MCP server integrations (OpenSCAD MCP, Bambu MCP) — directly verified from GitHub repos
- LLM spatial reasoning limitations — documented across multiple academic studies

### Thinly Covered
- *Long-term reliability of AI-generated functional parts.* No source provides data on how AI-designed snap fits, hinges, or load-bearing structures perform over time compared to human-designed equivalents.
- *Multi-material and multi-color AI design.* Your P1S supports AMS multi-material, but no AI workflow explicitly designs for color changes, support interfaces, or material transitions.

### Not Found
- *OrcaSlicer/Bambu Studio MCP server.* This is the missing link in the full pipeline. No one has built it yet.
- *AI-driven print failure analysis feedback loop.* The P1S has spaghetti detection via camera. An agent that watches the camera feed, detects failures, stops the print, analyzes what went wrong, redesigns the part, and reprints — this does not exist as a complete workflow, though all the individual components do.
- *Benchmarks of AI-generated vs. human-designed parts for FDM printing.* No controlled study compares dimensional accuracy, mechanical strength, or print success rates.

### Surprising Absences
- No Bambu Studio plugin for AI-assisted design, despite Bambu Lab's market position and the existence of MCP servers for their printers. The design-to-print pipeline is entirely community-built.
- No fine-tuned model specifically for FDM-constraint-aware CAD generation. All existing LLMs learn general CAD; none are trained with FDM printability rules as a first-class concern.

---

## Open Questions

The right level of automation in the design-to-print pipeline remains an open question. Full automation (text → print with zero human intervention) is technically possible for simple parts with known-good slicer profiles, but the question of when to trust AI geometry without human review depends on the consequences of failure. A decorative vase that fails wastes 2 hours of print time and $0.50 of PLA. A structural bracket that fails under load could damage equipment or cause injury. The workflow should match the review intensity to the part's risk profile — and no existing tool provides this classification automatically.

Whether OpenSCAD or CadQuery will emerge as the dominant LLM-CAD target is also unresolved. OpenSCAD has more existing tooling and training data, but CadQuery's Python-native approach and more powerful geometry kernel make it a better long-term bet as LLMs improve at Python generation. The Text-to-CadQuery research suggests the field is moving in this direction, but tooling (MCP servers, agents, preview pipelines) hasn't caught up yet.

Finally, the interaction between AI design and print optimization is largely unexplored. An AI that understands not just "how to model a bracket" but "how to model a bracket that prints fast, uses minimal material, and is strongest in the load direction" would be transformatively useful — but requires integrating slicer logic into the design loop, which no current tool does.

---

## Sources

[1] [Build Great AI: LLM-Powered 3D Model Generation for 3D Printing](https://www.zenml.io/llmops-database/llm-powered-3d-model-generation-for-3d-printing)
[2] [Mikołak: Making LLM Coding Assistants Create Physical Objects](https://xn--mikoak-6db.net/blog/2025/coding-llms-making-graphics-and-physical-things.html)
[3] [Text-to-CadQuery: A New Paradigm for CAD Generation (arXiv, May 2025)](https://arxiv.org/html/2505.06507v1)
[4] [PromptSCAD: AI-Powered OpenSCAD Generator](https://promptscad.com/)
[5] [Zoo Text-to-CAD / Zookeeper](https://zoo.dev/text-to-cad)
[6] [PrintPal: AI 3D Generator — Text & Image to CAD](https://printpal.io/3dgenerator)
[7] [Meshy AI: 3D Model Generator](https://www.meshy.ai/)
[8] [openscad-agent: Claude Code-Powered 3D Modeling Agent](https://github.com/iancanderson/openscad-agent)
[9] [OpenSCAD MCP Server (jhacksman)](https://github.com/jhacksman/OpenSCAD-MCP-Server)
[10] [Bambu Lab MCP Server — MQTT Control, FTP Upload, 25 Tools](https://github.com/schwarztim/bambu-mcp)
[11] [LLMto3D: Generation of Parametric, 3D Printable Objects Using LLMs (IJAC, 2025)](https://journals.sagepub.com/doi/10.1177/14780771251353792)
[12] [CAD-LLM: Large Language Model for CAD Generation (Autodesk Research)](https://www.research.autodesk.com/publications/ai-lab-cad-llm/)
[13] [Evaluating the Printability of STL Files with ML (arXiv)](https://arxiv.org/abs/2509.12392)
[14] [LLM-3D Print: LLMs to Monitor and Control 3D Printing](https://www.sciencedirect.com/science/article/pii/S2214860425003926)
[15] [CAD-MLLM: Unifying Multimodality-Conditioned CAD Generation](https://cad-mllm.github.io/)
[16] [Generating CAD Code with Vision-Language Models (arXiv)](https://arxiv.org/html/2410.05340v2)
[17] [CQAsk: Open Source LLM CAD Generation Tool (CadQuery)](https://github.com/OpenOrion/CQAsk)
[18] [OpenSCAD Claude Code Skill (FastMCP)](https://fastmcp.me/skills/details/1958/openscad)
[19] [Bambu Lab Third-Party Integration Wiki](https://wiki.bambulab.com/en/software/third-party-integration)
[20] [bambulabs-api Python Package (PyPI)](https://pypi.org/project/bambulabs-api/)
[21] [6 Tips to Make AI-Generated 3D Models Print-Ready (Sloyd)](https://www.sloyd.ai/blog/10-tips-for-creating-print-ready-3d-models-with-ai)
[22] [Top 10 ChatGPT Prompts for Generating 3D Models (PrintPal Blog, 2026)](https://blog.printpal.io/top-10-chatgpt-prompts-of-2026-for-generating-3d-models/)
[23] [BlenderLLM: LLM for CAD Script Generation in Blender](https://github.com/FreedomIntelligence/BlenderLLM)
[24] [Improving CAD Design with LLMs (Mila Quebec)](https://mila.quebec/en/article/improving-cad-design-with-llms)
