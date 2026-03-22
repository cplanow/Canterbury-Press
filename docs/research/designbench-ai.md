# DesignBench.ai — Research Report

**Date:** March 2026
**Relevance to Canterbury Press:** High (technique), Low (product itself)

---

## Important Disambiguation

The name "DesignBench" refers to three different things online:

1. **DesignBench.ai** — The subject of this report. An LLM-powered text-to-3D-printable-model web app.
2. **DEsignBench (Microsoft Research)** — A benchmark for evaluating DALL-E 3's visual design capabilities (image generation, not 3D). Located at `design-bench.github.io`.
3. **DesignBench (WebPAI)** — An academic benchmark for evaluating multimodal LLMs on front-end code generation (React, Vue, Angular). Published on arXiv in 2025-2026.

This report covers only #1.

---

## Overview

DesignBench.ai is a **pre-alpha prototype web application** that uses large language models to generate 3D-printable models from natural language descriptions. It was created by **Dan Becker**, founder of **Build Great AI**, a boutique AI consulting firm.

### Background on Creator

- Former data scientist at Google
- Led AI development tools at DataRobot
- Contributed to TensorFlow and Keras
- Educated 100,000+ students through deep learning courses on Kaggle and DataCamp

### Problem Statement

An estimated 90% of 3D printer owners don't fully utilize their printers because CAD software (FreeCAD, Fusion 360, SolidWorks) has a steep learning curve. DesignBench aims to let anyone describe an object in plain English and get a printable STL file in minutes.

### Target Audience

Home inventors and hobbyists making small functional objects — explicitly *not* professional architects or engineers.

---

## Capabilities

- **Text-to-3D:** Describe an object in natural language, receive multiple candidate 3D designs
- **Image-to-3D:** Upload a sketch or photo (via multimodal LLM) to generate a design
- **Iterative Refinement:** Select a promising design and refine through follow-up conversational prompts (e.g., "make the handle wider," "add a hole for hanging")
- **Multi-Model Generation:** Simultaneously queries multiple LLMs to produce varied candidate outputs
- **STL Export:** Produces downloadable STL files ready for slicing and 3D printing

### Demonstrated Example

A personalized cup was designed from initial prompt to final STL in a few minutes of conversation, then successfully 3D printed.

---

## Technical Architecture

DesignBench does **not** use diffusion models, NeRF, or neural mesh generation. Its approach is fundamentally different from tools like Meshy or Tripo3D.

### Core Pipeline

1. User provides a text prompt (or image)
2. Prompt sent simultaneously to **three LLMs in parallel**:
   - **GPT-4o** (OpenAI)
   - **Claude Sonnet 3.5** (Anthropic)
   - **Llama 3.1 70B** (Meta, served via Groq for speed)
3. Each LLM generates **OpenSCAD code** — programmatic CAD using CSG operations (union, difference, intersection of primitives)
4. Multiple **prompting strategies** used per model (Chain of Thought vs. direct), creating a matrix: `models x strategies x CAD languages`
5. OpenSCAD code compiled/rendered into 3D preview
6. Code exported as **STL files** via OpenSCAD's built-in export

### Why OpenSCAD Code Instead of Direct Mesh Generation

- **Inspectable and debuggable** — you can read and understand the generated geometry
- **Manually editable** — users who know OpenSCAD can refine the output
- **Parametric by nature** — dimensions can be changed by editing variables
- **Deterministically compiled** — always produces watertight meshes (unlike neural mesh generators that often produce non-manifold geometry)

### Why Multiple Models

Dan Becker noted that LLM spatial reasoning is "really bad" (as of August 2024). Many generated objects have detached parts, incorrect proportions, or nonsensical geometry. Running multiple models in parallel gives users variety — some outputs will be poor, but others will be closer to what's needed.

### Performance Notes

- Groq-served Llama results are significantly faster than GPT-4o or Claude
- Quality from Llama 3.1 70B and GPT-4o Mini was notably worse than GPT-4o and Claude Sonnet 3.5

---

## Output Formats

- **Primary output:** OpenSCAD source code (`.scad` files)
- **Exported format:** STL files
- STL files are **geometrically valid** (watertight meshes from CSG operations), a significant advantage over neural mesh generators

---

## Availability

| Attribute | Detail |
|-----------|--------|
| **Website** | `designbench.ai` |
| **Status** | Pre-alpha / dormant hobby project (as of Aug 2024; no evidence of major updates) |
| **Pricing** | Free, no monetization |
| **API** | No public API |
| **Open Source** | No (no public GitHub repository) |
| **Community** | Minimal — no Reddit discussions, YouTube demos, or user reviews found |
| **Current State (Mar 2026)** | Website exists but project appears dormant. Build Great AI's main website makes no mention of DesignBench. |

---

## Limitations

### Fundamental LLM Spatial Reasoning Limitations

- LLMs struggle with spatial awareness — generated objects frequently have detached parts, incorrect proportions, or impossible geometry
- Complex organic shapes are out of reach; OpenSCAD is limited to CSG on primitives
- Dimensional accuracy is weak — studies show errors persist in ~20-26% of generations

### OpenSCAD-Specific Limitations

- Limited to CSG modeling (unions, differences, intersections of cubes, spheres, cylinders)
- No freeform surfaces, NURBS, or organic shapes
- No native fillets or chamfers (approximations only)
- Complex assemblies with tolerances, snap-fits, or threads are very difficult for LLMs to generate correctly

### Practical 3D Printing Concerns

- No awareness of print orientation, overhang angles, or support requirements
- No tolerance compensation for printer-specific dimensional shrinkage
- No awareness of material properties (wall thickness minimums, bridging limits)
- Scoped for "small home inventor" projects, not precision engineering

---

## Successor Tools and Alternatives

The approach DesignBench proved — LLM generates OpenSCAD code, compiles to STL — has been adopted by better-maintained tools:

| Tool | Description | Status | Link |
|------|-------------|--------|------|
| **PromptSCAD** | Free, browser-based, uses DeepSeek v3, runs OpenSCAD WASM in-browser | Active, free | [promptscad.com](https://promptscad.com/) |
| **OpenSCAD MCP Servers** | Multiple implementations letting Claude/ChatGPT drive OpenSCAD via MCP protocol | Active, open source | [jkoets](https://github.com/jkoets/OpenSCAD-MCP), [jhacksman](https://playbooks.com/mcp/jhacksman-openscad), [quellant](https://github.com/quellant/openscad-mcp), [petrijr](https://github.com/petrijr/openscad-mcp) |
| **ScadLM** | Open-source agentic AI CAD generation built on OpenSCAD | Active, open source | GitHub |
| **SCADBench** | Benchmark/arena comparing AI models on OpenSCAD generation quality | Active | [scadbench.com](http://www.scadbench.com/) |
| **Zoo.dev Text-to-CAD** | Generates B-Rep STEP files (not mesh), importable into any CAD program | Active, freemium ($0.50/min) | [zoo.dev](https://zoo.dev/text-to-cad) |

---

## Integration Assessment for Canterbury Press

### Direct Integration: Not Recommended

DesignBench.ai itself is dormant and has no API. Not suitable for integration.

### Technique Integration: Highly Recommended

The LLM-to-OpenSCAD pattern is ideal for Canterbury Press:

- Our `lib/` shared modules (printer-profile, enclosure-utils, connectors, etc.) can be provided as context to an LLM
- The LLM generates `.scad` code that `include`s our libraries and references our P1S tolerances
- Output is fully parametric and editable
- **Best implementation path:** OpenSCAD MCP server connected to Claude

### Recommended Approach

Instead of depending on DesignBench.ai, use:
1. **Claude directly** — prompt it to generate OpenSCAD code using our shared libraries
2. **OpenSCAD MCP Server** — for tighter iterative feedback loop
3. **PromptSCAD** — for quick browser-based generation without setup

---

## Sources

- [Build Great AI: LLM-Powered 3D Model Generation for 3D Printing (ZenML case study)](https://www.zenml.io/llmops-database/llm-powered-3d-model-generation-for-3d-printing)
- [DesignBench.ai](https://www.designbench.ai/)
- [Build Great AI](https://www.buildgreat.ai/)
- [SCADBench — AI 3D Model Generation Benchmark](http://www.scadbench.com/)
- [PromptSCAD](https://promptscad.com/)
- [Zoo.dev Text-to-CAD](https://zoo.dev/text-to-cad)
- [Sergio Carracedo: Designing Physical Items with LLMs](https://sergiocarracedo.es/designing-physical-items-with-llms/)
- [Xometry: We Tested 7 Text-to-CAD Tools](https://xometry.pro/en-eu/articles/text-to-cad-tools-test/)
- [The AI Engineer's Guide to the OpenSCAD MCP Server](https://skywork.ai/skypage/en/ai-engineer-openscad-mcp-server/1980872653259997184)
